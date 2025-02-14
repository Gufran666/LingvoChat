// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grammer_error.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GrammarErrorAdapter extends TypeAdapter<GrammarError> {
  @override
  final int typeId = 5;

  @override
  GrammarError read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GrammarError(
      offset: fields[0] as int,
      length: fields[1] as int,
      message: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GrammarError obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.offset)
      ..writeByte(1)
      ..write(obj.length)
      ..writeByte(2)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrammarErrorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
