import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mypost/common/app_colors.dart';
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
  late Size screenSize;

  @override
  void initState() {
    imageCategoryCubit = BlocProvider.of<ImageCategoryCubit>(context);
    imageCategoryCubit.loadImageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(AppConstants.titlePostImage)),
        body: buildBodyWidget(context: context),
      ),
    );
  }

  buildBodyWidget({required BuildContext context}) {
    return Container(
      height: screenSize.height,
      width: screenSize.width,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imagePickerOptionWidget(
                context: context,
                title: AppConstants.camera,
                onTap: () async {
                  File? newFile;
                  final XFile? image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    newFile = await cropImage(
                      context: context,
                      imageFile: image,
                    );
                  }
                  if (newFile != null) {
                    Navigator.pop(context, newFile.path);
                  } else if (image != null) {
                    Navigator.pop(context, image.path);
                  }
                },
                icon: Icon(
                  Icons.camera_alt_sharp,
                  color: Colors.black,
                  size: 35,
                ),
              ),
              SizedBox(width: 20),
              imagePickerOptionWidget(
                context: context,
                title: AppConstants.gallery,
                onTap: () async {
                  File? newFile;
                  final XFile? image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    newFile = await cropImage(
                      context: context,
                      imageFile: image,
                    );
                  }
                  if (newFile != null) {
                    Navigator.pop(context, newFile.path);
                  } else if (image != null) {
                    Navigator.pop(context, image.path);
                  }
                },
                icon: Icon(Icons.image, color: Colors.black, size: 35),
              ),
            ],
          ),
          SizedBox(height: 10),
          BlocBuilder<ImageCategoryCubit, ImageCategoryState>(
            builder: (context, loadedState) {
              if (loadedState is ImageCategoryLoadedState) {
                return buildCategoryList(
                  context: context,
                  loadedState: loadedState,
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
          ),
        ],
      ),
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

  Widget imagePickerOptionWidget({
    required BuildContext context,
    required void Function()? onTap,
    required String title,
    required Widget icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenSize.width * 0.4,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBGColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          children: [
            icon,
            Text(
              title,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<File?> cropImage({
    required BuildContext context,
    required XFile imageFile,
  }) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPresetCustom(), // IMPORTANT: iOS supports only one custom aspect ratio in preset list
          ],
        ),
        WebUiSettings(context: context),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
