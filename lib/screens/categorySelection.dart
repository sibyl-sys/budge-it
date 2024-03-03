import 'package:flutter/material.dart';
import 'package:money_tracker/screens/categoriesTab.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/transaction.dart';

class CategorySelection extends StatefulWidget {
  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  late DateTime from;
  late DateTime to;

  int month = DateTime.now().month;
  int year = DateTime.now().year;

  @override
  void initState() {
    super.initState();

    var now = new DateTime.now();
    setState(() {
      from = DateTime(now.year, now.month, 1);
      to = DateTime(now.year, now.month + 1, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Center(
            child: Container(
          width: 350,
          height: 500,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            children: [
              Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                              width: 2.0))),
                  child: Center(
                      child: Text("Select Recipient",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          )))),
              Expanded(
                child: CategoriesTab(
                  categoryType: CategoryType.expense,
                  from: from,
                  to: to,
                  onCategoryClick: (int categoryID) {
                    Navigator.pop(context, {
                      "recipientID": categoryID,
                      "transactionType": TransactionType.expense
                    });
                  },
                  isRearrange: false,
                ),
              )
            ],
          ),
        )));
  }
}
