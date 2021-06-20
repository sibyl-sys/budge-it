import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/services/account.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:collection/collection.dart';

class User extends ChangeNotifier {
  List<Account> accounts = [];
  List<Category> categories = [];
  List<Transaction> transactions = [];
  int lastSelectedCategory;
  int lastSelectedAccount;
  Currency primaryCurrency;

  int get newAccountID => accounts.length < 1 ? 0 : accounts[accounts.length-1].accountID + 1 ;
  int get newCategoryID => categories.length < 1 ? 0 : categories[categories.length-1].categoryID + 1;
  int get newTransactionID => transactions.length < 1 ? 0 : transactions[transactions.length-1].transactionID + 1;

  List<Category> get expenseCategories {
    return categories.where((element) => element.categoryType == CategoryType.expense).toList();
  }

  List<Category> get incomeCategories {
    return categories.where((element) => element.categoryType == CategoryType.income).toList();
  }

  List<Account> get stashAccounts {
    return accounts.where((element) => element.accountType == AccountType.wallet && !element.isArchived).toList();
  }

  List<Account> get savingsAccounts {
    return accounts.where((element) => element.accountType == AccountType.savings && !element.isArchived).toList();
  }

  //TODO CREATE I OWE ACCOUNTS
  //TODO CREATE I AM OWED ACCOUNTS
  //TODO CREATE FULLY PAID ACCOUNTS

  double get totalSavings {
    double total = 0;
    for(var account in accounts) {
      if(account.accountType == AccountType.savings && !account.isArchived) {
        total += account.balance;
        print(total);
      }
    }
    return total;
  }

  double get totalRegular {
    double total = 0;
    for(var account in accounts) {
      if(account.accountType == AccountType.wallet && !account.isArchived) {
        total += account.balance;
      }
    }
    return total;
  }

  double get totalNet {
    double total = 0;
    for(var account in accounts) {
      if(account.isIncludedInTotalNet && !account.isArchived) {
        if(account.currency == primaryCurrency) {
          total += account.balance;
        } else {
          total += exchangeCurrency(account.balance, account.currency, primaryCurrency);
        }
      }
    }
    return total;
  }

  Account findAccountByID(int accountID) {
    return accounts.firstWhereOrNull((account) => account.accountID == accountID);
  }

  int getAccountIndexByID(int accountID) {
    return accounts.indexWhere((account) => account.accountID == accountID);
  }

  Category findCategoryByID(int categoryID) {
    return categories.firstWhereOrNull((category) => category.categoryID == categoryID);
  }

  int getTransactionIndexByID(int transactionID) {
    return transactions.indexWhere((transaction) => transaction.transactionID == transactionID);
  }

  Transaction findTransactionByID(int transactionID) {
    return transactions.firstWhereOrNull((transaction) => transaction.transactionID == transactionID);
  }

  double exchangeCurrency(double value, Currency from, Currency to) {
    return value * from.exchangeRateToUSD / to.exchangeRateToUSD;
  }

  void updateAccount(Account account) async {
    accounts[this.getAccountIndexByID(account.accountID)] = account;

    Hive.box('budgeItApp').put('accounts', accounts);
    print(Hive.box('budgeItApp').get('accounts'));
    notifyListeners();
  }


  void addAccount(Account account) async {
    accounts = List.from(accounts)..add(account);

    Hive.box('budgeItApp').put('accounts', accounts);
    print(Hive.box('budgeItApp').get('accounts'));
    notifyListeners();
  }

  double getAccountExpenses(int accountID, int month, int year) {
    double accountExpenses = 0;
    //TODO LIMIT TO CURRENT MONTH
    for(var transaction in transactions) {
      if(transaction.accountID == accountID && transaction.timestamp.month == month && transaction.timestamp.year == year && !transaction.isArchived) {
        accountExpenses += transaction.value;
      }
    }
    return accountExpenses;
  }

  int getTransactionCount({int month, int year, int accountID}) {
    int transactionCount = 0;
    for(Transaction transaction in transactions) {
      if (transaction.timestamp.month == month &&
          transaction.timestamp.year == year &&
          (accountID == -1 || transaction.accountID == accountID) &&
          !transaction.isArchived) {
        transactionCount++;
      }
    }
    return transactionCount;
  }

  double getCategoryNet({int month, int year, int categoryID}) {
    double categoryNet = 0;
    for(Transaction transaction in transactions) {
      if (transaction.timestamp.month == month &&
          transaction.timestamp.year == year &&
          transaction.categoryID == categoryID &&
          !transaction.isArchived) {
        Account transactionAccount = findAccountByID(transaction.accountID);
        if(transactionAccount.currency == primaryCurrency) {
          categoryNet+= transaction.value;
        } else {
          categoryNet+= exchangeCurrency(transaction.value, transactionAccount.currency, primaryCurrency);
        }
      }
    }
    return categoryNet;
  }

  double getCategoryTypeNet({int month, int year, CategoryType categoryType}) {
    double categoryNet = 0;
    for(Transaction transaction in transactions) {
      if (transaction.timestamp.month == month &&
          transaction.timestamp.year == year) {
        if (transaction.transactionType == TransactionType.expense && categoryType == CategoryType.expense && !transaction.isArchived) {
          categoryNet -= transaction.value;
        } else if (transaction.transactionType == TransactionType.income && categoryType == CategoryType.income && !transaction.isArchived) {
          categoryNet += transaction.value;
        }
      }
    }
    return categoryNet;
  }

