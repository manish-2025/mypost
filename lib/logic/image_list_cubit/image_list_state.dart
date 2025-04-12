part of 'image_list_cubit.dart';

class ImageListState extends Equatable {
  const ImageListState();

  @override
  List<Object> get props => [];
}

class ImageLoadingState extends ImageListState {}

// ignore: must_be_immutable
final class ImageLoadedState extends ImageListState {
  List<String> imageList;
  final double random;

  ImageLoadedState({required this.imageList, required this.random});

  ImageLoadedState copyWith({List<String>? imageList, double? random}) {
    return ImageLoadedState(
      imageList: imageList ?? this.imageList,

      random: random ?? this.random,
    );
  }

  @override
  List<Object> get props => [imageList, random];
}

class ImageErrorState extends ImageListState {
  final String error;

  const ImageErrorState({required this.error});
  @override
  List<Object> get props => [error];
}
