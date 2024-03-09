import 'package:flutter/material.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:objectbox/objectbox.dart';
import '../constants/Constants.dart';

enum AccountType { wallet, savings, debt }

@Entity()
class Account {
  @Id()
  int accountID = 0;

  int icon;

  int color;

  String name;

  String description;

  @Transient()
  AccountType? accountType;

  double balance;

  double creditLimit;

  bool isIncludedInTotalNet;

  int currencyID;

  bool isArchived;

  int? get dbAccountType {
    _ensureStableEnumValues();
    return accountType?.index;
  }

  set dbAccountType(int? value) {
    _ensureStableEnumValues();
    if (value == null) {
      accountType = null;
    } else {
      accountType = AccountType.values[value];
    }
  }

  Account(
      {required this.icon,
      required this.color,
      required this.name,
      required this.balance,
      required this.creditLimit,
      required this.description,
      required this.isIncludedInTotalNet,
      required this.isArchived,
      required this.currencyID,
      this.accountType});

  void _ensureStableEnumValues() {
    assert(AccountType.wallet.index == 0);
    assert(AccountType.savings.index == 1);
    assert(AccountType.debt.index == 2);
  }

  Currency getCurrency() {
    return currencyList[currencyID];
  }

  Color getColor() {
    return Color(color).withOpacity(1);
  }

  IconData getIconData() {
    return IconData(icon, fontFamily: "MaterialIcons");
  }
}
