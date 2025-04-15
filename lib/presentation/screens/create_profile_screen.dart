// ignore_for_file: use_build_context_synchronously

import 'dart:io';

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
    return SafeArea(
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
    );
  }

  buildBody({required BuildContext context}) {
    return BlocBuilder<ProfileCubit, double>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  imagePicker(
                    title: AppConstants.uploadProfileImage,
                    imagePath: profileCubit.profileImage,
                    onTap: () => profileCubit.getProfileImage(),
                  ),
                  const SizedBox(height: 10),
                  imagePicker(
                    title: AppConstants.uploadBusinessLogo,
                    imagePath: profileCubit.businessLogo,
                    onTap: () => profileCubit.getBusinessLogo(),
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
                      bool ret = await profileCubit.saveUserData(
                        context: context,
                      );
                      if (ret == true) {
                        CustomSnackbar.show(
                          snackbarType: SnackbarType.SUCCESS,
                          message: AppConstants.profileCreatedMsg,
                          context: context,
                        );
                        Navigator.pop(context);
                      }
                    },
                    title:
                        widget.isUpdating
                            ? AppConstants.updateProfile
                            : AppConstants.createProfile,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
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
                      ? Image.asset(
                        "assets/icons/camera-icon.png",
                        height: 60,
                        width: 60,
                      )
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
}
