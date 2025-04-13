import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/common/app_constants.dart';
import 'package:mypost/data/model/drive_and_sheets/drive_folder_model.dart';
import 'package:mypost/logic/image_catagory_cubit/image_category_cubit.dart';
import 'package:mypost/presentation/screens/image/image_list_screen.dart';

class ImageCategoryScreen extends StatefulWidget {
  const ImageCategoryScreen({super.key});

  @override
  State<ImageCategoryScreen> createState() => _ImageCategoryScreenState();
}

class _ImageCategoryScreenState extends State<ImageCategoryScreen> {
  late ImageCategoryCubit imageCategoryCubit;

  @override
  void initState() {
    imageCategoryCubit = BlocProvider.of<ImageCategoryCubit>(context);
    imageCategoryCubit.loadImageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(AppConstants.selectCategory)),
        body: buildBodyWidget(context: context),
      ),
    );
  }

  buildBodyWidget({required BuildContext context}) {
    return BlocBuilder<ImageCategoryCubit, ImageCategoryState>(
      builder: (context, loadedState) {
        if (loadedState is ImageCategoryLoadedState) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: buildCategoryList(
              context: context,
              loadedState: loadedState,
            ),
          );
        }
        if (loadedState is ImageCategoryLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (loadedState is ImageCategoryErrorState) {
          return Center(child: Text(loadedState.error));
        }
        return SizedBox.shrink();
      },
    );
  }

  Widget buildCategoryList({
    required BuildContext context,
    required ImageCategoryLoadedState loadedState,
  }) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: List.generate(
        imageCategoryCubit.folderList?.driveFolders.length ?? 0,
        (index) {
          return buildCategoryCard(
            folder: loadedState.folderList[index],
            loadedState: loadedState,
          );
        },
      ),
    );
  }

  Widget buildCategoryCard({
    required DriveFolderModel folder,
    required ImageCategoryLoadedState loadedState,
  }) {
    return GestureDetector(
      onTap: () async {
        var imag = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageListScreen(folder: folder),
          ),
        );
        if (imag != null) {
          Navigator.pop(context, imag);
        }
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                height: MediaQuery.of(context).size.width * 0.30,
                child: CachedNetworkImage(
                  imageUrl: folder.folderImage,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: -2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    folder.folderName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
