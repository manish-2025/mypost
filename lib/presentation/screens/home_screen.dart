import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/common/api_constants.dart';
import 'package:mypost/common/app_colors.dart';
import 'package:mypost/common/app_constants.dart';
import 'package:mypost/data/entity/quote_entity.dart';
import 'package:mypost/globals.dart';
import 'package:mypost/logic/cubit/fetch_quotes_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String quote = '';
  late FetchQuotesCubit fetchQuotesCubit;

  @override
  void initState() {
    fetchQuotesCubit = BlocProvider.of<FetchQuotesCubit>(context);
    fetchQuotesCubit.getHomeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<FetchQuotesCubit, FetchQuotesState>(
        builder: (context, quoteState) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              centerTitle: true,
              title: Text("Home Screen"),
            ),
            body: buildBody(context: context, fetchQuoteState: quoteState),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    fetchQuotesCubit.fetchQuotes(
                      quoteType: ApiConstants.attitude,
                      quoteLoadedState: quoteState as FetchQuotesLoadedState,
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.borderColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.download),
                        if (quoteState is FetchQuotesLoadedState) ...{
                          Text("${quoteState.quotesData.length}"),
                        },
                      ],
                    ),
                  ),
                ),
                FloatingActionButton.small(
                  onPressed: () async {
                    List<Map<String, String>> jsonData = getData();

                    final directory =
                        await getApplicationDocumentsDirectory(); // Safe file location
                    final path = '${directory.path}/quote_data.json';
                    final file = File(path);
                    await file.writeAsString(jsonEncode(jsonData));
                    print("object => ${file.runtimeType} :: ${file.path}");
                    final result = await Share.shareXFiles([
                      XFile(file.path),
                    ], text: 'Json Data');

                    if (result.status == ShareResultStatus.success) {
                      print('Thank you for sharing the picture!');
                    }
                  },
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.share),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildBody({
    required BuildContext context,
    required FetchQuotesState fetchQuoteState,
  }) {
    if (fetchQuoteState is FetchQuotesLoadingState) {
      return Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child:
          (fetchQuoteState is FetchQuotesLoadedState)
              ? Wrap(
                alignment: WrapAlignment.center,
                children: [
                  buildCategoryCard(
                    title: AppConstants.successQuote,
                    quoteData: fetchQuoteState.successQuotesData,
                  ),
                  buildCategoryCard(
                    title: AppConstants.motivationQuote,
                    quoteData: fetchQuoteState.motivationalQuotesData,
                  ),
                  buildCategoryCard(
                    title: AppConstants.loveQuote,
                    quoteData: fetchQuoteState.loveQuoteData,
                  ),
                  buildCategoryCard(
                    title: AppConstants.positiveQuote,
                    quoteData: fetchQuoteState.loveQuoteData,
                  ),
                  buildCategoryCard(
                    title: AppConstants.sadQuote,
                    quoteData: fetchQuoteState.sadQuoteData,
                  ),
                  buildCategoryCard(
                    title: AppConstants.attitudeQuote,
                    quoteData: fetchQuoteState.attitudeQuotesData,
                  ),
                  // Text("${fetchQuotesCubit.quoteCategory}"),
                ],
              )
              : Center(child: Text("Data Not Available")),
    );
  }

  List<Map<String, String>> getData() {
    final seen = <String>{};
    final result = <Map<String, dynamic>>[];

    for (var map in quotesDataList) {
      final jsonString = jsonEncode({
        "type": map.type,
        "quote": map.quote,
      }); // Serialize to string
      if (seen.add(jsonString)) {
        result.add({
          "type": map.type,
          "quote": map.quote,
        }); // Only add if not seen before
      }
    }
    quotesDataList.toSet().toList();

    List<Map<String, String>> json = [];
    for (var data in quotesDataList) {
      json.add({"type": data.type, "quote": data.quote});
    }
    return json;
  }

  buildCategoryCard({
    required String title,
    required List<QuoteEntity> quoteData,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.43,
      height: MediaQuery.of(context).size.width * 0.25,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: [Text(title), Text(quoteData.length.toString())],
      ),
    );
  }
}
