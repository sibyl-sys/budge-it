import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/transaction.dart';

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
//TODO INTEGRATE ACCOUNT ID
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

  Account({this.icon, this.color, this.name, this.accountType, this.balance, this.creditLimit, this.description, this.isIncludedInTotalNet, this.isDarkIcon, this.accountID, this.isArchived, this.currency});
}