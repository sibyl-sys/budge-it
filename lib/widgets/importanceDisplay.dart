import 'package:flutter/material.dart';
import 'package:money_tracker/services/transaction.dart';

class ImportanceDisplay extends StatefulWidget {
  final TransactionImportance importance;
  const ImportanceDisplay({super.key, required this.importance});

  @override
  State<ImportanceDisplay> createState() => _ImportanceDisplayState();
}

class _ImportanceDisplayState extends State<ImportanceDisplay> {
  Color color = Color(0xFF5F5C96);
  IconData icon = Icons.favorite;
  String text = "Need";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.importance == TransactionImportance.sudden) {
      color = Color(0xFFEF4545);
      icon = Icons.priority_high;
      text = "Sudden";
    } else if (widget.importance == TransactionImportance.want) {
      color = Color(0xFFFFB800);
      icon = Icons.star;
      text = "Want";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color.withOpacity(0.06),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 12),
            ),
            SizedBox(width: 8),
            Text(text,
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: color, fontSize: 14)),
          ]),
    );
  }
}