  double getMonthlyNet({int month, int year, int accountID}) {
    double monthlyNet = 0;
    for(Transaction transaction in transactions) {
      if (transaction.timestamp.month == month &&
          transaction.timestamp.year == year &&
          (accountID == -1 || transaction.accountID == accountID)) {
        if (transaction.transactionType == TransactionType.expense && !transaction.isArchived) {
          monthlyNet -= transaction.value;
        } else if (transaction.transactionType == TransactionType.income && !transaction.isArchived) {
          monthlyNet += transaction.value;
        }
      }
    }
    return monthlyNet;
  }

 List<Map> getTransactions({int month, int year, int accountID}) {
    List<Map> transactionsByDate = new List<Map>();
    for(Transaction transaction in transactions) {
      if(transaction.timestamp.month == month && transaction.timestamp.year == year && (accountID == -1 || transaction.accountID == accountID) && !transaction.isArchived) {
        int objectIndex = transactionsByDate.indexWhere((element) => element["day"] == transaction.timestamp.day);
        if(objectIndex == -1) {
          Map transactionObject = {
            "day" : transaction.timestamp.day,
           "weekday" : transaction.timestamp.weekday,
           "month" : transaction.timestamp.month,
           "year" : transaction.timestamp.year,
           "transactions" : new List<Transaction>(),
           "value" : 0
           };
            transactionObject["transactions"].add(transaction);
            if(transaction.transactionType == TransactionType.expense) {
              transactionObject["value"] -= transaction.value;
            } else if(transaction.transactionType == TransactionType.income ) {
              transactionObject["value"] += transaction.value;
            }
            transactionsByDate.add(transactionObject);
        } else {
          transactionsByDate[objectIndex]["transactions"].add(transaction);
          if(transaction.transactionType == TransactionType.expense) {
            transactionsByDate[objectIndex]["value"] -= transaction.value;
          } else if(transaction.transactionType == TransactionType.income ) {
            transactionsByDate[objectIndex]["value"] += transaction.value;
          }
        }
      }
    }
    transactionsByDate.sort((a, b) => b["day"].compareTo(a["day"]));
    return transactionsByDate;
  }
  
  void archiveAccount(int accountID) async {
    accounts[this.getAccountIndexByID(accountID)].isArchived = true;

    for(Transaction transaction in transactions) {
      if (transaction.accountID == accountID) {
        transaction.isArchived = true;
      }
    }

    Hive.box('budgeItApp').put('accounts', accounts);
    Hive.box('budgeItApp').put('transactions', transactions);
    print(Hive.box('budgeItApp').get('accounts'));
    notifyListeners();
  }

  void deleteAccount(int accountID) async {
    accounts.removeWhere((account) => account.accountID == accountID);
    transactions.removeWhere((transaction) => transaction.accountID == accountID);


    Hive.box('budgeItApp').put('accounts', accounts);
    Hive.box('budgeItApp').put('transactions', transactions);
    print(Hive.box('budgeItApp').get('accounts'));
    notifyListeners();
  }

  void selectAccount(int accountIndex) async {
    lastSelectedAccount = accountIndex;
    Hive.box('budgeItApp').put('selectedAccount', lastSelectedAccount);
    notifyListeners();
  }

  void selectCategory(int categoryIndex) async {
    lastSelectedCategory = categoryIndex;
    Hive.box('budgeItApp').put('selectedCategory', lastSelectedCategory);

    notifyListeners();
  }

  void deleteTransaction(int transactionID) async {
    transactions.removeWhere((transaction) => transaction.transactionID == transactionID);

    Hive.box('budgeItApp').put('transactions', transactions);
    print(Hive.box('budgeItApp').get('accounts'));
    notifyListeners();
  }

  void updateTransaction(Transaction transaction) {
    print(transaction.transactionID);
    transactions[this.getTransactionIndexByID(transaction.transactionID)] = transaction;

    Hive.box('budgeItApp').put('transactions', transactions);
    print(Hive.box('budgeItApp').get('transactions'));
    notifyListeners();
  }
  

  void addTransaction(Transaction transaction) async {
    transactions = List.from(transactions)..add(transaction);

    if(transaction.transactionType == TransactionType.expense) {
      accounts[transaction.accountID].balance -= transaction.value;
    } else if(transaction.transactionType == TransactionType.income ) {
      accounts[transaction.accountID].balance += transaction.value;
    }

    Hive.box('budgeItApp').put('accounts', accounts);
    Hive.box('budgeItApp').put('transactions', transactions);
    print(Hive.box('budgeItApp').get('transactions'));
    notifyListeners();
  }

  void changePrimaryCurrency(Currency newCurrency) {
    this.primaryCurrency = newCurrency;

    Hive.box('budgeItApp').put('primaryCurrency', primaryCurrency);
    notifyListeners();
  }

  void init(List<Account> accounts, List<Category> categories, List<Transaction> transactions, int lastSelectedCategory, int lastSelectedAccount, Currency primaryCurrency) {
    this.accounts = List.from(accounts);
    this.categories = List.from(categories);
    this.transactions = List.from(transactions);
    this.lastSelectedAccount = lastSelectedAccount;
    this.lastSelectedCategory = lastSelectedCategory;
    this.primaryCurrency = primaryCurrency;
  }
}