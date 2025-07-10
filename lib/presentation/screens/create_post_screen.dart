import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/common/app_colors.dart';
import 'package:mypost/common/app_constants.dart';
import 'package:mypost/globals.dart';
import 'package:mypost/logic/create_post_cubit/create_post_cubit.dart';
import 'package:mypost/logic/toggle_cubit/toggle_cubit.dart';
import 'package:mypost/presentation/common_bottom_sheet.dart';
import 'package:mypost/presentation/common_widgets.dart';
import 'package:mypost/presentation/screens/image/image_category_screen.dart';
import 'package:mypost/presentation/screens/post_view_screen.dart';
import 'package:mypost/presentation/screens/quote_screens/quote_category_screen.dart';
import 'package:screenshot/screenshot.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late Size screenSize;
  late CreatePostCubit createPostCubit;

  @override
  void initState() {
    createPostCubit = BlocProvider.of<CreatePostCubit>(context);
    createPostCubit.loadPostData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppConstants.titleCreatePost),
          centerTitle: true,
          actions: [downloadButton(), SizedBox(width: 20)],
        ),
        body: buildBody(context: context),
      ),
    );
  }

  Widget downloadButton() {
    return GestureDetector(
      onTap: download,
      child: Image.asset(
        'assets/icons/download.png',
        height: 30,
        color: Colors.white,
      ),
    );
  }

  Widget buildBody({required BuildContext context}) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, loadedState) {
        if (loadedState is CreatePostLoadedState) {
          return SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: Column(
              children: [
                SizedBox(height: 10),
                Screenshot(
                  controller: createPostCubit.screenshotController,
                  child: Container(
                    width: screenSize.width * 0.8,
                    height: screenSize.height * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Stack(
                      children: [
                        postImageWidget(loadedState),
                        nameAndContactWidget(),
                        businessDetailsWidget(),
                        businessLogo(),
                        quoteWidget(loadedState),
                        userImageWidget(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Spacer(),
                adEnable
                    ? CommonWidgets().adWidget(
                      height: 120,
                      width: screenSize.width,
                    )
                    : CommonWidgets().commonButton(
                      title: AppConstants.download,
                      width: 200,
                      onTap: download,
                    ),
                Spacer(),
                SizedBox(height: 10),
                buildButtonWidget(context: context, loadedState: loadedState),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget postImageWidget(CreatePostLoadedState loadedState) {
    return SizedBox(
      height: screenSize.height * 0.65,
      width: screenSize.height * 0.65,
      child:
          (loadedState.bgImage == 'NA')
              ? SizedBox()
              : loadedState.bgImage.startsWith("http")
              ? CachedNetworkImage(
                imageUrl: loadedState.bgImage,
                fit: BoxFit.fill,
              )
              : Image.file(File(loadedState.bgImage), fit: BoxFit.fill),
    );
  }

  Widget nameAndContactWidget() {
    return Visibility(
      visible: createPostCubit.showUserDetails,
      child: Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: screenSize.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, AppColors.primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 2),
                  buildText(
                    text: userProfileData?.name ?? 'NA',
                    txtStyle: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  buildText(
                    text: userProfileData?.mobile ?? 'NA',
                    txtStyle: TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.end,
                  ),

                  SizedBox(height: 2),
                ],
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget userImageWidget() {
    return Visibility(
      visible: createPostCubit.showUserImage,
      child: Positioned(
        bottom: 0,
        child: Container(
          height: 100,
          width: 80,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.only(topRight: Radius.circular(15)),
          ),
          clipBehavior: Clip.antiAlias,
          child:
              userProfileData!.image.startsWith("http")
                  ? CachedNetworkImage(
                    imageUrl: userProfileData!.image,
                    fit: BoxFit.fill,
                  )
                  : Image.file(File(userProfileData!.image), fit: BoxFit.fill),
        ),
      ),
    );
  }

  Widget quoteWidget(CreatePostLoadedState loadedState) {
    return Positioned(
      left: 10,
      right: 10,
      top: createPostCubit.quoteTopPosition,
      child: Center(
        child: buildText(
          text: loadedState.quote,
          txtStyle: TextStyle(
            backgroundColor: Colors.black45,
            color: Colors.white,
            fontSize: double.tryParse(createPostCubit.quoteSize.toString()),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildText({
    required String text,
    required TextStyle txtStyle,
    TextAlign? textAlign,
  }) {
    return Text(text, style: txtStyle, textAlign: textAlign);
  }

  buildButtonWidget({
    required BuildContext context,
    required CreatePostLoadedState loadedState,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: AppColors.primaryColor),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          menuButtonWidget(
            context: context,
            loadedState: loadedState,
            iconPath: 'assets/icons/image-icon.png',
            title: AppConstants.changeBackground,
            iconAndTitleColor: Colors.black,
            onTap: () async {
              String bgImage = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageCategoryScreen()),
              );
              await createPostCubit.updateState(
                loadedState: loadedState,
                image: bgImage,
              );
            },
          ),
          menuButtonWidget(
            context: context,
            loadedState: loadedState,
            iconPath: 'assets/icons/edit-text.png',
            title: AppConstants.changeQuote,
            iconAndTitleColor: Colors.black,
            onTap: () async {
              String quote = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuoteCategoryScreen()),
              );
              await createPostCubit.updateState(
                loadedState: loadedState,
                quote: quote,
              );
            },
          ),
          menuButtonWidget(
            context: context,
            loadedState: loadedState,
            onTap: () async {
              fontBottomModel(context, loadedState);
            },
            iconPath: 'assets/icons/font-size.png',
            title: AppConstants.fontSize,
            iconAndTitleColor: Colors.black,
          ),
          menuButtonWidget(
            context: context,
            loadedState: loadedState,
            onTap: () async {
              // positionBottomModelSheet(context, loadedState);
              CommonBottomSheet.show(
                context: context,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          AppConstants.quotePosition,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        CommonWidgets().bottomSheetDoneButton(
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: AppColors.borderColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        createPostCubit.quoteTopPosition =
                            createPostCubit.quoteTopPosition - 10;
                        createPostCubit.updateState(loadedState: loadedState);
                      },
                      child: Image.asset(
                        'assets/icons/icon-up.png',
                        height: 30,
                      ),
                    ),
                    SizedBox(height: 10),
                    IgnorePointer(
                      ignoring: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              createPostCubit.quoteSize =
                                  createPostCubit.quoteSize + 1;
                              createPostCubit.updateState(
                                loadedState: loadedState,
                              );
                            },
                            child: Image.asset(
                              'assets/icons/icon-left.png',
                              height: 30,
                              color: Colors.black38,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.circle, color: Colors.black),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              if (!(createPostCubit.quoteSize < 10)) {
                                createPostCubit.quoteSize =
                                    createPostCubit.quoteSize - 1;
                                createPostCubit.updateState(
                                  loadedState: loadedState,
                                );
                                ToggleCubit().refreshScreen();
                              }
                            },
                            child: Image.asset(
                              'assets/icons/icon-right.png',
                              height: 30,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        createPostCubit.quoteTopPosition =
                            createPostCubit.quoteTopPosition + 10;
                        createPostCubit.updateState(loadedState: loadedState);
                      },
                      child: Image.asset(
                        'assets/icons/icon-down.png',
                        height: 30,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              );
            },
            iconPath: 'assets/icons/position.png',
            title: AppConstants.position,
            iconAndTitleColor: Colors.black,
          ),

          menuButtonWidget(
            context: context,
            loadedState: loadedState,
            onTap: () async {
              // showModalBottomSheet(
              //   context: context,
              //   builder: (context) {
              //     return CustomBottomModelSheet(
              //       createPostCubit: createPostCubit,
              //       screenSize: screenSize,
              //       loadedState: loadedState,
              //     );
              //   },
              // );
              CommonBottomSheet.show(
                context: context,
                minChildSize: 0.2,
                maxChildSize: 0.8,
                initialChildSize: 0.4,
                child: CustomBottomModelSheet(
                  createPostCubit: createPostCubit,
                  screenSize: screenSize,
                  loadedState: loadedState,
                ),
              );
            },
            iconPath: 'assets/icons/hide.png',
            title: AppConstants.hide,
            iconAndTitleColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget businessDetailsWidget() {
    return Positioned(
      top: 0,
      right: 0,
      child: SizedBox(
        height: 70,
        width: screenSize.width * 0.8,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: createPostCubit.showBusinessDetails,
              child: Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    gradient: LinearGradient(
                      colors: [Colors.red, AppColors.primaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfileData!.businessName,
                        style: TextStyle(
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        userProfileData!.occupation,
                        style: TextStyle(height: 1.1, color: Colors.blueGrey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget businessLogo() {
    return Visibility(
      visible: createPostCubit.showBusinessLogo,
      child: Positioned(
        right: 0,
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.file(
            File(userProfileData!.businessLogo),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Future<dynamic> positionBottomModelSheet(
    BuildContext context,
    CreatePostLoadedState loadedState,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<ToggleCubit, double>(
          builder: (context, state) {
            return Container(
              height: 220,
              width: screenSize.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.antiAlias,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          AppConstants.quotePosition,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        CommonWidgets().bottomSheetDoneButton(
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        createPostCubit.quoteTopPosition =
                            createPostCubit.quoteTopPosition - 10;
                        createPostCubit.updateState(loadedState: loadedState);
                      },
                      child: Image.asset(
                        'assets/icons/icon-up.png',
                        height: 30,
                      ),
                    ),
                    SizedBox(height: 10),
                    IgnorePointer(
                      ignoring: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              createPostCubit.quoteSize =
                                  createPostCubit.quoteSize + 1;
                              createPostCubit.updateState(
                                loadedState: loadedState,
                              );
                            },
                            child: Image.asset(
                              'assets/icons/icon-left.png',
                              height: 30,
                              color: Colors.black38,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.circle, color: Colors.black),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              if (!(createPostCubit.quoteSize < 10)) {
                                createPostCubit.quoteSize =
                                    createPostCubit.quoteSize - 1;
                                createPostCubit.updateState(
                                  loadedState: loadedState,
                                );
                                ToggleCubit().refreshScreen();
                              }
                            },
                            child: Image.asset(
                              'assets/icons/icon-right.png',
                              height: 30,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        createPostCubit.quoteTopPosition =
                            createPostCubit.quoteTopPosition + 10;
                        createPostCubit.updateState(loadedState: loadedState);
                      },
                      child: Image.asset(
                        'assets/icons/icon-down.png',
                        height: 30,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<dynamic> fontBottomModel(
    BuildContext context,
    CreatePostLoadedState loadedState,
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<ToggleCubit, double>(
          builder: (context, state) {
            return SizedBox(
              height: 150,
              width: screenSize.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          AppConstants.fontSize,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        CommonWidgets().bottomSheetDoneButton(
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Spacer(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!(createPostCubit.quoteSize < 10)) {
                              createPostCubit.quoteSize =
                                  createPostCubit.quoteSize - 1;
                              createPostCubit.updateState(
                                loadedState: loadedState,
                              );
                              ToggleCubit().refreshScreen();
                            }
                          },
                          child: Image.asset(
                            'assets/icons/icon-minus.png',
                            height: 30,
                          ),
                        ),

                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            createPostCubit.quoteSize =
                                createPostCubit.quoteSize + 1;
                            createPostCubit.updateState(
                              loadedState: loadedState,
                            );
                          },
                          child: Image.asset(
                            'assets/icons/icon-plus.png',
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Spacer(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget menuButtonWidget({
    required BuildContext context,
    required CreatePostLoadedState loadedState,
    required void Function() onTap,
    required String iconPath,
    required String title,
    required Color iconAndTitleColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        width: 70,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, height: 25, color: iconAndTitleColor),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 9,
                color: iconAndTitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  download() async {
    File imageFile = await createPostCubit.captureAndProcessPost();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PostViewScreen(
              imageFile: imageFile,
              createPostCubit: createPostCubit,
            ),
      ),
    );
  }
}

class CustomBottomModelSheet extends StatefulWidget {
  final CreatePostCubit createPostCubit;
  final CreatePostLoadedState loadedState;
  final Size screenSize;

  const CustomBottomModelSheet({
    super.key,
    required this.createPostCubit,
    required this.screenSize,
    required this.loadedState,
  });

  @override
  State<CustomBottomModelSheet> createState() => _CustomBottomModelSheetState();
}

class _CustomBottomModelSheetState extends State<CustomBottomModelSheet> {
  late CreatePostCubit createPostCubit;
  late CreatePostLoadedState loadedState;
  late Size screenSize;

  @override
  void initState() {
    screenSize = widget.screenSize;
    createPostCubit = widget.createPostCubit;
    loadedState = widget.loadedState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: screenSize.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios),
                ),
                Text(
                  AppConstants.showOrHidePostDetails,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded),
                ),
              ],
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                createPostCubit.showBusinessDetails =
                    !(createPostCubit.showBusinessDetails);
                createPostCubit.updateState(loadedState: loadedState);
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 40),
                  createPostCubit.showBusinessDetails
                      ? Icon(Icons.check_box, color: Colors.black)
                      : Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.black,
                      ),

                  SizedBox(width: 20),
                  Text(AppConstants.businessDetails),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                createPostCubit.showBusinessLogo =
                    !(createPostCubit.showBusinessLogo);
                createPostCubit.updateState(loadedState: loadedState);
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 40),
                  createPostCubit.showBusinessLogo
                      ? Icon(Icons.check_box, color: Colors.black)
                      : Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.black,
                      ),

                  SizedBox(width: 20),
                  Text(AppConstants.businessLogo),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                createPostCubit.showUserDetails =
                    !(createPostCubit.showUserDetails);
                createPostCubit.updateState(loadedState: loadedState);
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 40),
                  createPostCubit.showUserDetails
                      ? Icon(Icons.check_box, color: Colors.black)
                      : Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.black,
                      ),
                  SizedBox(width: 20),
                  Text(AppConstants.userDetails),
                ],
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                createPostCubit.showUserImage =
                    !(createPostCubit.showUserImage);
                createPostCubit.updateState(loadedState: loadedState);
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 40),
                  createPostCubit.showUserImage
                      ? Icon(Icons.check_box, color: Colors.black)
                      : Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.black,
                      ),

                  SizedBox(width: 20),
                  Text(AppConstants.userImage),
                ],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Card(
                color: AppColors.cardBGColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(AppConstants.done),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
