// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteEntityAdapter extends TypeAdapter<QuoteEntity> {
  @override
  final int typeId = 0;

  @override
  QuoteEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuoteEntity(
      type: fields[0] as String,
      quote: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, QuoteEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.quote);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
