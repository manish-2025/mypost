import 'package:hive/hive.dart';
part 'quote_entity.g.dart';

@HiveType(typeId: 0)
class QuoteEntity extends HiveObject {
  @HiveField(0)
  final String type;
  @HiveField(1)
  final String quote;

  QuoteEntity({required this.type, required this.quote});

  QuoteEntity copyWith({
    
    String? type,
    String? quote,
    
  }) {
    return QuoteEntity(
      type: type ?? this.type,
      quote: quote ?? this.quote,
    
    );
  }
}
