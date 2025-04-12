import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/common/app_colors.dart';
import 'package:mypost/data/model/drive_and_sheets/drive_folder_model.dart';
import 'package:mypost/logic/image_list_cubit/image_list_cubit.dart';

class ImageListScreen extends StatefulWidget {
  final DriveFolderModel folder;
  const ImageListScreen({super.key, required this.folder});

  @override
  State<ImageListScreen> createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  late ImageListCubit imageListCubit;
  late DriveFolderModel folder;

  @override
  void initState() {
    folder = widget.folder;
    imageListCubit = BlocProvider.of<ImageListCubit>(context);
    imageListCubit.fetchImages(folderId: folder.folderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(folder.folderName)),
        body: buildBodyWidget(context: context),
      ),
    );
  }

  buildBodyWidget({required BuildContext context}) {
    return BlocBuilder<ImageListCubit, ImageListState>(
      builder: (context, loadedState) {
        if (loadedState is ImageLoadedState) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: buildGridImageList(
              context: context,
              loadedState: loadedState,
            ),
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

  buildGridImageList({
    required BuildContext context,
    required ImageLoadedState loadedState,
  }) {
    return (loadedState.imageList.isEmpty)
        ? Center(child: Text("No Data found"))
        : GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 190,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: loadedState.imageList.length,
          itemBuilder: (context, index) {
            String img = loadedState.imageList[index];
            return buildImageWidget(img);
          },
        );
  }

  Widget buildImageWidget(String img) {
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
