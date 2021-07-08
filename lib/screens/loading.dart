import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/constants/Constants.dart';
import 'package:money_tracker/services/account.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/subcategory.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void setupHive() async {
    print("START HIVE INITIALIZE");
    await Hive.initFlutter();
    print("HIVE INITIALIZED");
    Hive.registerAdapter(AccountAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(CurrencyAdapter());
    Hive.registerAdapter(CategoryTypeAdapter());
    Hive.registerAdapter(AccountTypeAdapter());
    Hive.registerAdapter(TransactionTypeAdapter());
    Hive.registerAdapter(SubcategoryAdapter());

    var box = await Hive.openBox('budgeItApp');
    List<Account> accounts = List<Account>.from(box.get('accounts', defaultValue:  new List<Account>()));
    Currency primaryCurrency =box.get('primaryCurrency', defaultValue: currencyList[0]);
    for(Account account in accounts) {
      if(account.currency == null) {
        account.currency = primaryCurrency;
      }

      if(account.isArchived == null) {
        account.isArchived = false;
      }
    }

    List<Category> categories = List<Category>.from(box.get('categories', defaultValue: categoryDefault));
    int lastIndex = 0;
    for(Category category in categories) {
      if(category.index == null) {
        category.index = lastIndex + 1;
      }
      lastIndex = category.index;
    }

    List<Transaction> transactions = List<Transaction>.from(box.get('transactions', defaultValue: new List<Transaction>()));

    for(Transaction transaction in transactions) {
      if(transaction.isArchived == null) {
        transaction.isArchived = false;
      }

      if(transaction.importance == null) {
        transaction.importance = TransactionImportance.need;
      }
    }

    int selectedCategory = box.get('selectedCategory', defaultValue: 0);
    int selectedAccount = box.get('selectedAccount', defaultValue: 0);
    User user = context.read<User>();
    user.init(accounts, categories, transactions, selectedCategory, selectedAccount, primaryCurrency);
    Navigator.pushReplacementNamed(context, "/home");
  }

  @override
  void initState() {
    super.initState();
    setupHive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/logo.png')
        )
      )
    );
  }
}
