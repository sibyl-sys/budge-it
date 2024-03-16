import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/services/account.dart';
import 'package:money_tracker/services/budget.dart';
import 'package:money_tracker/services/budgetCap.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/settings.dart';
import 'package:money_tracker/services/favoriteTransaction.dart';
import 'package:money_tracker/constants/Constants.dart';
import 'package:money_tracker/main.dart';

import '../objectbox.g.dart';

class User extends ChangeNotifier {
  List<Account> accounts = [];
  List<Category> categories = [];
  // List<Subcategory> subcategories = [];
  List<Transaction> transactions = [];
  // List<Transaction> transactionAlert = [];
  List<FavoriteTransaction> favoriteTransactions = [];
  List<Budget> budgets = [];
  List<BudgetCap> budgetHistory = [];

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
    Query<Category> expenseQuery = objectbox.categoryBox
        .query(Category_.dbCategoryType.equals(0))
        .order(Category_.index)
        .build();
    List<Category> expenseCategories = expenseQuery.find();
    expenseQuery.close();
    return expenseCategories;
  }

  List<Category> get incomeCategories {
    Query<Category> incomeQuery = objectbox.categoryBox
        .query(Category_.dbCategoryType.equals(1))
        .order(Category_.index)
        .build();
    List<Category> incomeCategories = incomeQuery.find();
    incomeQuery.close();
    return incomeCategories;
  }

  List<Account> get stashAccounts {
    Query<Account> stashQuery = objectbox.accountBox
        .query(Account_.dbAccountType
            .equals(0)
            .and(Account_.isArchived.equals(false)))
        .build();
    List<Account> stashAccounts = stashQuery.find();
    stashQuery.close();
    return stashAccounts;
  }

  List<Account> get savingsAccounts {
    Query<Account> savingsQuery = objectbox.accountBox
        .query(Account_.dbAccountType
            .equals(1)
            .and(Account_.isArchived.equals(false)))
        .build();
    List<Account> savingsAccounts = savingsQuery.find();
    savingsQuery.close();
    return savingsAccounts;
  }

  List<Account> get debtAccounts {
    Query<Account> debtQuery = objectbox.accountBox
        .query(Account_.dbAccountType.equals(2) &
            Account_.isArchived.equals(false))
        .build();
    List<Account> debtAccounts = debtQuery.find();
    debtQuery.close();
    return debtAccounts;
  }

  List<Account> get iAmOwedAccounts {
    Query<Account> iAmOwedQuery = objectbox.accountBox
        .query(Account_.dbAccountType.equals(2) &
            Account_.isArchived.equals(false) &
            (Account_.balance.greaterThan(0) | Account_.balance.between(0, 0)))
        .build();
    List<Account> iAmOwedAccounts = iAmOwedQuery.find();
    iAmOwedQuery.close();
    return iAmOwedAccounts;
  }

  List<Account> get iOwedAccounts {
    Query<Account> iOwedQuery = objectbox.accountBox
        .query(Account_.dbAccountType.equals(2) &
            Account_.isArchived.equals(false) &
            Account_.balance.lessThan(0))
        .build();
    List<Account> iOwedAccounts = iOwedQuery.find();
    iOwedQuery.close();
    return iOwedAccounts;
  }

  double get totalSavings {
    double total = 0;
    for (var account in savingsAccounts) {
      if (account.getCurrency() == mySettings.getPrimaryCurrency()) {
        total += account.balance;
      } else {
        total += exchangeCurrency(account.balance, account.getCurrency(),
            mySettings.getPrimaryCurrency());
      }
    }
    return total;
  }

  double totalNetPercentageChange(DateTime from, DateTime to) {
    double previousValue = getHistoricalNetValue(from, to);
    return (previousValue - totalNet) / previousValue * 100;
  }

  double get totalRegular {
    double total = 0;
    for (var account in stashAccounts) {
      if (account.getCurrency() == mySettings.getPrimaryCurrency()) {
        total += account.balance;
      } else {
        total += exchangeCurrency(account.balance, account.getCurrency(),
            mySettings.getPrimaryCurrency());
      }
    }
    return total;
  }

  double totalBalancePercentageChange(DateTime from, DateTime to) {
    double stashHistorical = 0;
    double savingsHistorical = 0;
    for (Account account in stashAccounts) {
      if (account.getCurrency() == mySettings.getPrimaryCurrency()) {
        stashHistorical +=
            getHistoricalAccountValue(from, to, account.accountID);
      } else {
        stashHistorical += exchangeCurrency(
            getHistoricalAccountValue(from, to, account.accountID),
            account.getCurrency(),
            mySettings.getPrimaryCurrency());
      }
    }

    for (Account account in savingsAccounts) {
      if (account.getCurrency() == mySettings.getPrimaryCurrency()) {
        savingsHistorical +=
            getHistoricalAccountValue(from, to, account.accountID);
      } else {
        savingsHistorical += exchangeCurrency(
            getHistoricalAccountValue(from, to, account.accountID),
            account.getCurrency(),
            mySettings.getPrimaryCurrency());
      }
    }

    if (totalRegular + totalSavings + stashHistorical + savingsHistorical ==
        0) {
      return 0;
    } else if (totalRegular + totalSavings > 0 &&
        stashHistorical + savingsHistorical == 0) {
      return 100;
    }

    return (stashHistorical + savingsHistorical) *
        -1 /
        (totalRegular + totalSavings + stashHistorical + savingsHistorical) *
        100;
  }

  double get totalDebts {
    double total = 0;
    for (var account in debtAccounts) {
      if (account.getCurrency() == mySettings.getPrimaryCurrency()) {
        total += account.balance;
      } else {
        total += exchangeCurrency(account.balance, account.getCurrency(),
            mySettings.getPrimaryCurrency());
      }
    }
    return total;
  }

  double totalDebtPercentageChange(DateTime from, DateTime to) {
    double historicalDebt = 0;
    for (Account account in debtAccounts) {
      if (account.getCurrency() == mySettings.getPrimaryCurrency()) {
        historicalDebt +=
            getHistoricalAccountValue(from, to, account.accountID);
      } else {
        historicalDebt += exchangeCurrency(
            getHistoricalAccountValue(from, to, account.accountID),
            account.getCurrency(),
            mySettings.getPrimaryCurrency());
      }
    }

    if (totalDebts + historicalDebt == 0) {
      return 0;
    } else if (totalDebts > 0 && historicalDebt == 0) {
      return 100;
    }

    return (historicalDebt) * -1 / (totalDebts + historicalDebt) * 100;
  }

  double get totalNet {
    double total = 0;
    for (var account in accounts) {
      if (account.isIncludedInTotalNet && !account.isArchived) {
        if (account.getCurrency() == mySettings.getPrimaryCurrency()) {
          total += account.balance;
        } else {
          total += exchangeCurrency(account.balance, account.getCurrency(),
              mySettings.getPrimaryCurrency());
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
    return objectbox.transactionBox.get(transactionID);
  }

  Budget? findBudgetByID(int budgetID) {
    return objectbox.budgetBox.get(budgetID);
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

    if (mySettings.selectedAccountTo == 0 ||
        mySettings.selectedAccountFrom == 0) {
      mySettings.selectedAccountTo = accounts[0].accountID;
      mySettings.selectedAccountFrom = accounts[0].accountID;
    }
    objectbox.settingsBox.put(mySettings);
    notifyListeners();
  }

  double getAccountExpenses(int accountID, int month, int year) {
    double accountExpenses = 0;
    Query<Transaction> monthlyQuery = objectbox.transactionBox
        .query(Transaction_.fromID.equals(accountID).and(Transaction_.timestamp
            .between(DateTime(year, month).millisecondsSinceEpoch,
                DateTime(year, month + 1).millisecondsSinceEpoch - 1)))
        .build();
    List<Transaction> currentMonthTransactions = monthlyQuery.find();
    monthlyQuery.close();
    for (var transaction in currentMonthTransactions) {
      accountExpenses += transaction.value;
    }
    return accountExpenses;
  }

  double getAccountProgress(int accountID) {
    Account? currentAccount = objectbox.accountBox.get(accountID);

    if (currentAccount == null) return 0;

    if (currentAccount.accountType == AccountType.debt) {
      return 0;
    } else if (currentAccount.accountType == AccountType.savings) {
      return currentAccount.creditLimit > 0
          ? max(0, min(currentAccount.balance / currentAccount.creditLimit, 1))
          : 0;
    } else if (currentAccount.accountType == AccountType.wallet) {
      return this.getAccountExpenses(
              accountID, DateTime.now().month, DateTime.now().year) /
          currentAccount.creditLimit *
          100;
    }

    return 0;
  }

  int getTransactionCount(
      {required DateTime from, required DateTime to, required int accountID}) {
    Query<Transaction> transactionCountQuery = objectbox.transactionBox
        .query(Transaction_.fromID
            .equals(accountID)
            .and(Transaction_.timestamp.between(
                from.millisecondsSinceEpoch,
                DateTime(to.year, to.month, to.day + 1).millisecondsSinceEpoch -
                    1))
            .and(Transaction_.isArchived.equals(false)))
        .build();
    List<Transaction> transactionsToCount = transactionCountQuery.find();
    transactionCountQuery.close();

    return transactionsToCount.length;
  }

  double getCategoryNet(
      {required DateTime from, required DateTime to, required int categoryID}) {
    double categoryNet = 0;
    Query<Transaction> categoryTransactionQuery = objectbox.transactionBox
        .query(Transaction_.isArchived
            .equals(false)
            .and(Transaction_.timestamp.between(
                from.millisecondsSinceEpoch,
                DateTime(to.year, to.month, to.day + 1).millisecondsSinceEpoch -
                    1))
            .and(Transaction_.toID.equals(categoryID))
            .and(Transaction_.dbTransactionType
                .notEquals(TransactionType.transfer.index)))
        .build();
    List<Transaction> categoryTransactions = categoryTransactionQuery.find();
    categoryTransactionQuery.close();
    for (Transaction transaction in categoryTransactions) {
      Account transactionAccount = findAccountByID(transaction.fromID)!;
      if (transactionAccount.getCurrency() == mySettings.getPrimaryCurrency()) {
        categoryNet += transaction.value;
      } else {
        categoryNet += exchangeCurrency(transaction.value,
            transactionAccount.getCurrency(), mySettings.getPrimaryCurrency());
      }
    }
    return categoryNet;
  }

  double categoryTypePercentageChange(
      DateTime from, DateTime to, CategoryType categoryType, double current) {
    double previousValue =
        getCategoryTypeNet(from: from, to: to, categoryType: categoryType);
    print(previousValue);

    if (current > 0 && previousValue == 0) {
      return 100;
    } else if (current == 0 && previousValue == 0) {
      return 0;
    }

    return (previousValue - current) / previousValue * 100;
  }

  double getCategoryTypeNet(
      {required DateTime from,
      required DateTime to,
      required CategoryType categoryType}) {
    double categoryNet = 0;
    Query<Transaction> dateRangeQuery = objectbox.transactionBox
        .query(Transaction_.timestamp
            .between(
                from.millisecondsSinceEpoch,
                DateTime(to.year, to.month, to.day + 1).millisecondsSinceEpoch -
                    1)
            .and(Transaction_.isArchived.equals(false)))
        .build();
    List<Transaction> dateRangeTransactions = dateRangeQuery.find();
    dateRangeQuery.close();
    for (Transaction transaction in dateRangeTransactions) {
      if (transaction.transactionType == TransactionType.expense &&
          categoryType == CategoryType.expense) {
        categoryNet -= transaction.value;
      } else if (transaction.transactionType == TransactionType.income &&
          categoryType == CategoryType.income) {
        categoryNet += transaction.value;
      }
    }
    return categoryNet;
  }

  double getImportanceNet(
      {required DateTime from,
      required DateTime to,
      required TransactionImportance transactionImportance}) {
    double importanceNet = 0;

    Query<Transaction> importanceTransactionQuery = objectbox.transactionBox
        .query(Transaction_.isArchived
            .equals(false)
            .and(Transaction_.timestamp.between(
                from.millisecondsSinceEpoch,
                DateTime(to.year, to.month, to.day + 1).millisecondsSinceEpoch -
                    1))
            .and(Transaction_.dbImportance.equals(transactionImportance.index))
            .and(Transaction_.dbTransactionType
                .equals(TransactionType.expense.index)))
        .build();
    List<Transaction> importanceTransactions =
        importanceTransactionQuery.find();
    importanceTransactionQuery.close();
    for (Transaction transaction in importanceTransactions) {
      Account transactionAccount = findAccountByID(transaction.fromID)!;
      if (transactionAccount.getCurrency() == mySettings.getPrimaryCurrency()) {
        importanceNet += transaction.value;
      } else {
        importanceNet += exchangeCurrency(transaction.value,
            transactionAccount.getCurrency(), mySettings.getPrimaryCurrency());
      }
    }
    return importanceNet;
  }

  double getAccountNet(
      {required DateTime from, required DateTime to, required int accountID}) {
    double monthlyNet = 0;
    Query<Transaction> accountTransactionQuery = objectbox.transactionBox
        .query(Transaction_.fromID
            .equals(accountID)
            .and(Transaction_.timestamp.between(
                from.millisecondsSinceEpoch,
                DateTime(to.year, to.month, to.day + 1).millisecondsSinceEpoch -
                    1))
            .and(Transaction_.isArchived.equals(false)))
        .build();
    List<Transaction> accountTransactions = accountTransactionQuery.find();
    accountTransactionQuery.close();
    for (Transaction transaction in accountTransactions) {
      if (transaction.transactionType == TransactionType.expense) {
        monthlyNet -= transaction.value;
      } else if (transaction.transactionType == TransactionType.income) {
        monthlyNet += transaction.value;
      }
    }
    return monthlyNet;
  }

  double getRangeNet({required DateTime from, required DateTime to}) {
    double monthlyNet = 0;
    Query<Transaction> rangeQuery = objectbox.transactionBox
        .query(Transaction_.timestamp
            .between(
                from.millisecondsSinceEpoch,
                DateTime(to.year, to.month, to.day + 1).millisecondsSinceEpoch -
                    1)
            .and(Transaction_.isArchived.equals(false)))
        .build();
    List<Transaction> rangeTransactions = rangeQuery.find();
    rangeQuery.close();
    for (Transaction transaction in rangeTransactions) {
      if (transaction.transactionType == TransactionType.expense) {
        monthlyNet -= transaction.value;
      } else if (transaction.transactionType == TransactionType.income) {
        monthlyNet += transaction.value;
      }
    }
    return monthlyNet;
  }

  double getHistoricalAccountValue(DateTime from, DateTime to, int accountID) {
    double accountTotal = 0;

    Query<Transaction> transactionRangeQuery = objectbox.transactionBox
        .query(Transaction_.timestamp
            .between(from.millisecondsSinceEpoch, to.millisecondsSinceEpoch))
        .build();
    List<Transaction> transactionRange = transactionRangeQuery.find();
    for (Transaction transaction in transactionRange) {
      if (transaction.fromID == accountID) {
        if (transaction.transactionType == TransactionType.income) {
          accountTotal -= transaction.value;
        } else {
          accountTotal += transaction.value;
        }
      } else if (transaction.toID == accountID) {
        accountTotal -= transaction.value;
      }
    }
    return accountTotal;
  }

  double getHistoricalNetValue(DateTime from, DateTime to) {
    double transactionTotal = 0;

    Query<Transaction> transactionRangeQuery = objectbox.transactionBox
        .query(Transaction_.timestamp
            .between(from.millisecondsSinceEpoch, to.millisecondsSinceEpoch))
        .build();
    List<Transaction> transactionRange = transactionRangeQuery.find();
    for (Transaction transaction in transactionRange) {
      if (transaction.transactionType == TransactionType.income) {
        transactionTotal -= transaction.value;
      } else {
        transactionTotal += transaction.value;
      }
    }
    return transactionTotal;
  }

  //TODO TRANSLATE TO QUERY
  List<Map> getTransactionsByDate(
      {required DateTime from, required DateTime to, required int accountID}) {
    List<Map> transactionsByDate = <Map>[];
    for (Transaction transaction in transactions) {
      if (transaction.timestamp.compareTo(from) >= 0 &&
          transaction.timestamp.compareTo(to) <= 0 &&
          (accountID == -1 ||
              transaction.fromID == accountID ||
              (transaction.transactionType == TransactionType.transfer &&
                  transaction.toID == accountID)) &&
          !transaction.isArchived) {
        int objectIndex = transactionsByDate.indexWhere(
            (element) => element["day"] == transaction.timestamp.day);
        if (objectIndex == -1) {
          Map transactionObject = {
            "day": transaction.timestamp.day,
            "weekday": transaction.timestamp.weekday,
            "month": transaction.timestamp.month,
            "year": transaction.timestamp.year,
            "transactions": <Transaction>[],
            "value": 0
          };
          transactionObject["transactions"].add(transaction);
          if (transaction.transactionType == TransactionType.expense) {
            transactionObject["value"] -= transaction.value;
          } else if (transaction.transactionType == TransactionType.income) {
            transactionObject["value"] += transaction.value;
          }
          transactionsByDate.add(transactionObject);
        } else {
          transactionsByDate[objectIndex]["transactions"].add(transaction);
          if (transaction.transactionType == TransactionType.expense) {
            transactionsByDate[objectIndex]["value"] -= transaction.value;
          } else if (transaction.transactionType == TransactionType.income) {
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
    if (toArchive == null) return;
    toArchive.isArchived = true;
    objectbox.accountBox.put(toArchive);

    //TODO CHANGE TO QUERY
    for (Transaction transaction in transactions) {
      if (transaction.fromID == accountID) {
        transaction.isArchived = true;
      }
    }

    objectbox.transactionBox.putMany(transactions);

    accounts = objectbox.accountBox.getAll();
    transactions = objectbox.transactionBox.getAll();
    notifyListeners();
  }

  void deleteAccount(int accountID) async {
    for (Transaction transaction in transactions) {
      if (transaction.fromID == accountID ||
          (transaction.transactionType == TransactionType.transfer &&
              transaction.toID == accountID)) {
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
    notifyListeners();
  }

  void selectRecipient(int toIndex, TransactionType transactionType) async {
    if (transactionType == TransactionType.transfer) {
      mySettings.selectedAccountTo = toIndex;
    } else {
      mySettings.selectedCategoryTo = toIndex;
    }
    mySettings.selectedTransactionType = transactionType.index;
    objectbox.settingsBox.put(mySettings);
    notifyListeners();
  }

  void deleteTransaction(int transactionID) async {
    Transaction? toRemove = objectbox.transactionBox.get(transactionID);
    if (toRemove == null) return;
    if (toRemove.transactionType == TransactionType.expense) {
      Account? updatedAccount = findAccountByID(toRemove.fromID);
      if (updatedAccount == null) return;
      updatedAccount.balance += toRemove.value;
      objectbox.accountBox.put(updatedAccount);
    } else if (toRemove.transactionType == TransactionType.income) {
      Account? updatedAccount = findAccountByID(toRemove.fromID);
      if (updatedAccount == null) return;
      updatedAccount.balance -= toRemove.value;
      objectbox.accountBox.put(updatedAccount);
    } else if (toRemove.transactionType == TransactionType.transfer) {
      Account? updatedAccount1 = findAccountByID(toRemove.fromID);
      Account? updatedAccount2 = findAccountByID(toRemove.toID);
      if (updatedAccount1 == null || updatedAccount2 == null) return;
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

    if (transaction.transactionType == TransactionType.expense) {
      Account? updatedAccount = findAccountByID(transaction.fromID);
      if (updatedAccount == null) return;
      updatedAccount.balance -= transaction.value;
      objectbox.accountBox.put(updatedAccount);
      //TODO IMPLEMENT TRANSACTION ALERT
      if (transaction.value >= mySettings.spendAlertAmount) {
        // transactionAlert = List.from(transactionAlert)..add(transaction);
      }
    } else if (transaction.transactionType == TransactionType.income) {
      Account? updatedAccount = findAccountByID(transaction.fromID);
      if (updatedAccount == null) return;
      updatedAccount.balance += transaction.value;
      objectbox.accountBox.put(updatedAccount);
    } else if (transaction.transactionType == TransactionType.transfer) {
      Account? updatedAccount1 = findAccountByID(transaction.fromID);
      Account? updatedAccount2 = findAccountByID(transaction.toID);
      if (updatedAccount1 == null || updatedAccount2 == null) return;
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
  void addTransactionToFavorites(FavoriteTransaction transaction) {
    objectbox.favoriteTransactionBox.put(transaction);
    favoriteTransactions = objectbox.favoriteTransactionBox.getAll();
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

  void deleteCategory(int categoryID) {
    for (Transaction transaction in transactions) {
      if (transaction.fromID == categoryID &&
          transaction.transactionType != TransactionType.transfer) {
        objectbox.transactionBox.remove(transaction.transactionID);
      }
    }
    objectbox.categoryBox.remove(categoryID);
    categories = objectbox.categoryBox.getAll();
    notifyListeners();
  }

  void updateCategories(List<Category> updatedCategories) {
    objectbox.categoryBox.putMany(updatedCategories);
    categories = objectbox.categoryBox.getAll();
    // categories.forEach((category) => {
    //   print(category.name)
    // });
    notifyListeners();
  }

  void addBudget(Budget newBudget) {
    objectbox.budgetBox.put(newBudget);

    budgets = objectbox.budgetBox.getAll();
    notifyListeners();
  }

  void updateBudget(Budget budget) {
    objectbox.budgetBox.put(budget);
    budgets = objectbox.budgetBox.getAll();
    notifyListeners();
  }

  void addBudgetHistory(List<BudgetCap> history) {
    objectbox.budgetCapBox.putMany(history);
    budgetHistory = objectbox.budgetCapBox.getAll();
    notifyListeners();
  }

  void removeBudgetHistory(BudgetCap cap) {
    objectbox.budgetCapBox.remove(cap.id);
    budgetHistory = objectbox.budgetCapBox.getAll();
    notifyListeners();
  }

  double getMonthlyBudgetCap(DateTime from, DateTime to, int budgetID) {
    Budget? activeBudget = findBudgetByID(budgetID);
    double budgetCap = 0;
    if (activeBudget != null) {
      activeBudget.budgetCap.forEach((element) {
        if ((element.month >= from.month && element.year >= from.year) &&
            (element.month <= to.month && element.year <= to.year))
          budgetCap += element.cap;
      });
    }
    return budgetCap;
  }

  double getBudgetExpenditures(DateTime from, DateTime to, int budgetID) {
    Budget? activeBudget = findBudgetByID(budgetID);
    double budgetExpenditures = 0;
    if (activeBudget != null) {
      activeBudget.toTrack.forEach((element) {
        budgetExpenditures +=
            getCategoryNet(from: from, to: to, categoryID: element.categoryID);
      });
    }
    return budgetExpenditures;
  }

  List<Budget> getActiveBudgets(DateTime from, DateTime to) {
    List<Budget> activeBudgets = [];
    budgets.forEach((element) {
      if (getMonthlyBudgetCap(from, to, element.budgetID) > 0) {
        activeBudgets.add(element);
      }
    });
    return activeBudgets;
  }

  List<Budget> getInactiveBudgets(DateTime from, DateTime to) {
    List<Budget> activeBudgets = [];
    budgets.forEach((element) {
      if (getMonthlyBudgetCap(from, to, element.budgetID) <= 0) {
        activeBudgets.add(element);
      }
    });
    return activeBudgets;
  }

  double getCategoryListExpenditures(
      DateTime from, DateTime to, List<Category> categoryList) {
    double budgetExpenditures = 0;
    categoryList.forEach((element) {
      getCategoryNet(from: from, to: to, categoryID: element.categoryID);
    });
    return budgetExpenditures;
  }

  void init() {
    this.accounts = objectbox.accountBox.getAll();
    this.categories = objectbox.categoryBox.getAll();
    this.transactions = objectbox.transactionBox.getAll();
    this.mySettings = objectbox.settingsBox.getAll()[0];
    this.favoriteTransactions = objectbox.favoriteTransactionBox.getAll();
    this.budgets = objectbox.budgetBox.getAll();
    this.budgetHistory = objectbox.budgetCapBox.getAll();
    // this.transactionAlert = transactionAlert;
    // this.favoriteTransactions = favoriteTransactions;
  }
}
