import 'package:flutter/material.dart';
import 'package:mypost/common/app_colors.dart';
import 'package:mypost/data/entity/quote_entity/quote_entity.dart';

class QuoteListScreen extends StatefulWidget {
  final String title;
  final List<QuoteEntity> quoteData;
  const QuoteListScreen({
    super.key,
    required this.title,
    required this.quoteData,
  });

  @override
  State<QuoteListScreen> createState() => _QuoteListScreenState();
}

class _QuoteListScreenState extends State<QuoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title), centerTitle: true),
        body: buildBody(context: context),
      ),
    );
  }

  Widget buildBody({required BuildContext context}) {
    return ListView.builder(
      itemCount: widget.quoteData.length,
      itemBuilder: (context, index) {
        QuoteEntity quoteEntity = widget.quoteData[index];
        return Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderColor),
                color: const Color.fromARGB(255, 181, 184, 248),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    quoteEntity.quote,
                    style: TextStyle(height: 1.2),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, quoteEntity.quote);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBGColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add, size: 16, color: Colors.black),
                              SizedBox(width: 2),
                              Text("Add", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(width: 15),
                      Visibility(
                        visible: false,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBGColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.copy, size: 16, color: Colors.black),
                              SizedBox(width: 2),
                              Text("Copy", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(width: 15),
                      Visibility(
                        visible: false,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBGColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.share, size: 16, color: Colors.black),
                              SizedBox(width: 2),
                              Text("Share", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
