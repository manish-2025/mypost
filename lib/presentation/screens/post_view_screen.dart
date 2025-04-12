import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mypost/logic/create_post_cubit/create_post_cubit.dart';

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
        appBar: AppBar(title: Text("Save OR Share"), centerTitle: true),
        body: buildBody(context: context),
      ),
    );
  }

  Widget buildBody({required BuildContext context}) {
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      color: Colors.red,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            height: screenSize.height * 0.6,
            child: Image.file(widget.imageFile),
          ),
          builDButtonWidget(context: context),
        ],
      ),
    );
  }

  Widget builDButtonWidget({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        buildActionButton(
          title: "Share",
          onTap: () {
            createPostCubit.downloadAndSharePost(
              actionType: 'share',
              context: context,
            );
          },
          buttonIcon: Icon(Icons.share, color: Colors.black),
        ),
        buildActionButton(
          title: "download",
          onTap: () {
            createPostCubit.downloadAndSharePost(
              actionType: 'download',
              context: context,
            );
          },
          buttonIcon: Icon(Icons.download, color: Colors.black),
        ),
      ],
    );
  }

  Widget buildActionButton({
    required String title,
    required Function() onTap,
    required Widget buttonIcon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: SizedBox(
          height: 50,
          width: 130,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonIcon,
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
