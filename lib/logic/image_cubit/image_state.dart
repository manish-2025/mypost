part of 'image_cubit.dart';

class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageLoadingState extends ImageState {}

class ImageLoadedState extends ImageState {
  final List<ImageItem> imageList;

  const ImageLoadedState({required this.imageList});
}

class ImageErrorState extends ImageState {
  final String error;

  const ImageErrorState({required this.error});
}
