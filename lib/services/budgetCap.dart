import 'package:money_tracker/services/budget.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class BudgetCap {
  @Id()
  int id = 0;

  int month;

  int year;

  double cap;

  BudgetCap({required this.month, required this.year, required this.cap});
}
