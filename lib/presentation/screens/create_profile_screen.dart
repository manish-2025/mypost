// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/common/app_colors.dart';
import 'package:mypost/common/app_constants.dart';
import 'package:mypost/logic/profile_cubit/profile_cubit.dart';
import 'package:mypost/presentation/common_widgets.dart';
import 'package:mypost/presentation/custom_widget/custom_snackbar.dart';

class CreateProfileScreen extends StatefulWidget {
  final bool isUpdating;
  const CreateProfileScreen({super.key, required this.isUpdating});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  late ProfileCubit profileCubit;
  late Size screenSize;

  @override
  void initState() {
    profileCubit = BlocProvider.of<ProfileCubit>(context);
    if (widget.isUpdating) {
      profileCubit.setProfileForm();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.isUpdating
                  ? AppConstants.titleUpdateProfile
                  : AppConstants.titleCreateProfile,
            ),
            centerTitle: true,
          ),
          body: buildBody(context: context),
        ),
      ),
    );
  }

  buildBody({required BuildContext context}) {
    return BlocBuilder<ProfileCubit, double>(
      builder: (context, state) {
        return Stack(
          children: [buildFormDataWidget(context), buildLoadingWidget()],
        );
      },
    );
  }

  Widget buildFormDataWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 20),
              imagePicker(
                title: AppConstants.uploadProfileImage,
                imagePath: profileCubit.profileImage,
                onTap: () {
                  openCameraAndGalleryOption(
                    context: context,
                    settingProfile: true,
                  );
                },
              ),
              const SizedBox(height: 10),
              imagePicker(
                title: AppConstants.uploadBusinessLogo,
                imagePath: profileCubit.businessLogo,
                onTap: () {
                  openCameraAndGalleryOption(
                    context: context,
                    settingProfile: false,
                  );
                },
              ),
              const SizedBox(height: 20),
              CommonWidgets().commonTextFormField(
                controller: profileCubit.businessNameController,
                lalbleText: AppConstants.businessName,
              ),
              CommonWidgets().commonTextFormField(
                controller: profileCubit.nameController,
                lalbleText: AppConstants.yourName,
              ),
              CommonWidgets().commonTextFormField(
                controller: profileCubit.mobileController,
                lalbleText: AppConstants.mobileNum,
              ),
              CommonWidgets().commonTextFormField(
                controller: profileCubit.occepationController,
                lalbleText: AppConstants.enterOccupation,
              ),
              CommonWidgets().commonTextFormField(
                controller: profileCubit.emailController,
                lalbleText: AppConstants.email,
              ),
              _buildDateTile(context: context),
              const SizedBox(height: 20),
              CommonWidgets().commonButton(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  bool ret = await profileCubit.saveUserData(context: context);
                  if (ret == true) {
                    Navigator.pop(context);
                    CustomSnackbar.show(
                      snackbarType: SnackbarType.SUCCESS,
                      message: AppConstants.profileCreatedMsg,
                      context: context,
                    );
                  }
                },
                title:
                    widget.isUpdating
                        ? AppConstants.update
                        : AppConstants.create,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoadingWidget() {
    return Visibility(
      visible: profileCubit.isGettingTransparentImage,
      child: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(color: Colors.black38),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget imagePicker({
    required String title,
    required String imagePath,
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 5, top: 5, right: 10, bottom: 5),
        decoration: BoxDecoration(
          color: AppColors.cardBGColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              height: 65,
              width: 65,
              clipBehavior: Clip.antiAlias,
              child:
                  (imagePath == '')
                      ? Icon(
                        title.contains("Profile") ? Icons.person : Icons.image,
                        color: Colors.black,
                        size: title.contains("Profile") ? 40 : 35,
                      )
                      : imagePath.startsWith('http')
                      ? CachedNetworkImage(imageUrl: imagePath)
                      : Image.file(
                        File(imagePath),
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTile({required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        profileCubit.getBOD(context: context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Row(
            children: [
              SizedBox(width: 10),
              Text(
                profileCubit.birthDay ?? AppConstants.selectBOD,
                style: TextStyle(
                  color:
                      profileCubit.birthDay == null
                          ? Colors.grey
                          : Colors.black,
                ),
              ),
              Spacer(),
              Icon(Icons.calendar_month, color: Colors.black),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }

  openCameraAndGalleryOption({
    required BuildContext context,
    required bool settingProfile,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.dialogBGColor,
              border: Border.all(color: AppColors.borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppConstants.chooseImage,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imagePickerOptionWidget(
                      context: context,
                      settingProfile: settingProfile,
                      title: AppConstants.camera,
                      onTap: () async {
                        Navigator.pop(context);

                        await profileCubit.picCameraImage(
                          context: context,
                          settingProfile: settingProfile,
                        );
                        // if (settingProfile) {
                        //   bool? data = await _showConfirmDialog();
                        //   if (data == true) {
                        //     profileCubit.getTransparantImage();
                        //   }
                        // }
                      },
                      icon: Icon(
                        Icons.camera_alt_sharp,
                        color: Colors.black,
                        size: 35,
                      ),
                    ),
                    SizedBox(width: 20),
                    imagePickerOptionWidget(
                      context: context,
                      settingProfile: settingProfile,
                      title: AppConstants.gallery,
                      onTap: () async {
                        Navigator.pop(context);
                        profileCubit.picGalleyImage(
                          context: context,
                          settingProfile: settingProfile,
                        );
                        if (settingProfile) {
                          bool? data = await _showConfirmDialog();
                          if (data == true) {
                            profileCubit.getTransparantImage();
                          }
                        }
                      },
                      icon: Icon(Icons.image, color: Colors.black, size: 35),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonWidgets().commonButton(
                      width: 60,
                      height: 25,
                      fSize: 10,
                      title: AppConstants.cancel,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget imagePickerOptionWidget({
    required BuildContext context,
    required bool settingProfile,
    required void Function()? onTap,
    required String title,
    required Widget icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          children: [
            icon,
            Text(
              title,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog() async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppConstants.background, style: TextStyle(fontSize: 18)),
                SizedBox(height: 15),
                Text(
                  AppConstants.backgroundMessage,
                  style: TextStyle(fontSize: 13, color: AppColors.greyColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonWidgets().commonButton(
                      title: AppConstants.no,
                      onTap: () => Navigator.pop(context, false),
                      height: 25,
                      width: 60,
                      fSize: 11,
                      radious: 5,
                    ),
                    SizedBox(width: 10),
                    CommonWidgets().commonButton(
                      title: AppConstants.yes,
                      onTap: () => Navigator.pop(context, true),
                      height: 25,
                      width: 60,
                      fSize: 11,
                      radious: 5,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed == true) {
      return true;
    } else {
      return false;
    }
  }
}
