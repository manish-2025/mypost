part of 'image_category_cubit.dart';

sealed class ImageCategoryState extends Equatable {
  const ImageCategoryState();

  @override
  List<Object> get props => [];
}

final class ImageCategoryLoadingState extends ImageCategoryState {}

// ignore: must_be_immutable
final class ImageCategoryLoadedState extends ImageCategoryState {
  List<DriveFolderModel> folderList;
  final double random;

  ImageCategoryLoadedState({required this.folderList, required this.random});

  ImageCategoryLoadedState copyWith({
    List<DriveFolderModel>? folderList,
    double? random,
  }) {
    return ImageCategoryLoadedState(
      folderList: folderList ?? this.folderList,
      random: random ?? this.random,
    );
  }

  @override
  List<Object> get props => [folderList, random];
}

final class ImageCategoryErrorState extends ImageCategoryState {
  final String error;

  const ImageCategoryErrorState({required this.error});
}
