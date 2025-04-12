import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/globals.dart';
import 'package:mypost/logic/toggle_cubit/toggle_cubit.dart';
import 'package:mypost/presentation/screens/create_post_screen.dart';
import 'package:mypost/presentation/screens/create_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ToggleCubit toggleCubit;

  @override
  void initState() {
    toggleCubit = BlocProvider.of<ToggleCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: isDark ? Color(0xFF4A148C) : Color(0xFFBA68C8),
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(title: Text("Welcome to MyPost"), centerTitle: true),
          body: buildBody(context: context),
        ),
      ),
    );
  }

  buildBody({required BuildContext context}) {
    return BlocBuilder<ToggleCubit, double>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Visibility(
                visible:
                    (userProfileData != null && userProfileData?.image != null),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      (userProfileData != null &&
                              userProfileData?.image != null)
                          ? FileImage(File(userProfileData!.image))
                          : null,
                ),
              ),
              Text(
                "Hi, ${userProfileData?.name} ",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              Text(
                "Welcome to MyPost, We are here to help you to, Create youe own post easily",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text("So, Let's begin...."),
              Text("Hurrrey.....!"),
              SizedBox(height: 50),

              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CreateProfileScreen(
                            isUpdating: userProfileData != null,
                          ),
                    ),
                  );
                  toggleCubit.refreshScreen();
                },
                child: Card(
                  shadowColor: Colors.grey,
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Center(
                      child: Text(
                        userProfileData != null
                            ? "Update Profile"
                            : "Create Profile",
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreatePostScreen()),
                  );
                },
                child: Card(
                  shadowColor: Colors.grey,
                  child: SizedBox(
                    height: 50,
                    width: 200,
                    child: Center(child: Text("Create Post")),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
