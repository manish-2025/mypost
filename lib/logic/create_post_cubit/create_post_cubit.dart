import 'dart:io';
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:mypost/common/app_constants.dart';
import 'package:mypost/presentation/custom_widget/custom_snackbar.dart';
import 'package:mypost/presentation/screens/post_view_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  CreatePostCubit() : super(CreatePostInitial());

  ScreenshotController screenshotController = ScreenshotController();
  File? postFile;
  Uint8List? postByteData;
  int quoteSize = 10;
  double quoteTopPosition = 200;
  bool showBusinessDetails = true;
  bool showBusinessLogo = true;
  bool showUserDetails = true;
  bool showUserImage = true;

  void loadPostData() {
    emit(
      CreatePostLoadedState(
        random: Random().nextDouble(),
        bgImage: 'NA',
        quote:
            'वज़ीरों से मत डर ए शहंशाह तूं हुकूमत का सरताज हैं, हारा भले ही तूं वक्त से है, दिलो में आज भी तेरा राज है!!',
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
    required POSTACTION actionType,
    required BuildContext context,
  }) async {
    if (postByteData == null || postFile == null) {
      CustomSnackbar.show(
        snackbarType: SnackbarType.ERROR,
        message: AppConstants.errorSomethingWronge,
        context: context,
      );
      return;
    }
    if (actionType == POSTACTION.download) {
      await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(postByteData as List<int>),
        quality: 90,
        name: "PM_${DateTime.now().millisecondsSinceEpoch}",
      );
      CustomSnackbar.show(
        snackbarType: SnackbarType.SUCCESS,
        message: AppConstants.postDownloaded,
        context: context,
      );
    } else {
      await Share.shareXFiles([XFile(postFile!.path)]);
      CustomSnackbar.show(
        snackbarType: SnackbarType.SUCCESS,
        message: AppConstants.postShared,
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
      CreatePostLoadedState(
        bgImage: image ?? loadedState.bgImage,
        quote: quote ?? loadedState.quote,
        random: Random().nextDouble(),
      ),
    );

    return '';
  }
}
