import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 6)
enum TransactionType {
  @HiveField(0)
  expense,
  @HiveField(1)
  income,
  @HiveField(2)
  transfer
}

@HiveType(typeId: 2)
class Transaction {
  
  @HiveField(0)
  double value;
  
  @HiveField(1)
  String note;
  
  @HiveField(2)
  DateTime timestamp;

  @HiveField(3)
  int transactionID;

  @HiveField(4)
  int categoryID;

  @HiveField(5)
  int accountID;

  @HiveField(6)
  TransactionType transactionType;

  @HiveField(7)
  bool isArchived;

  Transaction({this.value, this.note, this.transactionID, this.timestamp, this.categoryID, this.accountID, this.transactionType, this.isArchived});
}