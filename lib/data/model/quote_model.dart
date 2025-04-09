// ignore_for_file: annotate_overrides, overridden_fields
import 'package:mypost/data/entity/quote_entity.dart';

class QuoteModel {
  final QuoteEntity quoteData;

  QuoteModel({required this.quoteData});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(quoteData: QuoteData.fromJson(json));
  }

  Map<String, dynamic> toJson() {
    return quoteData is QuoteData
        ? (quoteData as QuoteData).toJson()
        : throw Exception(
          'quoteData must be a QuoteData instance to serialize',
        );
  }
}

class QuoteData extends QuoteEntity {
  String type;
  String quote;

  QuoteData({required this.type, required this.quote})
    : super(type: type, quote: quote);

  factory QuoteData.fromJson(Map<String, dynamic> json) {
    return QuoteData(type: json['type'], quote: json['quote']);
  }
  Map<String, dynamic> toJson() {
    return {'type': type, 'quote': quote};
  }
}
