// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/common/app_colors.dart';
import 'package:mypost/logic/profile_cubit/profile_cubit.dart';
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
        appBar: AppBar(title: Text("Create Profile"), centerTitle: true),
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
                  Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      top: 5,
                      right: 10,
                      bottom: 5,
                    ),
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
                          height: 70,
                          width: 70,
                          clipBehavior: Clip.antiAlias,
                          child:
                              (profileCubit.profileImage == '')
                                  ? Image.asset(
                                    "assets/icons/camera-icon.png",
                                    height: 60,
                                    width: 60,
                                  )
                                  : Image.file(
                                    File(profileCubit.profileImage),
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.fill,
                                  ),
                        ),
                        GestureDetector(
                          onTap: () {
                            profileCubit.getProfileImage();
                          },
                          child: Text(
                            "Upload Profile Image",
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      top: 5,
                      right: 10,
                      bottom: 5,
                    ),
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
                          height: 70,
                          width: 70,
                          clipBehavior: Clip.antiAlias,
                          child:
                              (profileCubit.businessLogo == '')
                                  ? Image.asset(
                                    "assets/icons/camera_placeholder.png",
                                    height: 30,
                                    width: 30,
                                  )
                                  : Image.file(
                                    File(profileCubit.businessLogo),
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.fill,
                                  ),
                        ),
                        GestureDetector(
                          onTap: () {
                            profileCubit.getBusinessLogo();
                          },
                          child: Text(
                            "Upload Business Logo",
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: profileCubit.businessNameController,
                    decoration: const InputDecoration(
                      labelText: 'Business Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: profileCubit.nameController,
                    decoration: const InputDecoration(
                      labelText: 'Your Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: profileCubit.mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: profileCubit.occepationController,
                    decoration: const InputDecoration(
                      labelText: 'Occupation',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: profileCubit.emailController,
                    decoration: const InputDecoration(
                      labelText: 'Your Email Id',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDateTile(context: context),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      bool ret = await profileCubit.saveUserData(
                        context: context,
                      );
                      if (ret == true) {
                        CustomSnackbar.show(
                          snackbarType: SnackbarType.SUCCESS,
                          message: "Profile Created",
                          context: context,
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Card(
                      child: SizedBox(
                        height: 50,
                        width: 140,
                        child: Center(child: Text("Save Data")),
                      ),
                    ),
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

  Widget _buildDateTile({required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        profileCubit.getBOD(context: context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          title: Text(
            profileCubit.birthDay ?? "Select Birth Day",
            style: TextStyle(
              color: profileCubit.birthDay == null ? Colors.grey : Colors.black,
            ),
          ),
          // trailing: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
        ),
      ),
    );
  }
}
