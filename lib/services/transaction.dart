import 'package:objectbox/objectbox.dart';

enum TransactionType { expense, income, transfer }

enum TransactionImportance { need, want, sudden }

@Entity()
class Transaction {
  @Id()
  int transactionID = 0;

  double value;

  double exchangeRate;

  String note;

  @Property(type: PropertyType.date)
  DateTime timestamp;

  int toID;

  int fromID;

  int subcategoryID;

  @Transient()
  TransactionType? transactionType;

  bool isArchived;

  @Transient()
  TransactionImportance? importance;

  int? get dbTransactionType {
    _ensureStableEnumValues();
    return transactionType?.index;
  }

  set dbTransactionType(int? value) {
    _ensureStableEnumValues();
    if (value == null) {
      transactionType = null;
    } else {
      transactionType = TransactionType.values[value];
    }
  }

  int? get dbImportance {
    _ensureStableEnumValues();
    return importance?.index;
  }

  set dbImportance(int? value) {
    _ensureStableEnumValues();
    if (value == null) {
      importance = null;
    } else {
      importance = TransactionImportance.values[value];
    }
  }

  Transaction(
      {required this.value,
      required this.note,
      required this.timestamp,
      required this.toID,
      required this.fromID,
      required this.isArchived,
      this.subcategoryID = -1,
      this.transactionType,
      this.importance,
      this.exchangeRate = 0});

  void _ensureStableEnumValues() {
    assert(TransactionType.expense.index == 0);
    assert(TransactionType.income.index == 1);
    assert(TransactionType.transfer.index == 2);
    assert(TransactionImportance.need.index == 0);
    assert(TransactionImportance.want.index == 1);
    assert(TransactionImportance.sudden.index == 2);
  }
}
