import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/data/model/image_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(ImageLoadingState());

  List<ImageItem> imageData = [];
  List<String> category = ['backgrounds'];
  List<String> colors = [
    "grayscale",
    "transparent",
    "red",
    "orange",
    "yellow",
    "green",
    "turquoise",
    "blue",
    "lilac",
    "pink",
    "white",
    "gray",
    "black",
    "brown",
  ];

  void downloadImage({required String imageDesc}) async {
    const apiKey = '49690131-21fac4d3932a72197a0c2b407';
    String cat = category.elementAt(Random().nextInt(category.length));
    String color = colors.elementAt(Random().nextInt(colors.length));
    String q = "wallpaper+nature";

    final url =
        'https://pixabay.com/api/?key=$apiKey&q=$q&safesearch=true&image_type=photo&category=$cat&colors=$color&orientation=vertical&per_page=50';

    final response = await Dio().get(url);
    if (response.statusCode == 200) {
      ImageModel dataa = ImageModel.fromJson(response.data);
      imageData.addAll(dataa.images?.toList() ?? []);
    }
  }

  void shareImageData() async {
    List<Map<String, dynamic>> jsonData = getjsonData();

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/image_data.json';
    final file = File(path);
    await file.writeAsString(jsonEncode(jsonData));
    await Share.shareXFiles([XFile(file.path)], text: 'Json Data');
  }

  List<Map<String, dynamic>> getjsonData() {
    final seen = <String>{};
    final result = <Map<String, dynamic>>[];
    for (var map in imageData) {
      final jsonString = jsonEncode({
        "id": map.id,
        "previewURL": map.previewURL,
        "largeImageURL": map.largeImageURL,
      }); // Serialize to string
      if (seen.add(jsonString)) {
        result.add({
          "id": map.id,
          "previewURL": map.previewURL,
          "largeImageURL": map.largeImageURL,
        }); // Only add if not seen before
      }
    }
    imageData.toSet().toList();

    List<Map<String, dynamic>> json = [];
    for (var map in imageData) {
      json.add({
        "id": map.id,
        "previewURL": map.previewURL,
        "largeImageURL": map.largeImageURL,
      });
    }
    return json;
  }

  void loadImageData() async {
    String imageUrl =
        "https://script.google.com/macros/s/AKfycby3WZx_9FF2NqUSMhQVtxLqS-h-_tyTd6upCF3gAbNSUkmqp0ZsQJU_-qb_lpqHxQpv/exec";
    final response = await Dio().get(imageUrl);
    if (response.statusCode == 200) {
      ImageModel dataa = ImageModel.fromJson(response.data);
      imageData.clear();
      imageData.addAll(dataa.images?.toList() ?? []);
    }
    emit(ImageLoadedState(imageList: imageData));
  }
}
