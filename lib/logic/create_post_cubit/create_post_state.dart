part of 'create_post_cubit.dart';

class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object> get props => [];
}

class CreatePostInitial extends CreatePostState {}

// ignore: must_be_immutable
class CreatePostLoadedState extends CreatePostState {
  String bgImage;
  String quote;
  final double random;

  CreatePostLoadedState({
    required this.bgImage,
    required this.quote,
    required this.random,
  });

  CreatePostLoadedState copyWith({
    required String? bgImage,
    required String? quote,
    required double? randon,
  }) {
    return CreatePostLoadedState(
      random: random,
      bgImage: bgImage ?? this.bgImage,
      quote: quote ?? this.quote,
    );
  }

  @override
  List<Object> get props => [bgImage, quote, random];
}
