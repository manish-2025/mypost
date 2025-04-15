import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mypost/common/app_constants.dart';
import 'package:mypost/logic/quote_cubit/fetch_quotes_cubit.dart';
import 'package:mypost/presentation/common_widgets.dart';

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
            appBar: AppBar(
              centerTitle: true,
              title: Text(AppConstants.titleQuoteScreen),
            ),
            body: buildBody(context: context, fetchQuoteState: quoteState),
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
                  CommonWidgets().buildImageAndQuoteCategoryCard(
                    context: context,
                    title: AppConstants.successQuote,
                    quoteData: fetchQuoteState.successQuotesData,
                  ),
                  CommonWidgets().buildImageAndQuoteCategoryCard(
                    context: context,
                    title: AppConstants.motivationQuote,
                    quoteData: fetchQuoteState.motivationalQuotesData,
                  ),
                  CommonWidgets().buildImageAndQuoteCategoryCard(
                    context: context,
                    title: AppConstants.loveQuote,
                    quoteData: fetchQuoteState.loveQuoteData,
                  ),
                  CommonWidgets().buildImageAndQuoteCategoryCard(
                    context: context,
                    title: AppConstants.positiveQuote,
                    quoteData: fetchQuoteState.loveQuoteData,
                  ),
                  CommonWidgets().buildImageAndQuoteCategoryCard(
                    context: context,
                    title: AppConstants.sadQuote,
                    quoteData: fetchQuoteState.sadQuoteData,
                  ),
                  CommonWidgets().buildImageAndQuoteCategoryCard(
                    context: context,
                    title: AppConstants.attitudeQuote,
                    quoteData: fetchQuoteState.attitudeQuotesData,
                  ),
                ],
              )
              : Center(child: Text("Data Not Available")),
    );
  }
}
