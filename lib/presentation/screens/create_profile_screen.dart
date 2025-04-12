// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            (profileCubit.profileImage != '')
                                ? FileImage(File(profileCubit.profileImage))
                                : null,
                        child:
                            (profileCubit.profileImage == '')
                                ? Image.asset(
                                  "assets/icons/camera_placeholder.png",
                                  height: 60,
                                  width: 60,
                                )
                                : null,
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Visibility(
                          visible: profileCubit.profileImage != '',
                          child: GestureDetector(
                            onTap: () {
                              profileCubit.removeImage();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white),
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      profileCubit.getProfileImage();
                    },
                    child: const Text('Upload Profile Image'),
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
