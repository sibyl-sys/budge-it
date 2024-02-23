import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:money_tracker/constants/Constants.dart';
import '../objectbox.g.dart'; // created by `flutter pub run build_runner build`
import './account.dart';
import './settings.dart';
import './category.dart';
import './transaction.dart';
import './budget.dart';
import './budgetCap.dart';
import './subcategory.dart';
import './favoriteTransaction.dart';


class ObjectBox {
  late final Store store;
  late final Box<Account> accountBox;
  late final Box<Settings> settingsBox;
  late final Box<Category> categoryBox;
  late final Box<Subcategory> subCategoryBox;
  late final Box<Transaction> transactionBox;
  late final Box<FavoriteTransaction> favoriteTransactionBox;
  late final Box<Budget> budgetBox;
  late final Box<BudgetCap> budgetCapBox;

  ObjectBox._create(this.store) {
    accountBox = store.box<Account>();
    settingsBox = store.box<Settings>();
    categoryBox = store.box<Category>();
    transactionBox = store.box<Transaction>();
    subCategoryBox = store.box<Subcategory>();
    favoriteTransactionBox = store.box<FavoriteTransaction>();
    budgetBox = store.box<Budget>();
    budgetCapBox = store.box<BudgetCap>();

    if(categoryBox.isEmpty()) {
      categoryBox.putMany(categoryDefault);
    }

    settingsBox.removeAll();
    if(settingsBox.isEmpty()) {
      Category firstCategory = categoryBox.getAll()[0];
      Settings newSettings = new Settings(id: 0, primaryCurrencyID: 0, spendAlertAmount: 5000.00, selectedAccountFrom: 0, selectedAccountTo: 0, selectedCategoryTo: firstCategory.categoryID, selectedTransactionType: 0);
      settingsBox.put(newSettings);
    }
    // Add any additional setup code, e.g. build queries.
    // var box = await Hive.openBox('budgeItApp');
    // List<Account> accounts = List<Account>.from(box.get('accounts', defaultValue:  []));
    // List<Transaction> transactionAlert = List<Transaction>.from(box.get('transactionAlert', defaultValue: []));
    // List<Transaction> favoriteTransactions = List<Transaction>.from(box.get('favoriteTransactions', defaultValue: []));
    // Currency primaryCurrency = box.get('primaryCurrency', defaultValue: currencyList[0]);
    // double spendAlertAmount = box.get('spendAlertAmount', defaultValue: 5000.00);
    // for(Account account in accounts) {
    //   if(account.currency == null) {
    //     account.currency = primaryCurrency;
    //   }
    //
    //   if(account.isArchived == null) {
    //     account.isArchived = false;
    //   }
    // }

    // List<Category> categories = List<Category>.from(box.get('categories', defaultValue: categoryDefault));
    // int lastIndex = 0;
    // for(Category category in categories) {
    //   if(category.index == null) {
    //     category.index = lastIndex + 1;
    //   }
    //   lastIndex = category.index;
    // }

    // List<Transaction> transactions = List<Transaction>.from(box.get('transactions', defaultValue: <Transaction>[]));
    //
    // for(Transaction transaction in transactions) {
    //   if(transaction.isArchived == null) {
    //     transaction.isArchived = false;
    //   }
    //
    //   if(transaction.importance == null) {
    //     transaction.importance = TransactionImportance.need;
    //   }
    // }

    // int selectedCategory = box.get('selectedCategoryTo', defaultValue: 0);
    // int selectedAccount = box.get('selectedAccountFrom', defaultValue: 0);
    // int selectedAccountTo = box.get('selectedAccountTo', defaultValue: 0);
    // TransactionType transactionType = box.get('lastTransactionType', defaultValue: TransactionType.expense);
    // User user = context.read<User>();
    // user.init(accounts, categories, transactions, selectedCategory, selectedAccount, primaryCurrency, selectedAccountTo, transactionType, spendAlertAmount, transactionAlert, favoriteTransactions);
    //
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "budgeit"));
    return ObjectBox._create(store);
  }
}