import 'package:objectbox/objectbox.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/budgetCap.dart';
import 'package:money_tracker/constants/Constants.dart';

@Entity()
class Budget {
  @Id()
  int budgetID = 0;

  int icon;

  int color;

  String name;

  int budgetCurrencyID = -1;

  bool willCarryOver = true;

  final toTrack = ToMany<Category>();

  final budgetCap = ToMany<BudgetCap>();


  Budget({required this.icon,required this.color,required this.name, required this.willCarryOver});


  Currency? getCurrency() {
    if(budgetCurrencyID == -1) {
      return null;
    }
    return currencyList[budgetCurrencyID];
  }

}