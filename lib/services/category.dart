import 'package:hive/hive.dart';
import 'package:money_tracker/services/subcategory.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/currency.dart';


part 'category.g.dart';

@HiveType(typeId: 4)
enum CategoryType {
  @HiveField(0)
  expense,
  @HiveField(1)
  income
}

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  int icon;
  
  @HiveField(1)
  int color;
  
  @HiveField(2)
  String name;
  
  @HiveField(3)
  CategoryType categoryType;

  @HiveField(4)
  int categoryID;

  @HiveField(5)
  TransactionImportance lastTransactionImportance;

  @HiveField(6)
  Currency? categoryCurrency;

  @HiveField(7)
  int index;

  @HiveField(8)
  List<Subcategory> subcategories;

  Category({required this.icon,required this.color,required  this.name, required this.categoryType,required  this.categoryID, this.categoryCurrency, required this.index,required this.subcategories, this.lastTransactionImportance = TransactionImportance.need});

}