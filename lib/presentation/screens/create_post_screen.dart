import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/globals.dart';
import 'package:mypost/logic/create_post_cubit/create_post_cubit.dart';
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
          title: Text("Create Post"),
          centerTitle: true,
          actions: [downloadButton(), SizedBox(width: 10)],
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
    child: Icon(Icons.download),
  );

  Widget buildBody({required BuildContext context}) {
    return BlocBuilder<CreatePostCubit, CreatePostState>(
      builder: (context, loadedState) {
        if (loadedState is CreatePostLoadedState) {
          return Container(
            height: screenSize.height,
            width: screenSize.width,
            color: Colors.black,
            child: Column(
              children: [
                SizedBox(height: 20),
                Screenshot(
                  controller: createPostCubit.screenshotController,
                  child: Container(
                    height: screenSize.height * 0.7,
                    width: screenSize.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: screenSize.height * 0.65,
                          child:
                              (loadedState.bgImage == 'NA')
                                  ? SizedBox()
                                  : CachedNetworkImage(
                                    imageUrl: loadedState.bgImage,
                                    fit: BoxFit.fill,
                                  ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: screenSize.width,
                            decoration: BoxDecoration(color: Colors.yellow),
                            child: Row(
                              children: [
                                SizedBox(width: 100),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildText(
                                      text: userProfileData?.name ?? 'NA',
                                      txtStyle: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        height: 1.2,
                                      ),
                                    ),
                                    buildText(
                                      text: userProfileData?.mobile ?? 'NA',
                                      txtStyle: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 13,
                                        height: 1.2,
                                      ),
                                    ),
                                    buildText(
                                      text: userProfileData?.email ?? 'NA',
                                      txtStyle: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 13,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 120,
                            width: 90,
                            color: Colors.amber,
                            child: Image.file(
                              File(userProfileData!.image),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: buildText(
                              text: loadedState.quote,
                              txtStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                buildButtonWidget(context: context, loadedState: loadedState),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  Text buildText({
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () async {
            String bgImage = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageCategoryScreen()),
            );

            createPostCubit.updateState(
              loadedState: loadedState,
              image: bgImage,
            );
          },
          child: Card(
            child: SizedBox(
              width: 120,
              height: 50,
              child: Center(
                child: Text(
                  "Change Background",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            String quote = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuoteCategoryScreen()),
            );
            createPostCubit.updateState(loadedState: loadedState, quote: quote);
          },
          child: Card(
            child: SizedBox(
              width: 120,
              height: 50,
              child: Center(
                child: Text(
                  "Change Quote",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
