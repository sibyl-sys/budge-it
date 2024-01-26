import 'package:objectbox/objectbox.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/constants/Constants.dart';

@Entity()
class Settings {
  @Id()
  int id;

  int primaryCurrencyID;

  double spendAlertAmount;

  int selectedCategoryTo;

  int selectedAccountFrom;

  int selectedAccountTo;

  int selectedTransactionType;

  Settings({required this.id, required this.primaryCurrencyID, required this.spendAlertAmount, required this.selectedCategoryTo, required this.selectedAccountTo, required this.selectedAccountFrom, required this.selectedTransactionType});

  Currency getPrimaryCurrency() {
    return currencyList[primaryCurrencyID];
  }

  TransactionType getSelectedTransactionType() {
    return TransactionType.values[selectedTransactionType];
  }

}