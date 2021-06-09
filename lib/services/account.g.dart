// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountTypeAdapter extends TypeAdapter<AccountType> {
  @override
  final int typeId = 3;

  @override
  AccountType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AccountType.wallet;
      case 1:
        return AccountType.savings;
      case 2:
        return AccountType.debt;
      default:
        return AccountType.wallet;
    }
  }

  @override
  void write(BinaryWriter writer, AccountType obj) {
    switch (obj) {
      case AccountType.wallet:
        writer.writeByte(0);
        break;
      case AccountType.savings:
        writer.writeByte(1);
        break;
      case AccountType.debt:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccountAdapter extends TypeAdapter<Account> {
  @override
  final int typeId = 0;

  @override
  Account read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Account(
      icon: fields[0] as int,
      color: fields[1] as int,
      name: fields[3] as String,
      accountType: fields[5] as AccountType,
      balance: fields[6] as double,
      creditLimit: fields[7] as double,
      description: fields[4] as String,
      isIncludedInTotalNet: fields[8] as bool,
      isDarkIcon: fields[9] as bool,
      accountID: fields[11] as int,
      isArchived: fields[12] as bool,
      currency: fields[10] as Currency,
    );
  }

  @override
  void write(BinaryWriter writer, Account obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.icon)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.accountType)
      ..writeByte(6)
      ..write(obj.balance)
      ..writeByte(7)
      ..write(obj.creditLimit)
      ..writeByte(8)
      ..write(obj.isIncludedInTotalNet)
      ..writeByte(9)
      ..write(obj.isDarkIcon)
      ..writeByte(10)
      ..write(obj.currency)
      ..writeByte(11)
      ..write(obj.accountID)
      ..writeByte(12)
      ..write(obj.isArchived);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
