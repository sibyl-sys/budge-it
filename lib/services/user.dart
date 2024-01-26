import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/services/account.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/subcategory.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/settings.dart';
import 'package:money_tracker/constants/Constants.dart';
import 'package:money_tracker/main.dart';
import 'package:collection/collection.dart';
import 'package:objectbox/objectbox.dart';

import '../objectbox.g.dart';

class User extends ChangeNotifier {
  List<Account> accounts = [];
  List<Category> categories = [];
  // List<Subcategory> subcategories = [];
  List<Transaction> transactions = [];
  // List<Transaction> transactionAlert = [];
  // List<Transaction> favoriteTransactions = [];

  late Settings mySettings;

  // int get newAccountID => accounts.length < 1 ? 0 : accounts[accounts.length-1].accountID + 1 ;
  // int get newCategoryID => categories.length < 1 ? 0 : categories[categories.length-1].categoryID + 1;
  // int get newTransactionID => transactions.length < 1 ? 0 : transactions[transactions.length-1].transactionID + 1;

  // int newSubCategoryID(List<Subcategory> subcategories) {
  //   int subcategoryID = 0;
  //   if(transactions.length > 0) {
  //     subcategoryID = subcategories[subcategories.length - 1].id + 1;
  //   }
  //   return subcategoryID;
  // }

  int get newCategoryIndex {
    int maxIndex = 1;
    categories.forEach((element) {
      maxIndex = max(maxIndex, element.index);
    });
    return maxIndex + 1;
  }

  List<Category> get expenseCategories {
    Query<Category> expenseQuery = objectbox.categoryBox.query(Category_.dbCategoryType.equals(0)).build();
    List<Category> expenseCategories = expenseQuery.find();
    expenseQuery.close();
    return expenseCategories;
  }

  List<Category> get incomeCategories {
    Query<Category> incomeQuery = objectbox.categoryBox.query(Category_.dbCategoryType.equals(1)).build();
    List<Category> incomeCategories = incomeQuery.find();
    incomeQuery.close();
    return incomeCategories;
  }

  List<Account> get stashAccounts {
    Query<Account> stashQuery = objectbox.accountBox.query(Account_.dbAccountType.equals(0).and(Account_.isArchived.equals(false))).build();
    List<Account> stashAccounts = stashQuery.find();
    stashQuery.close();
    return stashAccounts;
  }

  List<Account> get savingsAccounts {
    Query<Account> savingsQuery = objectbox.accountBox.query(Account_.dbAccountType.equals(1).and(Account_.isArchived.equals(false))).build();
    List<Account> savingsAccounts = savingsQuery.find();
    savingsQuery.close();
    return savingsAccounts;
  }

  List<Account> get debtAccounts {
    Query<Account> debtQuery = objectbox.accountBox.query(Account_.dbAccountType.equals(2) & Account_.isArchived.equals(false)).build();
    List<Account> debtAccounts = debtQuery.find();
    debtQuery.close();
    return debtAccounts;
  }

  List<Account> get iAmOwedAccounts {
    Query<Account> iAmOwedQuery = objectbox.accountBox.query(Account_.dbAccountType.equals(2) & Account_.isArchived.equals(false) & (Account_.balance.greaterThan(0) | Account_.balance.between(0,0))).build();
    List<Account> iAmOwedAccounts = iAmOwedQuery.find();
    iAmOwedQuery.close();
    return iAmOwedAccounts;
  }

  List<Account> get iOwedAccounts {
    Query<Account> iOwedQuery = objectbox.accountBox.query(Account_.dbAccountType.equals(2) & Account_.isArchived.equals(false) & Account_.balance.lessThan(0)).build();
    List<Account> iOwedAccounts = iOwedQuery.find();
    iOwedQuery.close();
    return iOwedAccounts;
  }


  double get totalSavings {
    double total = 0;
    for(var account in savingsAccounts) {
      if(account.getCurrency() == mySettings.getPrimaryCurrency()) {
        total += account.balance;
      } else {
        total += exchangeCurrency(account.balance, account.getCurrency(), mySettings.getPrimaryCurrency());
      }
      print(total);
    }
    return total;
  }

