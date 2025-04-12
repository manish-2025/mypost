import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mypost/common/hive_constants.dart';
import 'package:mypost/data/model/user_model.dart';
import 'package:mypost/globals.dart';
import 'package:mypost/presentation/custom_widget/custom_snackbar.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<double> {
  ProfileCubit() : super(1);

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController occepationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String profileImage = '';
  final ImagePicker picker = ImagePicker();
  String? birthDay;

  void getProfileImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImage = image.path;
    }
    emit(Random().nextDouble());
  }

  Future<bool> saveUserData({required BuildContext context}) async {
    if (!validateFormData(context: context)) {
      return false;
    }

    Map<String, dynamic> userData = {
      "name": nameController.text,
      "mobile": mobileController.text,
      "occupation": occepationController.text,
      "email": emailController.text,
      "image": profileImage,
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
    if (profileImage == '') {
      showSnacBar(message: "Select Profile Image", context: context);
      return false;
    }
    if (nameController.text.isEmpty) {
      showSnacBar(message: "Enter a valid Name", context: context);
      return false;
    }
    if (mobileController.text.isEmpty) {
      showSnacBar(message: "Enter a valid Mobile number", context: context);
      return false;
    }
    if (occepationController.text.isEmpty) {
      showSnacBar(message: "Enter Occupation", context: context);
      return false;
    }
    if (emailController.text.isEmpty) {
      showSnacBar(message: "Enter vailid Email", context: context);
      return false;
    }
    if (birthDay == null || birthDay == '') {
      showSnacBar(message: "Select your BirthDay", context: context);
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
  }
}
