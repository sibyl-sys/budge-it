import 'package:money_tracker/services/subcategory.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:objectbox/objectbox.dart';


enum CategoryType {
  expense,
  income
}

@Entity()
class Category {
  @Id()
  int categoryID = 0;

  int icon;

  int color;

  String name;

  @Transient()
  CategoryType? categoryType;

  @Transient()
  TransactionImportance? lastTransactionImportance;

  int categoryCurrencyID = -1;

  int index;

  final subcategories = ToMany<Subcategory>();

  int? get dbCategoryType {
    _ensureStableEnumValues();
    return categoryType?.index;
  }

  set dbCategoryType(int? value) {
    _ensureStableEnumValues();
    if(value == null) {
      categoryType = null;
    } else {
      categoryType = CategoryType.values[value];
    }
  }

  int? get dbLastTransactionImportance {
    _ensureStableEnumValues();
    return lastTransactionImportance?.index;
  }

  set dbLastTransactionImportance(int? value) {
    _ensureStableEnumValues();
    if(value == null) {
      lastTransactionImportance = null;
    } else {
      lastTransactionImportance = TransactionImportance.values[value];
    }
  }



  Category({required this.icon,required this.color,required  this.name, required this.index, this.lastTransactionImportance = TransactionImportance.need, this.categoryType});

  void _ensureStableEnumValues() {
    assert(CategoryType.expense.index == 0);
    assert(CategoryType.income.index == 1);
    assert(TransactionImportance.need.index == 3);
    assert(TransactionImportance.sudden.index == 4);
    assert(TransactionImportance.want.index == 5);
  }

}