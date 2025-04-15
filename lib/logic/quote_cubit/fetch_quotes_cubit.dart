import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/common/api_constants.dart';
import 'package:mypost/common/hive_constants.dart';
import 'package:mypost/data/entity/quote_entity/quote_entity.dart';
import 'package:mypost/data/model/quote_model.dart';
import 'package:mypost/globals.dart';

part 'fetch_quotes_state.dart';

class FetchQuotesCubit extends Cubit<FetchQuotesState> {
  FetchQuotesCubit() : super(FetchQuotesLoadingState());

  List<String> quoteCategory = [];

  List<QuoteEntity> loveQuote = [];
  List<QuoteEntity> positiveQuote = [];
  List<QuoteEntity> sadQuote = [];
  List<QuoteEntity> attitudeQuote = [];
  List<QuoteEntity> motivationalQuote = [];
  List<QuoteEntity> successQuote = [];

  String url = ApiConstants.baseUrl;

  void fetchQuotes({
    required String quoteType,
    required FetchQuotesLoadedState quoteLoadedState,
  }) async {
    try {
      Response response = await Dio().get(url + quoteType);

      if (response.statusCode == 200) {
        final data = QuoteModel.fromJson(response.data);
        addToList(quote: data.quoteData, quoteLoadedState: quoteLoadedState);
      }
    } catch (e) {
      throw "$e";
    }
  }

  void addToList({
    required QuoteEntity quote,
    required FetchQuotesLoadedState quoteLoadedState,
  }) async {
    quotesDataList = List<QuoteEntity>.from(
      await quotesBox.get(HiveConstants.QUOTES_DATA) ?? [],
    );

    quotesDataList.add(quote);
    List<QuoteEntity> qtData = removeDuplicateQuotes(
      data: quotesDataList,
      quoteLoadedState: quoteLoadedState,
    );

    await quotesBox.put(HiveConstants.QUOTES_DATA, qtData);
    fetchQuotes(quoteType: '', quoteLoadedState: quoteLoadedState);
  }

  List<QuoteEntity> removeDuplicateQuotes({
    required List<QuoteEntity> data,
    required FetchQuotesLoadedState quoteLoadedState,
  }) {
    final seen = <String>{};
    final uniqueList = <QuoteEntity>[];
    for (final item in data) {
      final key = '${item.type}|${item.quote}';
      if (seen.add(key)) {
        getCategoryData(quote: item);
        uniqueList.add(item);
      }
    }
    return uniqueList;
  }

  getCategoryData({
    required QuoteEntity quote,
    FetchQuotesLoadedState? quoteLoadedState,
  }) {
    if (!(quoteCategory.contains(quote.type))) {
      quoteCategory.add(quote.type);
    }
    if (quote.type == ApiConstants.positive) {
      positiveQuote.add(quote);
    }
    if (quote.type == ApiConstants.sad) {
      sadQuote.add(quote);
    }
    if (quote.type == ApiConstants.love) {
      loveQuote.add(quote);
    }
    if (quote.type == ApiConstants.motivational) {
      motivationalQuote.add(quote);
    }
    if (quote.type == ApiConstants.success) {
      successQuote.add(quote);
    }
    if (quote.type == ApiConstants.attitude) {
      attitudeQuote.add(quote);
    }

    if (quoteLoadedState != null) {
      emit(
        quoteLoadedState.copyWith(
          quotesData: [],
          loveQuoteData: [],
          positiveQuoteData: [],
          sadQuoteData: [],
          successQuotesData: [],
          motivationalQuotesData: [],
          attitudeQuotesData: [],
        ),
      );
    } else {
      emit(
        FetchQuotesLoadedState(
          quotesData: quotesDataList,
          loveQuoteData: loveQuote.toSet().toList(),
          positiveQuoteData: positiveQuote.toSet().toList(),
          sadQuoteData: sadQuote.toSet().toList(),
          successQuotesData: successQuote.toSet().toList(),
          motivationalQuotesData: motivationalQuote.toSet().toList(),
          attitudeQuotesData: attitudeQuote.toSet().toList(),
          random: Random().nextDouble(),
        ),
      );
    }
  }

  Future<void> getHomeData() async {
    emit(FetchQuotesLoadingState());
    var jsonData = await rootBundle.loadString(
      "assets/json_data/quote_data.json",
    );

    final qData = List<QuoteModel>.from(
      json.decode(jsonData).map((v) => QuoteModel.fromJson(v)).toList(),
    );
    for (var data in qData) {
      getCategoryData(quote: data.quoteData);
    }
  }
}
