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

@HiveType(typeId: 7)
enum TransactionImportance {
  @HiveField(0)
  need,
  @HiveField(1)
  want,
  @HiveField(2)
  sudden
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
  int toID;

  @HiveField(5)
  int fromID;

  @HiveField(6)
  TransactionType transactionType;

  @HiveField(7)
  bool isArchived;

  @HiveField(8)
  TransactionImportance importance;

  Transaction({required this.value,required  this.note,required  this.transactionID,required this.timestamp,required  this.toID,required  this.fromID,required this.transactionType,required this.isArchived,required this.importance});
}