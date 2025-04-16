import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/common/app_constants.dart';
import 'package:mypost/globals.dart';
import 'package:mypost/logic/toggle_cubit/toggle_cubit.dart';
import 'package:mypost/presentation/common_widgets.dart';
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
          appBar: AppBar(
            title: Text(AppConstants.titleWelcomeScreen),
            centerTitle: true,
          ),
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
                userProfileData?.name != null
                    ? "Hi, ${userProfileData?.name} "
                    : "Hi, Hero ",
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
              Text(
                AppConstants.welcomeMsg,
                style: TextStyle(),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              CommonWidgets().adWidget(
                height: 120,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(height: 10),
              CommonWidgets().commonButton(
                width: 200,
                title:
                    userProfileData != null
                        ? AppConstants.titleUpdateProfile
                        : AppConstants.titleCreateProfile,
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
              ),
              CommonWidgets().commonButton(
                width: 200,
                title: AppConstants.titleCreatePost,
                onTap: () async {
                  if (userProfileData != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreatePostScreen(),
                      ),
                    );
                  } else {
                    var data = await showAlertDialog(context);
                    print("object => data $data");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(AppConstants.cancel),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    Widget continueButton = TextButton(
      child: Text(AppConstants.create),
      onPressed: () async {
        Navigator.pop(context, true);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    CreateProfileScreen(isUpdating: userProfileData != null),
          ),
        );
        toggleCubit.refreshScreen();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Notice",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
        ],
      ),
      content: Text("You have to create profile to use this feature."),
      actions: [cancelButton, continueButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
