import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mypost/common/app_constants.dart';
import 'package:mypost/logic/create_post_cubit/create_post_cubit.dart';
import 'package:mypost/presentation/common_widgets.dart';

enum POSTACTION { share, download }

class PostViewScreen extends StatefulWidget {
  final File imageFile;
  final CreatePostCubit createPostCubit;

  const PostViewScreen({
    super.key,
    required this.imageFile,
    required this.createPostCubit,
  });

  @override
  State<PostViewScreen> createState() => _PostViewScreenState();
}

class _PostViewScreenState extends State<PostViewScreen> {
  late Size screenSize;
  late CreatePostCubit createPostCubit;

  @override
  void initState() {
    createPostCubit = widget.createPostCubit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppConstants.titleSaveOrShare),
          centerTitle: true,
        ),
        body: buildBody(context: context),
      ),
    );
  }

  Widget buildBody({required BuildContext context}) {
    return SizedBox(
      height: screenSize.height,
      width: screenSize.width,
      child: Column(
        children: [
          imageView(),
          Spacer(),
          builDButtonWidget(context: context),
          Spacer(),
          CommonWidgets().adWidget(height: 120, width: screenSize.width),
        ],
      ),
    );
  }

  Widget imageView() {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10, right: 10),
      height: screenSize.height * 0.6,
      child: Image.file(widget.imageFile),
    );
  }

  Widget builDButtonWidget({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        CommonWidgets().commonButton(
          title: AppConstants.share,
          onTap: () {
            createPostCubit.downloadAndSharePost(
              actionType: POSTACTION.share,
              context: context,
            );
          },
          buttonIcon: Icon(Icons.share, color: Colors.white),
        ),
        CommonWidgets().commonButton(
          title: AppConstants.download,
          onTap: () {
            createPostCubit.downloadAndSharePost(
              actionType: POSTACTION.download,
              context: context,
            );
          },
          buttonIcon: Icon(Icons.download, color: Colors.white),
        ),
      ],
    );
  }
}
