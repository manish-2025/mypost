import 'dart:io';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:mypost/presentation/custom_widget/custom_snackbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit() : super(CreatePostInitial());

  ScreenshotController screenshotController = ScreenshotController();
  File? postFile;
  Uint8List? postByteData;

  void loadPostData() {
    emit(
      CreatePostLoadedState(
        random: Random().nextDouble(),
        bgImage: 'NA',
        quote: 'NA',
      ),
    );
  }

  Future<File> captureAndProcessPost() async {
    postByteData = await screenshotController.capture();
    Directory directory = await getApplicationCacheDirectory();
    String imagePath =
        "${directory.path}${Platform.pathSeparator} ${DateTime.now().millisecondsSinceEpoch}post.png";

    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(postByteData as List<int>);
    postFile = imageFile;
    return imageFile;
  }

  void downloadAndSharePost({
    required String actionType,
    required BuildContext context,
  }) async {
    if (postByteData == null || postFile == null) {
      CustomSnackbar.show(
        snackbarType: SnackbarType.ERROR,
        message: "Something went wronge",
        context: context,
      );
      return;
    }
    if (actionType == "download") {
      await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(postByteData as List<int>),
        quality: 90,
        name: "PM_${DateTime.now().millisecondsSinceEpoch}",
      );
      CustomSnackbar.show(
        snackbarType: SnackbarType.SUCCESS,
        message: "Post Downloaded",
        context: context,
      );
    } else {
      await Share.shareXFiles([XFile(postFile!.path)]);
      CustomSnackbar.show(
        snackbarType: SnackbarType.SUCCESS,
        message: "Post Shared",
        context: context,
      );
    }
  }

  Future<String> updateState({
    required CreatePostLoadedState loadedState,
    String? quote,
    String? image,
  }) async {
    emit(
      loadedState.copyWith(
        randon: Random().nextDouble(),
        bgImage: image ?? loadedState.bgImage,
        quote: quote ?? loadedState.quote,
      ),
    );

    return '';
  }
}
