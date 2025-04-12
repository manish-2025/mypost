import 'dart:math';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/data/model/drive_and_sheets/drive_folder_model.dart';

part 'image_category_state.dart';

class ImageCategoryCubit extends Cubit<ImageCategoryState> {
  ImageCategoryCubit() : super(ImageCategoryLoadingState());

  DriveFolderList? folderList;

  void loadImageData() async {
    String imageUrl =
        "https://script.google.com/macros/s/AKfycby3WZx_9FF2NqUSMhQVtxLqS-h-_tyTd6upCF3gAbNSUkmqp0ZsQJU_-qb_lpqHxQpv/exec";
    final response = await Dio().get(imageUrl);
    if (response.statusCode == 200) {
      folderList = DriveFolderList.fromJson(response.data);
    }
    emit(
      ImageCategoryLoadedState(
        folderList: folderList?.driveFolders ?? [],
        random: Random().nextDouble(),
      ),
    );
  }
}
