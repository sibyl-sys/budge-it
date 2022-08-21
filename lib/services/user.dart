import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_tracker/services/account.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/subcategory.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:collection/collection.dart';

class User extends ChangeNotifier {
  List<Account> accounts = [];
  List<Category> categories = [];
  List<Transaction> transactions = [];
  List<Transaction> transactionAlert = [];
  int lastSelectedCategoryTo;
  int lastSelectedAccountFrom;
  int lastSelectedAccountTo;
  TransactionType lastTransactionType;
  Currency primaryCurrency;
  double spendAlertAmount;

  int get newAccountID => accounts.length < 1 ? 0 : accounts[accounts.length-1].accountID + 1 ;
  int get newCategoryID => categories.length < 1 ? 0 : categories[categories.length-1].categoryID + 1;
  int get newTransactionID => transactions.length < 1 ? 0 : transactions[transactions.length-1].transactionID + 1;

  int newSubCategoryID(List<Subcategory> subcategories) {
    int subcategoryID = 0;
    if(transactions.length > 0) {
      subcategoryID = subcategories[subcategories.length - 1].id + 1;
    }
    return subcategoryID;
  }

  int get newCategoryIndex {
    int maxIndex = 1;
    categories.forEach((element) {
      maxIndex = max(maxIndex, element.index);
    });
    return maxIndex + 1;
  }

  List<Category> get expenseCategories {
    List<Category> expenseCategory = categories.where((element) => element.categoryType == CategoryType.expense).toList();
    expenseCategory.sort((a,b) => a.index.compareTo(b.index));
    return expenseCategory;
  }

  List<Category> get incomeCategories {
    List<Category> incomeCategory = categories.where((element) => element.categoryType == CategoryType.income).toList();
    incomeCategory.sort((a,b) => a.index.compareTo(b.index));
    return incomeCategory;
  }

  List<Account> get stashAccounts {
    return accounts.where((element) => element.accountType == AccountType.wallet && !element.isArchived).toList();
  }

  List<Account> get savingsAccounts {
    return accounts.where((element) => element.accountType == AccountType.savings && !element.isArchived).toList();
  }

  List<Account> get iAmOwedAccounts {
    return accounts.where((element) => element.accountType == AccountType.debt && !element.isArchived && element.balance >= 0).toList();
  }

  List<Account> get iOwedAccounts {
    return accounts.where((element) => element.accountType == AccountType.debt && !element.isArchived && element.balance < 0).toList();
  }

  //TODO CREATE I OWE ACCOUNTS
  //TODO CREATE I AM OWED ACCOUNTS
  //TODO CREATE FULLY PAID ACCOUNTS

  double get totalSavings {
    double total = 0;
    for(var account in accounts) {
      if(account.accountType == AccountType.savings && !account.isArchived) {
        if(account.currency == primaryCurrency) {
          total += account.balance;
        } else {
          total += exchangeCurrency(account.balance, account.currency, primaryCurrency);
        }
        print(total);
      }
    }
    return total;
  }

  double get totalRegular {
    double total = 0;
    for(var account in accounts) {
      if(account.accountType == AccountType.wallet && !account.isArchived) {
        if(account.currency == primaryCurrency) {
          total += account.balance;
        } else {
          total += exchangeCurrency(account.balance, account.currency, primaryCurrency);
        }
      }
    }
    return total;
  }

