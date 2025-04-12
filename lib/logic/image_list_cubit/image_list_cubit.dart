// ignore_for_file: avoid_print

import 'dart:math';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/data/model/drive_and_sheets/google_drive_response.dart';

part 'image_list_state.dart';

class ImageListCubit extends Cubit<ImageListState> {
  ImageListCubit() : super(ImageLoadingState());

  void fetchImages({required String folderId}) async {
    emit(ImageLoadingState());
    final apiKey = 'AIzaSyB-U8Bsw75TrrczcTpGx-gvTIt2Gdg6u1s';

    final url =
        'https://www.googleapis.com/drive/v3/files?q=%27$folderId%27+in+parents+and+mimeType+contains+%27image%27&key=$apiKey';
    try {
      Response response = await Dio().get(url);
      var data = response.data;

      if (data is Map<String, dynamic> && data.containsKey('files')) {
        var files = data['files'];
        List<String> imageList = [];
        if (files is List) {
          final googleDriveResponse = GoogleDriveResponse.fromJson(data);

          for (var file in googleDriveResponse.files) {
            final imageUrl =
                'https://drive.google.com/uc?export=view&id=${file.id}';
            imageList.add(imageUrl);
          }
          emit(
            ImageLoadedState(
              imageList: imageList,
              random: Random().nextDouble(),
            ),
          );
        } else {
          emit(ImageErrorState(error: "Error: 'files' is not a list."));
        }
      } else {
        emit(
          ImageErrorState(
            error:
                "Error: The response doesn't contain the 'files' key or is not a map.",
          ),
        );
      }
    } catch (e) {
      emit(ImageErrorState(error: "Error fetching data: $e"));
      // print("Error fetching data: $e");
    }
  }
}