  double get totalRegular {
    double total = 0;
    for(var account in stashAccounts) {
      if(account.getCurrency() == mySettings.getPrimaryCurrency()) {
        total += account.balance;
      } else {
        total += exchangeCurrency(account.balance, account.getCurrency(), mySettings.getPrimaryCurrency());
      }
    }
    return total;
  }

  double get totalDebts {
    double total = 0;
    for(var account in debtAccounts) {
      if(account.getCurrency() == mySettings.getPrimaryCurrency()) {
        total += account.balance;
      } else {
        total += exchangeCurrency(account.balance, account.getCurrency(), mySettings.getPrimaryCurrency());
      }
    }
    return total;
  }

  double get totalNet {
    double total = 0;
    for(var account in accounts) {
      if(account.isIncludedInTotalNet && !account.isArchived) {
        if(account.getCurrency() == mySettings.getPrimaryCurrency()) {
          total += account.balance;
        } else {
          total += exchangeCurrency(account.balance, account.getCurrency(), mySettings.getPrimaryCurrency());
        }
      }
    }
    return total;
  }

  Account? findAccountByID(int accountID) {
    return objectbox.accountBox.get(accountID);
  }

  Category? findCategoryByID(int categoryID) {
    return objectbox.categoryBox.get(categoryID);
  }

  Transaction? findTransactionByID(int transactionID) {
    return transactions.firstWhereOrNull((transaction) => transaction.transactionID == transactionID);
  }

  double exchangeCurrency(double value, Currency from, Currency to) {
    return value * from.exchangeRateToUSD / to.exchangeRateToUSD;
  }

  void updateAccount(Account account) async {
    objectbox.accountBox.put(account);
    accounts = objectbox.accountBox.getAll();
    notifyListeners();
  }

  //TODO MERGE WITH UPDATE ACCOUNT;
  void addAccount(Account account) async {
    objectbox.accountBox.put(account);
    accounts = objectbox.accountBox.getAll();
    notifyListeners();
  }

  //TODO TRANSLATE TO QUERY
  double getAccountExpenses(int accountID, int month, int year) {
    double accountExpenses = 0;
    for(var transaction in transactions) {
      if(transaction.fromID == accountID && transaction.timestamp.month == month && transaction.timestamp.year == year && !transaction.isArchived) {
        accountExpenses += transaction.value;
      }
    }
    return accountExpenses;
  }

  double getAccountProgress(int accountID) {
    Account? currentAccount = objectbox.accountBox.get(accountID);

    if(currentAccount == null)
      return 0;

    if(currentAccount.accountType == AccountType.debt) {
      return 0;
    } else if (currentAccount.accountType == AccountType.savings) {
      return currentAccount.creditLimit > 0 ? max(0, min(currentAccount.balance / currentAccount.creditLimit, 1)) : 0;
    } else if(currentAccount.accountType == AccountType.wallet) {
      return this.getAccountExpenses(accountID, DateTime.now().month, DateTime.now().year) / currentAccount.creditLimit * 100;
    }

    return 0;
  }

