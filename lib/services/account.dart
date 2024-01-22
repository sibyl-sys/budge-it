import 'package:hive/hive.dart';
import 'package:money_tracker/services/currency.dart';

part 'account.g.dart';

@HiveType(typeId:3)
enum AccountType {
  @HiveField(0)
  wallet,
  @HiveField(1)
  savings,
  @HiveField(2)
  debt
}

@HiveType(typeId: 0)
class Account {
  @HiveField(0)
  int icon;

  @HiveField(1)
  int color;

  @HiveField(3)
  String name;

  @HiveField(4)
  String description;

  @HiveField(5)
  AccountType accountType;

  @HiveField(6)
  double balance;

  @HiveField(7)
  double creditLimit;

  @HiveField(8)
  bool isIncludedInTotalNet;

  @HiveField(9)
  bool isDarkIcon;

  @HiveField(10)
  Currency currency;

  @HiveField(11)
  int accountID;

  @HiveField(12)
  bool isArchived;

  Account({required this.icon, required this.color, required this.name, required this.accountType, required this.balance, required this.creditLimit, required this.description, required this.isIncludedInTotalNet, required this.isDarkIcon, required this.accountID, required this.isArchived, required this.currency});
}