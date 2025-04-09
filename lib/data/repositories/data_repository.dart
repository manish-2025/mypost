// // ignore_for_file: avoid_print

// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

// import 'package:dio/dio.dart';
// import 'package:mypost/common/api_constants.dart';
// import 'package:mypost/common/app_constants.dart';
// import 'package:mypost/common/hive_constants.dart';
// import 'package:mypost/data/entity/quote_entity.dart';
// import 'package:mypost/data/repositories/api/api.dart';
// import 'package:mypost/globals.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DataRepository {
//   // Api api = Api();
//   // String url = ApiConstants.baseUrl;
//   // SharedPreferences? prefs;
//   // List<QuoteEntity> myQuote = [];

//   // Future<String> fetchQuotes({required String quoteType}) async {
//   //   prefs ??= await SharedPreferences.getInstance();

//   //   try {
//   //     Response response = await Dio().get(url + quoteType);

//   //     if (response.statusCode == 200) {
//   //       print("object => ${response.data}");
//   //       await prefs!.setString(
//   //         AppConstants.quoteData,
//   //         jsonEncode(response.data),
//   //       );

//   //       print("object GET=> ${prefs!.getString(AppConstants.quoteData)}");

//   //       return response.data['quote'];
//   //     } else {
//   //       print('Failed to load quotes: ${response.statusCode}');
//   //       return "Failed";
//   //     }
//   //   } catch (e) {
//   //     print('Error: $e');
//   //     return 'Error: ${e.toString()}';
//   //   }
//   // }

//   // void addToCart({
//   //   required List<QuoteEntity> diamondData,
//   //   required QuoteEntity item,
//   // }) async {
//   //   bool existsByName = myQuote.any((quote) {
//   //     return quote.quote == item.quote;
//   //   });

//   //   if (existsByName) {
//   //     myQuote.remove(item);
//   //   } else {
//   //     myQuote.add(item);
//   //   }

//   //   await quotesBox.put(HiveConstants.QUOTES_DATA, myQuote);
//   //   quotesDataList.addAll(await quotesBox.get(HiveConstants.QUOTES_DATA));
//   //   emit(
//   //     FilterResultLoadedState(
//   //       filteredDiamondData: filteredDiamondData,
//   //       myCardItem: myQuote,
//   //       random: Random().nextDouble(),
//   //     ),
//   //   );
//   // }
// }
