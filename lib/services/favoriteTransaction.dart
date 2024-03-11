import 'package:objectbox/objectbox.dart';
import './transaction.dart';

@Entity()
class FavoriteTransaction {
  @Id()
  int favoriteID = 0;

  int toID;

  int fromID;

  double value;

  String description;

  @Transient()
  TransactionType? transactionType;

  bool isArchived;

  @Transient()
  TransactionImportance? importance;

  int? get dbTransactionType {
    return transactionType?.index;
  }

  set dbTransactionType(int? value) {
    if (value == null) {
      transactionType = null;
    } else {
      transactionType = TransactionType.values[value];
    }
  }

  int? get dbImportance {
    return importance?.index;
  }

  set dbImportance(int? value) {
    if (value == null) {
      importance = null;
    } else {
      importance = TransactionImportance.values[value];
    }
  }

  FavoriteTransaction(
      {required this.toID,
      required this.fromID,
      required this.isArchived,
      this.transactionType,
      this.importance,
      required this.value,
      required this.description});
}
