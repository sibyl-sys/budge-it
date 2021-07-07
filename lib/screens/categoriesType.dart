import 'package:flutter/material.dart';
import 'package:money_tracker/services/category.dart';

class CategoriesType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text('Select Category Type'),
        backgroundColor: const Color(0xFFF2F2F2),
        children : [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, CategoryType.expense);
            },
            child: Container(
              color: Colors.white,
              width: 280.0,
              height: 70.0,
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Expense",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red[700]
                    )
                  )
                ],
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, CategoryType.income);
            },
            child: Container(
              color: Colors.white,
              width: 280.0,
              height: 70.0,
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      "Income",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[700]
                      )
                  )
                ],
              ),
            ),
          ),
        ]
    );
  }
}
