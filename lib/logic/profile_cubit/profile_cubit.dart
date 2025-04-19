import 'dart:io';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mypost/common/app_constants.dart';
import 'package:mypost/common/hive_constants.dart';
import 'package:mypost/data/model/user_model.dart';
import 'package:mypost/globals.dart';
import 'package:mypost/presentation/common_widgets.dart';
import 'package:mypost/presentation/custom_widget/custom_snackbar.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<double> {
  ProfileCubit() : super(1);

  TextEditingController businessNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController occepationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String profileImage = '';
  String businessLogo = '';

  final ImagePicker picker = ImagePicker();
  String? birthDay;

  void picCameraImage({
    required BuildContext context,
    required bool settingProfile,
  }) async {
    File? newFile;
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      newFile = await CommonWidgets().cropImage(
        context: context,
        imageFile: image,
      );
    }
    if (newFile != null) {
      if (settingProfile) {
        profileImage = newFile.path;
      } else {
        businessLogo = newFile.path;
      }
    }
    emit(Random().nextDouble());
  }

  void picGalleyImage({
    required BuildContext context,
    required bool settingProfile,
  }) async {
    File? newFile;
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      newFile = await CommonWidgets().cropImage(
        context: context,
        imageFile: image,
      );
    }
    if (newFile != null) {
      if (settingProfile) {
        profileImage = newFile.path;
      } else {
        businessLogo = newFile.path;
      }
    }
    emit(Random().nextDouble());
  }

  Future<bool> saveUserData({required BuildContext context}) async {
    if (!validateFormData(context: context)) {
      return false;
    }

    Map<String, dynamic> userData = {
      "businessName": businessNameController.text,
      "name": nameController.text,
      "mobile": mobileController.text,
      "occupation": occepationController.text,
      "email": emailController.text,
      "image": profileImage,
      "businessLogo": businessLogo,
      "birthDay": birthDay,
    };
    try {
      UserModel user = UserModel.fromJson(userData);
      userProfileData = user.userData;

      await userBox.put(HiveConstants.USER_DATA, userProfileData);
      emit(Random().nextDouble());
      return true;
    } catch (e) {
      emit(Random().nextDouble());
      return false;
    }
  }

  void removeImage() {
    profileImage = '';
    emit(Random().nextDouble());
  }

  void getBOD({required BuildContext context}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1997, 07, 17),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    birthDay = picked!.toIso8601String().split('T')[0];
    emit(Random().nextDouble());
  }

  bool validateFormData({required BuildContext context}) {
    if (businessLogo == '') {
      showSnacBar(message: AppConstants.selectBusinessLogo, context: context);
      return false;
    }
    if (profileImage == '') {
      showSnacBar(message: AppConstants.selectProfileImage, context: context);
      return false;
    }
    if (businessNameController.text.isEmpty) {
      showSnacBar(
        message: AppConstants.enterValidBusinessName,
        context: context,
      );
      return false;
    }
    if (nameController.text.isEmpty) {
      showSnacBar(message: AppConstants.enterValidName, context: context);
      return false;
    }
    if (mobileController.text.isEmpty) {
      showSnacBar(message: AppConstants.enterValidMobile, context: context);
      return false;
    }
    if (occepationController.text.isEmpty) {
      showSnacBar(message: AppConstants.enterOccupation, context: context);
      return false;
    }
    if (emailController.text.isEmpty) {
      showSnacBar(message: AppConstants.enterValidEmail, context: context);
      return false;
    }
    if (birthDay == null || birthDay == '') {
      showSnacBar(message: AppConstants.selectBirthDay, context: context);
      return false;
    }
    return true;
  }

  void showSnacBar({required String message, required BuildContext context}) {
    CustomSnackbar.show(
      snackbarType: SnackbarType.ERROR,
      message: message,
      context: context,
    );
  }

  void setProfileForm() {
    nameController.text = userProfileData?.name ?? '';
    mobileController.text = userProfileData?.mobile ?? '';
    occepationController.text = userProfileData?.occupation ?? '';
    emailController.text = userProfileData?.email ?? '';
    birthDay = userProfileData?.birthDay ?? '';
    profileImage = userProfileData?.image ?? '';
    businessLogo = userProfileData?.businessLogo ?? '';
    businessNameController.text = userProfileData?.businessName ?? '';
  }
}
