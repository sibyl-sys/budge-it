// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 6;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.expense;
      case 1:
        return TransactionType.income;
      case 2:
        return TransactionType.transfer;
      default:
        return TransactionType.expense;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.expense:
        writer.writeByte(0);
        break;
      case TransactionType.income:
        writer.writeByte(1);
        break;
      case TransactionType.transfer:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionImportanceAdapter extends TypeAdapter<TransactionImportance> {
  @override
  final int typeId = 7;

  @override
  TransactionImportance read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionImportance.need;
      case 1:
        return TransactionImportance.want;
      case 2:
        return TransactionImportance.sudden;
      default:
        return TransactionImportance.need;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionImportance obj) {
    switch (obj) {
      case TransactionImportance.need:
        writer.writeByte(0);
        break;
      case TransactionImportance.want:
        writer.writeByte(1);
        break;
      case TransactionImportance.sudden:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionImportanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 2;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      value: fields[0] as double,
      note: fields[1] as String,
      transactionID: fields[3] as int,
      timestamp: fields[2] as DateTime,
      toID: fields[4] as int,
      fromID: fields[5] as int,
      transactionType: fields[6] as TransactionType,
      isArchived: fields[7] as bool,
      importance: fields[8] as TransactionImportance,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.value)
      ..writeByte(1)
      ..write(obj.note)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.transactionID)
      ..writeByte(4)
      ..write(obj.toID)
      ..writeByte(5)
      ..write(obj.fromID)
      ..writeByte(6)
      ..write(obj.transactionType)
      ..writeByte(7)
      ..write(obj.isArchived)
      ..writeByte(8)
      ..write(obj.importance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
