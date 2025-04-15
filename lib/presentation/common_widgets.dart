// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mypost/common/app_colors.dart';
import 'package:mypost/data/entity/quote_entity/quote_entity.dart';
import 'package:mypost/presentation/screens/quote_screens/quote_list_screen.dart';

class CommonWidgets {
  Widget commonTextFormField({
    required TextEditingController controller,
    required String lalbleText,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      height: 65,
      child: TextFormField(
        style: TextStyle(height: 1, fontSize: 14),
        controller: controller,
        cursorHeight: 18,
        decoration: InputDecoration(
          labelText: lalbleText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  commonButton1({
    required void Function() onTap,
    required String title,
    Widget? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.buttonColor,
        shadowColor: AppColors.shadowColor,
        child: SizedBox(
          height: 50,
          width: 140,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.buttonTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget commonButton({
    required String title,
    required Function() onTap,
    Widget? buttonIcon,
    double? height,
    double? width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.buttonColor,
        child: SizedBox(
          height: height ?? 45,
          width: width ?? 130,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buttonIcon ?? SizedBox.shrink(),
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.buttonTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  adWidget({double? height, double? width}) {
    return Visibility(
      visible: true,
      child: Container(
        height: height ?? 120,
        width: width ?? 400,
        decoration: BoxDecoration(color: Colors.green),
        child: Center(child: Text("Advertisement")),
      ),
    );
  }

  buildImageAndQuoteCategoryCard({
    required String title,
    required List<QuoteEntity> quoteData,
    required BuildContext context,
    double? height,
    double? width,
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
          width: width ?? MediaQuery.of(context).size.width * 0.4,
          height: height ?? MediaQuery.of(context).size.width * 0.2,
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
