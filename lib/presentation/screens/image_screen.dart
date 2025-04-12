import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/common/app_colors.dart';
import 'package:mypost/logic/image_cubit/image_cubit.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late ImageCubit imageCubit;

  @override
  void initState() {
    imageCubit = BlocProvider.of<ImageCubit>(context);
    imageCubit.loadImageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Image Screen")),
        body: buildBodyWidget(context: context),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            GestureDetector(
              onTap: () async {
                imageCubit.downloadImage(imageDesc: "love+success");
              },
              child: Container(
                width: 70,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Icon(Icons.image)],
                ),
              ),
            ),
            FloatingActionButton.small(
              onPressed: () async {
                imageCubit.shareImageData();
              },
              child: SizedBox(width: 50, height: 50, child: Icon(Icons.share)),
            ),
          ],
        ),
      ),
    );
  }

  buildBodyWidget({required BuildContext context}) {
    return BlocBuilder<ImageCubit, ImageState>(
      builder: (context, loadedState) {
        if (loadedState is ImageLoadedState) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // color: AppColors.bgColor,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: buildImageList(context: context, loadedState: loadedState),
          );
        }
        if (loadedState is ImageLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (loadedState is ImageErrorState) {
          return Center(child: Text(loadedState.error));
        }
        return SizedBox.shrink();
      },
    );
  }

  buildImageList({
    required BuildContext context,
    required ImageLoadedState loadedState,
  }) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: loadedState.imageList.length,
      itemBuilder: (context, index) {
        String img = loadedState.imageList[index].largeImageURL ?? '';

        return buildImageWidget(img);
      },
    );
  }

  GestureDetector buildImageWidget(String img) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, img);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.borderColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          imageUrl: img,
          placeholder: (context, url) => Center(child: Text("Loading")),
        ),
      ),
    );
  }
}
