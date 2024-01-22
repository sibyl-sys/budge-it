// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcategory.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubcategoryAdapter extends TypeAdapter<Subcategory> {
  @override
  final int typeId = 8;

  @override
  Subcategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subcategory(
      icon: fields[0] as int,
      name: fields[2] as String,
      id: fields[3] as int
    );
  }

  @override
  void write(BinaryWriter writer, Subcategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubcategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
