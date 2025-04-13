import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/common/app_colors.dart';
import 'package:mypost/common/app_constants.dart';
import 'package:mypost/globals.dart';
import 'package:mypost/logic/create_post_cubit/create_post_cubit.dart';
import 'package:mypost/logic/toggle_cubit/toggle_cubit.dart';
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
          title: Text(AppConstants.createPost),
          centerTitle: true,
          actions: [downloadButton(), SizedBox(width: 20)],
        ),
        body: buildBody(context: context),
      ),
    );
  }

  GestureDetector downloadButton() => GestureDetector(
    onTap: () async {
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
    },
    child: Image.asset(
      "assets/icons/download.png",
      height: 30,
      color: Colors.white,
    ),
  );

  Widget buildBody({required BuildContext context}) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, loadedState) {
        if (loadedState is CreatePostLoadedState) {
          return Container(
            height: screenSize.height,
            width: screenSize.width,
            color: const Color.fromARGB(255, 231, 188, 238),
            child: Column(
              children: [
                SizedBox(height: 10),
                Expanded(
                  child: Screenshot(
                    controller: createPostCubit.screenshotController,
                    child: Container(
                      width: screenSize.width * 0.8,
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
                          userImageWidget(),
                          quoteWidget(loadedState),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 120,
                  width: screenSize.width,
                  decoration: BoxDecoration(color: Colors.green),
                  child: Center(child: Text("Advertisement")),
                ),
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
              : CachedNetworkImage(
                imageUrl: loadedState.bgImage,
                fit: BoxFit.fill,
              ),
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
          decoration: BoxDecoration(color: Colors.yellow),
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
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  buildText(
                    text: userProfileData?.mobile ?? 'NA',
                    txtStyle: TextStyle(
                      color: Colors.blueGrey,
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
          height: 80,
          width: 70,
          color: Colors.amber,
          child: Image.file(File(userProfileData!.image), fit: BoxFit.fill),
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
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 169, 125, 250),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
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
                  Image.asset('assets/icons/image-icon.png', height: 25),
                  Text(
                    AppConstants.changeBackground,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
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
                  Image.asset('assets/icons/edit-text.png', height: 25),
                  Text(
                    AppConstants.changeQuote,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BlocBuilder<ToggleCubit, double>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 100,
                        width: screenSize.width,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [Text("Quote Font Size")],
                              ),
                              SizedBox(height: 10),
                              Row(
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
                                      "assets/icons/icon-plus.png",
                                      height: 30,
                                    ),
                                  ),
                                  SizedBox(width: 20),
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
                                      "assets/icons/icon-minus.png",
                                      height: 30,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
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
                  Image.asset('assets/icons/font-size.png', height: 25),
                  Text(
                    "Font Size",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BlocBuilder<ToggleCubit, double>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 200,
                        width: screenSize.width,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Quote Position",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              GestureDetector(
                                onTap: () {
                                  createPostCubit.quoteTopPosition =
                                      createPostCubit.quoteTopPosition - 10;
                                  createPostCubit.updateState(
                                    loadedState: loadedState,
                                  );
                                },
                                child: Image.asset(
                                  "assets/icons/icon-up.png",
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
                                        "assets/icons/icon-left.png",
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
                                        "assets/icons/icon-right.png",
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
                                  createPostCubit.updateState(
                                    loadedState: loadedState,
                                  );
                                },
                                child: Image.asset(
                                  "assets/icons/icon-down.png",
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
            },
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
                  Image.asset('assets/icons/position.png', height: 25),
                  Text(
                    "Position",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CustomBottomModelSheet(
                    createPostCubit: createPostCubit,
                    screenSize: screenSize,
                    loadedState: loadedState,
                  );
                },
              );
            },
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
                  Image.asset('assets/icons/hide.png', height: 25),
                  Text(
                    "Hide",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ],
              ),
            ),
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
                  decoration: BoxDecoration(color: Colors.amber),
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
          color: Colors.amber,
          child: Image.file(
            File(userProfileData!.businessLogo),
            fit: BoxFit.fill,
          ),
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "- Hide/Show User Details -",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
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
                  Text("Business Details"),
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
                  Text("Business Logo"),
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
                  Text("User Details"),
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
                  Text("User Image"),
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
                  child: Text("Done"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