  //TODO TRANSLATE TO QUERY
  int getTransactionCount({required DateTime from, required DateTime to, required int accountID}) {
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


  //TODO TRANSLATE TO QUERY
  double getCategoryNet({required DateTime from, required DateTime to, required int categoryID}) {
    double categoryNet = 0;
    for(Transaction transaction in transactions) {
      if (transaction.timestamp.compareTo(from) >= 0 &&
          transaction.timestamp.compareTo(to) <= 0 &&
          transaction.toID == categoryID &&
          !transaction.isArchived &&
          transaction.transactionType != TransactionType.transfer) {
        Account transactionAccount = findAccountByID(transaction.fromID)!;
        if(transactionAccount.getCurrency() == mySettings.getPrimaryCurrency()) {
          categoryNet+= transaction.value;
        } else {
          categoryNet+= exchangeCurrency(transaction.value, transactionAccount.getCurrency(), mySettings.getPrimaryCurrency());
        }
      }
    }
    return categoryNet;
  }

  //TODO TRANSLATE TO QUERY
  double getCategoryTypeNet({required DateTime from, required DateTime to, required CategoryType categoryType}) {
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

  //TODO TRANSLATE TO QUERY
  double getMonthlyNet({required DateTime from, required DateTime to, required int accountID}) {
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

  //TODO TRANSLATE TO QUERY
  List<Map> getTransactions({required DateTime from, required DateTime to,required int accountID}) {
    List<Map> transactionsByDate = <Map>[];
    for(Transaction transaction in transactions) {
      if(transaction.timestamp.compareTo(from) >= 0 && transaction.timestamp.compareTo(to) <= 0 && (accountID == -1 || transaction.fromID == accountID || (transaction.transactionType == TransactionType.transfer && transaction.toID == accountID)) && !transaction.isArchived) {
        int objectIndex = transactionsByDate.indexWhere((element) => element["day"] == transaction.timestamp.day);
        if(objectIndex == -1) {
          Map transactionObject = {
            "day" : transaction.timestamp.day,
           "weekday" : transaction.timestamp.weekday,
           "month" : transaction.timestamp.month,
           "year" : transaction.timestamp.year,
           "transactions" : <Transaction>[],
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
    Account? toArchive = objectbox.accountBox.get(accountID);
    if(toArchive == null)
      return;
    toArchive.isArchived = true;
    objectbox.accountBox.put(toArchive);


    //TODO CHANGE TO QUERY
    for(Transaction transaction in transactions) {
      if (transaction.fromID == accountID) {
        transaction.isArchived = true;
      }
    }

    objectbox.transactionBox.putMany(transactions);

    accounts = objectbox.accountBox.getAll();
    transactions = objectbox.transactionBox.getAll();
    // Hive.box('budgeItApp').put('accounts', accounts);
    // Hive.box('budgeItApp').put('transactions', transactions);
    // print(Hive.box('budgeItApp').get('accounts'));
    notifyListeners();
  }

  void deleteAccount(int accountID) async {
    for(Transaction transaction in transactions) {
      if (transaction.fromID == accountID) {
        objectbox.transactionBox.remove(transaction.transactionID);
      }
    }
    objectbox.accountBox.remove(accountID);

    accounts = objectbox.accountBox.getAll();
    transactions = objectbox.transactionBox.getAll();
    notifyListeners();
  }

  void selectAccountFrom(int accountIndex) async {
    mySettings.selectedAccountFrom = accountIndex;
    objectbox.settingsBox.put(mySettings);
    // Hive.box('budgeItApp').put('selectedAccountFrom', lastSelectedAccountFrom);
    notifyListeners();
  }

  void selectRecipient(int toIndex, TransactionType transactionType) async {
    if(transactionType == TransactionType.transfer) {
      mySettings.selectedAccountTo = toIndex;
    } else {
      mySettings.selectedCategoryTo = toIndex;

    }
    mySettings.selectedTransactionType = transactionType.index;
    objectbox.settingsBox.put(mySettings);

    // Hive.box('budgeItApp').put('lastTransactionType', lastTransactionType);
    // Hive.box('budgeItApp').put('selectedAccountTo', lastSelectedAccountTo);
    // Hive.box('budgeItApp').put('selectedCategoryTo', lastSelectedCategoryTo);
    notifyListeners();
  }

  void deleteTransaction(int transactionID) async {
    Transaction? toRemove = objectbox.transactionBox.get(transactionID);
    if(toRemove == null)
      return;
    if(toRemove.transactionType == TransactionType.expense) {
      Account? updatedAccount = findAccountByID(toRemove.fromID);
      if(updatedAccount == null)
        return;
      updatedAccount.balance += toRemove.value;
      objectbox.accountBox.put(updatedAccount);
    } else if(toRemove.transactionType == TransactionType.income ) {
      Account? updatedAccount = findAccountByID(toRemove.fromID);
      if(updatedAccount == null)
        return;
      updatedAccount.balance -= toRemove.value;
      objectbox.accountBox.put(updatedAccount);
    } else if(toRemove.transactionType == TransactionType.transfer) {

      Account? updatedAccount1 = findAccountByID(toRemove.fromID);
      Account? updatedAccount2 = findAccountByID(toRemove.toID);
      if(updatedAccount1 == null || updatedAccount2 == null)
        return;
      updatedAccount1.balance += toRemove.value;
      updatedAccount2.balance -= toRemove.value;
      objectbox.accountBox.put(updatedAccount1);
      objectbox.accountBox.put(updatedAccount2);
    }

    objectbox.transactionBox.remove(transactionID);

    accounts = objectbox.accountBox.getAll();
    transactions = objectbox.transactionBox.getAll();
    notifyListeners();
  }

  void updateTransaction(Transaction transaction) {
    objectbox.transactionBox.put(transaction);

    transactions = objectbox.transactionBox.getAll();
    notifyListeners();
  }
  

  void addTransaction(Transaction transaction) async {
    objectbox.transactionBox.put(transaction);

    if(transaction.transactionType == TransactionType.expense) {
      Account? updatedAccount = findAccountByID(transaction.fromID);
      if(updatedAccount == null)
        return;
      updatedAccount.balance -= transaction.value;
      objectbox.accountBox.put(updatedAccount);
      //TODO IMPLEMENT TRANSACTION ALERT
      if(transaction.value >= mySettings.spendAlertAmount) {
        // transactionAlert = List.from(transactionAlert)..add(transaction);
      }
    } else if(transaction.transactionType == TransactionType.income ) {
      Account? updatedAccount = findAccountByID(transaction.fromID);
      if(updatedAccount == null)
        return;
      updatedAccount.balance += transaction.value;
      objectbox.accountBox.put(updatedAccount);
    } else if(transaction.transactionType == TransactionType.transfer) {
      Account? updatedAccount1 = findAccountByID(transaction.fromID);
      Account? updatedAccount2 = findAccountByID(transaction.toID);
      if(updatedAccount1 == null || updatedAccount2 == null)
        return;
      updatedAccount1.balance -= transaction.value;
      updatedAccount2.balance += transaction.value;
      objectbox.accountBox.put(updatedAccount1);
      objectbox.accountBox.put(updatedAccount2);
      //TODO CONVERT CURRENCIES WHEN TRANSFERRING BETWEEN TWO ACCOUNTS WITH DIFFERENT CURRENCIES.
    }
    transactions = objectbox.transactionBox.getAll();
    accounts = objectbox.accountBox.getAll();
    // Hive.box('budgeItApp').put('accounts', accounts);
    // Hive.box('budgeItApp').put('transactions', transactions);
    // Hive.box('budgeItApp').put('transactionAlert', transactionAlert);
    // print(Hive.box('budgeItApp').get('transactions'));
    notifyListeners();
  }

  //TODO IMPLEMENT FAVORITES
  void addTransactionToFavorites(Transaction transaction) {
    // favoriteTransactions = List.from(favoriteTransactions)..add(transaction);
    // Hive.box('budgeItApp').put('favoriteTransactions', favoriteTransactions);
    notifyListeners();
  }

  void changePrimaryCurrency(Currency newCurrency) {
    mySettings.primaryCurrencyID = currencyList.indexOf(newCurrency);
    objectbox.settingsBox.put(mySettings);
    notifyListeners();
  }

  void changeSpendAlertAmount(double value) {
    mySettings.spendAlertAmount = value;
    objectbox.settingsBox.put(mySettings);
    notifyListeners();
  }

  //TODO MERGE WITH UPDATE CATEGORY
  void addCategory(Category newCategory) {
    objectbox.categoryBox.put(newCategory);

    categories = objectbox.categoryBox.getAll();
    notifyListeners();
  }

  void updateCategory(Category category) {
    objectbox.categoryBox.put(category);
    categories = objectbox.categoryBox.getAll();
    notifyListeners();
  }
  // void rearrangeCategories(List<Category> updatedCategories) {
  //   updatedCategories.forEach((category) {
  //     categories[this.getCategoryIndexByID(category.categoryID)] = category;
  //   });
  //
  //   // Hive.box('budgeItApp').put('categories', categories);
  //   // print(Hive.box('budgeItApp').get('categories'));
  //   notifyListeners();
  // }

  void init() {
    this.accounts = objectbox.accountBox.getAll();
    this.categories = objectbox.categoryBox.getAll();
    this.transactions = objectbox.transactionBox.getAll();
    this.mySettings = objectbox.settingsBox.getAll()[0];
    // this.transactionAlert = transactionAlert;
    // this.favoriteTransactions = favoriteTransactions;
  }
}