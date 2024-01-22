// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryTypeAdapter extends TypeAdapter<CategoryType> {
  @override
  final int typeId = 4;

  @override
  CategoryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CategoryType.expense;
      case 1:
        return CategoryType.income;
      default:
        return CategoryType.expense;
    }
  }

  @override
  void write(BinaryWriter writer, CategoryType obj) {
    switch (obj) {
      case CategoryType.expense:
        writer.writeByte(0);
        break;
      case CategoryType.income:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      icon: fields[0] as int,
      color: fields[1] as int,
      name: fields[2] as String,
      categoryType: fields[3] as CategoryType,
      categoryID: fields[4] as int,
      categoryCurrency: fields[6] as Currency,
      index: fields[7] as int,
      subcategories: (fields[8] as List)!.cast<Subcategory>(),
    )..lastTransactionImportance = fields[5] as TransactionImportance;
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.icon)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.categoryType)
      ..writeByte(4)
      ..write(obj.categoryID)
      ..writeByte(5)
      ..write(obj.lastTransactionImportance)
      ..writeByte(6)
      ..write(obj.categoryCurrency)
      ..writeByte(7)
      ..write(obj.index)
      ..writeByte(8)
      ..write(obj.subcategories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
