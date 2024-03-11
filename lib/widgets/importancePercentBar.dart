import 'package:flutter/material.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';

class ImportancePercentBar extends StatefulWidget {
  final DateTime from;
  final DateTime to;

  const ImportancePercentBar({Key? key, required this.from, required this.to})
      : super(key: key);

  @override
  _ImportancePercentBarState createState() => _ImportancePercentBarState();
}

class _ImportancePercentBarState extends State<ImportancePercentBar> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    User user = context.watch<User>();
    List importanceValues = [];
    double limit = 0;
    TransactionImportance.values.forEach((importance) {
      Color importanceColor = Color(0xFF5F5C96);
      if (importance == TransactionImportance.want)
        importanceColor = Color(0xFFFFB800);
      else if (importance == TransactionImportance.sudden)
        importanceColor = Color(0xFFEF4545);
      double value = user.getImportanceNet(
          from: widget.from, to: widget.to, transactionImportance: importance);
      importanceValues.add({"value": value, "color": importanceColor});
      limit += value;
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 10,
        color: Color(0xB6B6B6).withOpacity(1),
        child: Row(
          children: importanceValues
              .map((e) => e["value"] != 0
                  ? Expanded(
                      flex: (e["value"] / limit.abs() * 100).floor(),
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.0),
                          color: e["color"]),
                    )
                  : SizedBox(width: 0))
              .toList(),
        ),
      ),
    );
  }
}
