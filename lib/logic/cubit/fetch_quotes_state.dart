part of 'fetch_quotes_cubit.dart';

sealed class FetchQuotesState extends Equatable {
  const FetchQuotesState();

  @override
  List<Object> get props => [];
}

final class FetchQuotesLoadingState extends FetchQuotesState {}

// ignore: must_be_immutable
final class FetchQuotesLoadedState extends FetchQuotesState {
  List<QuoteEntity> quotesData;
  List<QuoteEntity> loveQuoteData;
  List<QuoteEntity> positiveQuoteData;
  List<QuoteEntity> sadQuoteData;
  List<QuoteEntity> successQuotesData;
  List<QuoteEntity> motivationalQuotesData;
  List<QuoteEntity> attitudeQuotesData;
  final double random;

  FetchQuotesLoadedState({
    required this.quotesData,
    required this.loveQuoteData,
    required this.positiveQuoteData,
    required this.sadQuoteData,
    required this.successQuotesData,
    required this.motivationalQuotesData,
    required this.attitudeQuotesData,
    required this.random,
  });

  FetchQuotesLoadedState copyWith({
    required List<QuoteEntity>? quotesData,
    required List<QuoteEntity>? loveQuoteData,
    required List<QuoteEntity>? positiveQuoteData,
    required List<QuoteEntity>? sadQuoteData,
    required List<QuoteEntity>? successQuotesData,
    required List<QuoteEntity>? motivationalQuotesData,
    required List<QuoteEntity>? attitudeQuotesData,
    double? random,
  }) {
    return FetchQuotesLoadedState(
      quotesData: quotesData ?? this.quotesData,
      loveQuoteData: loveQuoteData ?? this.loveQuoteData,
      positiveQuoteData: positiveQuoteData ?? this.positiveQuoteData,
      sadQuoteData: sadQuoteData ?? this.sadQuoteData,
      successQuotesData: successQuotesData ?? this.successQuotesData,
      motivationalQuotesData:
          motivationalQuotesData ?? this.motivationalQuotesData,
      attitudeQuotesData: attitudeQuotesData ?? this.attitudeQuotesData,
      random: random ?? this.random,
    );
  }

  @override
  List<Object> get props => [quotesData, random];
}

final class FetchQuotesErrorState extends FetchQuotesState {
  final String error;

  const FetchQuotesErrorState({required this.error});

  @override
  List<Object> get props => [error];
}
