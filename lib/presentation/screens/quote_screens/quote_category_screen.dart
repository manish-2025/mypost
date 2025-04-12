import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/common/api_constants.dart';
import 'package:mypost/common/app_colors.dart';
import 'package:mypost/common/app_constants.dart';
import 'package:mypost/data/entity/quote_entity/quote_entity.dart';
import 'package:mypost/globals.dart';
import 'package:mypost/logic/quote_cubit/fetch_quotes_cubit.dart';
import 'package:mypost/presentation/screens/quote_screens/quote_list_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class QuoteCategoryScreen extends StatefulWidget {
  const QuoteCategoryScreen({super.key});

  @override
  State<QuoteCategoryScreen> createState() => _QuoteCategoryScreenState();
}

class _QuoteCategoryScreenState extends State<QuoteCategoryScreen> {
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
            appBar: AppBar(centerTitle: true, title: Text("Quote Screen")),
            body: buildBody(context: context, fetchQuoteState: quoteState),
            floatingActionButton:
                1 == 1 ? SizedBox() : buildFetchAndShareButton(quoteState),
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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(top: 10),
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
                ],
              )
              : Center(child: Text("Data Not Available")),
    );
  }

  Widget buildFetchAndShareButton(FetchQuotesState quoteState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
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
                Icon(Icons.quiz_outlined),
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
            await Share.shareXFiles([XFile(file.path)], text: 'Json Data');
          },
          child: SizedBox(width: 50, height: 50, child: Icon(Icons.share)),
        ),
      ],
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
    return GestureDetector(
      onTap: () async {
        String? quotes = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    QuoteListScreen(title: title, quoteData: quoteData),
          ),
        );
        if (quotes != null && quotes != '') {
          Navigator.pop(context, quotes);
        }
      },
      child: Card(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.width * 0.2,
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [Text(title), Text(quoteData.length.toString())],
          ),
        ),
      ),
    );
  }
}
