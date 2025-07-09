import 'dart:io';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mypost/common/app_colors.dart';
import 'package:mypost/common/app_constants.dart';
import 'package:mypost/common/hive_constants.dart';
import 'package:mypost/data/model/user_model.dart';
import 'package:mypost/globals.dart';
import 'package:mypost/presentation/custom_widget/custom_snackbar.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';

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
  bool isGettingTransparentImage = false;

  Future<bool> picCameraImage({
    required BuildContext context,
    required bool settingProfile,
  }) async {
    File? newFile;
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      newFile = await cropImage(context: context, imageFile: image);
    }
    if (newFile != null) {
      if (settingProfile) {
        profileImage = newFile.path;
      } else {
        businessLogo = newFile.path;
      }
    } else if (image != null) {
      if (settingProfile) {
        profileImage = image.path;
      } else {
        businessLogo = image.path;
      }
    }

    emit(Random().nextDouble());
    return true;
  }

  Future<bool?> picGalleyImage({
    required BuildContext context,
    required bool settingProfile,
  }) async {
    File? newFile;
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      newFile = await cropImage(context: context, imageFile: image);
    }
    if (newFile != null) {
      if (settingProfile) {
        profileImage = newFile.path;
      } else {
        businessLogo = newFile.path;
      }
    } else if (image != null) {
      if (settingProfile) {
        profileImage = image.path;
      } else {
        businessLogo = image.path;
      }
    } else if (image != null) {
      if (settingProfile) {
        profileImage = image.path;
      } else {
        businessLogo = image.path;
      }
    }

    emit(Random().nextDouble());
    return true;
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

  Future<File?> cropImage({
    required BuildContext context,
    required XFile imageFile,
  }) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: AppColors.primaryColor,
          statusBarColor: AppColors.primaryColor,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],
        ),
        WebUiSettings(context: context),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  getTransparantImage() async {
    isGettingTransparentImage = true;
    emit(Random().nextDouble());
    try {
      List<MapEntry<String, dio.MultipartFile>> multipleImages = [];

      multipleImages.add(
        MapEntry(
          "img",
          await dio.MultipartFile.fromFile(
            profileImage,
            contentType: DioMediaType("image", "*/*"),
          ),
        ),
      );

      var formData = dio.FormData.fromMap({});
      formData.files.addAll(multipleImages);

      final response = await Dio().post(
        'https://dmt.oceanmtechrnd.com/background-remover',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            "Accept": 'application/json',
          },
        ),
      );

      if ((response.data['message'] == 'success') &&
          (response.data['status'] == 200)) {
        profileImage = response.data['url'];
        isGettingTransparentImage = false;
        emit(Random().nextDouble());
      }
    } catch (e) {
      print("object => Exception : $e");
    }
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
