import 'package:flutter/material.dart';
import 'package:money_tracker/screens/categories.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';


class CategoryPercentBar extends StatefulWidget {
  final CategoryType categoryType;
  final DateTime from;
  final DateTime to;

  const CategoryPercentBar({Key? key, required this.categoryType, required this.from, required this.to}) : super(key: key);

  @override
  _CategoryPercentBarState createState() => _CategoryPercentBarState();
}

class _CategoryPercentBarState extends State<CategoryPercentBar> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    User user = context.watch<User>();
    List<Category> categories = widget.categoryType == CategoryType.expense ? user.expenseCategories : user.incomeCategories;
    double limit = user.getCategoryTypeNet(from: widget.from, to: widget.to, categoryType: widget.categoryType);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 10,
        color: Color(0xB6B6B6).withOpacity(1),
        child: Row(
          children: categories.map((e) => user.getCategoryNet(from: widget.from, to: widget.to, categoryID: e.categoryID) != 0 ? Expanded(
            flex: (user.getCategoryNet(from: widget.from, to: widget.to, categoryID: e.categoryID).abs() / limit.abs() * 100).floor(),
            child: Container(
               margin: EdgeInsets.symmetric(horizontal: 1.0),
               color: Color(e.color).withOpacity(1)
            ),
          ) : SizedBox(width: 0)).toList(),
        ),
      ),
    );
  }
}