  double get totalDebts {
    double total = 0;
    for(var account in accounts) {
      if(account.accountType == AccountType.debt && !account.isArchived) {
        if(account.currency == primaryCurrency) {
          total += account.balance;
        } else {
          total += exchangeCurrency(account.balance, account.currency, primaryCurrency);
        }
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

  int getCategoryIndexByID(int categoryID) {
    return categories.indexWhere((category) => category.categoryID == categoryID);
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
      if(transaction.fromID == accountID && transaction.timestamp.month == month && transaction.timestamp.year == year && !transaction.isArchived) {
        accountExpenses += transaction.value;
      }
    }
    return accountExpenses;
  }

  double getAccountProgress(int accountID) {
    int accountIndex = getAccountIndexByID(accountID);

    if(accounts[accountIndex].accountType == AccountType.debt) {
      return 0;
    } else if (accounts[accountIndex].accountType == AccountType.savings) {
      accounts[accountIndex].creditLimit > 0 ? max(0, min(accounts[accountIndex].balance / accounts[accountIndex].creditLimit, 1)) : 0;
    } else if(accounts[accountIndex].accountType == AccountType.wallet) {
      this.getAccountExpenses(accountID, DateTime.now().month, DateTime.now().year) / accounts[accountIndex].creditLimit * 100;
    }

    return 0;
  }

  int getTransactionCount({DateTime from, DateTime to, int accountID}) {
    int transactionCount = 0;
    for(Transaction transaction in transactions) {
      if (transaction.timestamp.compareTo(from) >= 0 &&
          transaction.timestamp.compareTo(to) <= 0 &&
          (accountID == -1 || transaction.fromID == accountID) &&
          !transaction.isArchived) {
        transactionCount++;
      }
    }
    return transactionCount;
  }

  double getCategoryNet({DateTime from, DateTime to, int categoryID}) {
    //TODO IMPLEMENT CURRENCY CALCULATION
    double categoryNet = 0;
    for(Transaction transaction in transactions) {
      if (transaction.timestamp.compareTo(from) >= 0 &&
          transaction.timestamp.compareTo(to) <= 0 &&
          transaction.toID == categoryID &&
          !transaction.isArchived &&
          transaction.transactionType != TransactionType.transfer) {
        Account transactionAccount = findAccountByID(transaction.fromID);
        if(transactionAccount.currency == primaryCurrency) {
          categoryNet+= transaction.value;
        } else {
          categoryNet+= exchangeCurrency(transaction.value, transactionAccount.currency, primaryCurrency);
        }
      }
    }
    return categoryNet;
  }

  double getCategoryTypeNet({DateTime from , DateTime to, CategoryType categoryType}) {
    double categoryNet = 0;
    for(Transaction transaction in transactions) {
      if (transaction.timestamp.compareTo(from) >= 0  &&
          transaction.timestamp.compareTo(to) <= 0) {
        if (transaction.transactionType == TransactionType.expense && categoryType == CategoryType.expense && !transaction.isArchived) {
          categoryNet -= transaction.value;
        } else if (transaction.transactionType == TransactionType.income && categoryType == CategoryType.income && !transaction.isArchived) {
          categoryNet += transaction.value;
        }
      }
    }
    return categoryNet;
  }

  double getMonthlyNet({DateTime from, DateTime to, int accountID}) {
    double monthlyNet = 0;
    for(Transaction transaction in transactions) {
      if (transaction.timestamp.compareTo(from) >= 0 &&
          transaction.timestamp.compareTo(to) <= 0 &&
          (accountID == -1 || transaction.fromID == accountID)) {
        if (transaction.transactionType == TransactionType.expense && !transaction.isArchived) {
          monthlyNet -= transaction.value;
        } else if (transaction.transactionType == TransactionType.income && !transaction.isArchived) {
          monthlyNet += transaction.value;
        }
      }
    }
    return monthlyNet;
  }

 List<Map> getTransactions({DateTime from, DateTime to, int accountID}) {
    List<Map> transactionsByDate = new List<Map>();
    for(Transaction transaction in transactions) {
      if(transaction.timestamp.compareTo(from) >= 0 && transaction.timestamp.compareTo(to) <= 0 && (accountID == -1 || transaction.fromID == accountID || (transaction.transactionType == TransactionType.transfer && transaction.toID == accountID)) && !transaction.isArchived) {
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
      if (transaction.fromID == accountID) {
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
    transactions.removeWhere((transaction) => transaction.fromID == accountID);


    Hive.box('budgeItApp').put('accounts', accounts);
    Hive.box('budgeItApp').put('transactions', transactions);
    print(Hive.box('budgeItApp').get('accounts'));
    notifyListeners();
  }

  void selectAccountFrom(int accountIndex) async {
    lastSelectedAccountFrom = accountIndex;
    Hive.box('budgeItApp').put('selectedAccountFrom', lastSelectedAccountFrom);
    notifyListeners();
  }

  void selectRecipient(int toIndex, TransactionType transactionType) async {
    if(transactionType == TransactionType.transfer) {
      lastSelectedAccountTo = toIndex;
    } else {
      lastSelectedCategoryTo = toIndex;
    }
    lastTransactionType = transactionType;
    Hive.box('budgeItApp').put('lastTransactionType', lastTransactionType);
    Hive.box('budgeItApp').put('selectedAccountTo', lastSelectedAccountTo);
    Hive.box('budgeItApp').put('selectedCategoryTo', lastSelectedCategoryTo);
    notifyListeners();
  }

  void deleteTransaction(int transactionID) async {
    Transaction transaction = findTransactionByID(transactionID);
    if(transaction.transactionType == TransactionType.expense) {
      findAccountByID(transaction.fromID).balance += transaction.value;
    } else if(transaction.transactionType == TransactionType.income ) {
      findAccountByID(transaction.fromID).balance -= transaction.value;
    } else if(transaction.transactionType == TransactionType.transfer) {
      findAccountByID(transaction.fromID).balance += transaction.value;
      findAccountByID(transaction.toID).balance -= transaction.value;
    }

    transactions.removeWhere((transaction) => transaction.transactionID == transactionID);

    Hive.box('budgeItApp').put('accounts', accounts);
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
    print(transaction.transactionType);

    if(transaction.transactionType == TransactionType.expense) {
      findAccountByID(transaction.fromID).balance -= transaction.value;
      if(transaction.value >= spendAlertAmount) {
        transactionAlert = List.from(transactionAlert)..add(transaction);
      }
    } else if(transaction.transactionType == TransactionType.income ) {
      findAccountByID(transaction.fromID).balance += transaction.value;
    } else if(transaction.transactionType == TransactionType.transfer) {
      print(transaction.value);
      findAccountByID(transaction.fromID).balance -= transaction.value;
      findAccountByID(transaction.toID).balance += transaction.value;
      //TODO CONVERT CURRENCIES WHEN TRANSFERRING BETWEEN TWO ACCOUNTS WITH DIFFERENT CURRENCIES.
    }


    Hive.box('budgeItApp').put('accounts', accounts);
    Hive.box('budgeItApp').put('transactions', transactions);
    Hive.box('budgeItApp').put('transactionAlert', transactionAlert);
    print(Hive.box('budgeItApp').get('transactions'));
    notifyListeners();
  }

  void changePrimaryCurrency(Currency newCurrency) {
    this.primaryCurrency = newCurrency;

    Hive.box('budgeItApp').put('primaryCurrency', primaryCurrency);
    notifyListeners();
  }

  void changeSpendAlertAmount(double value) {
    this.spendAlertAmount = value;
    Hive.box('budgeItApp').put('spendAlertAmount', spendAlertAmount);
    notifyListeners();
  }

  void addCategory(Category newCategory) {
    categories = List.from(categories)..add(newCategory);

    Hive.box('budgeItApp').put('categories', categories);
    notifyListeners();
  }

  void updateCategory(Category category) {
    categories[this.getCategoryIndexByID(category.categoryID)] = category;

    Hive.box('budgeItApp').put('categories', categories);
    notifyListeners();
  }

  void rearrangeCategories(List<Category> updatedCategories) {
    updatedCategories.forEach((category) {
      categories[this.getCategoryIndexByID(category.categoryID)] = category;
    });

    Hive.box('budgeItApp').put('categories', categories);
    print(Hive.box('budgeItApp').get('categories'));
    notifyListeners();
  }

  void init(List<Account> accounts, List<Category> categories, List<Transaction> transactions, int lastSelectedCategory, int lastSelectedAccount, Currency primaryCurrency, int lastSelectedAccountTo, TransactionType transactionType, double spendAlertAmount, List<Transaction> transactionAlert) {
    this.accounts = List.from(accounts);
    this.categories = List.from(categories);
    this.transactions = List.from(transactions);
    this.lastSelectedAccountFrom = lastSelectedAccount;
    this.lastSelectedCategoryTo = lastSelectedCategory;
    this.lastSelectedAccountTo = lastSelectedAccountTo;
    this.lastTransactionType = transactionType;
    this.primaryCurrency = primaryCurrency;
    this.spendAlertAmount = spendAlertAmount;
    this.transactionAlert = transactionAlert;
  }
}