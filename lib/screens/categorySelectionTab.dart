import 'package:flutter/material.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/categoryButton.dart';
import 'package:provider/provider.dart';

class CategorySelectionTab extends StatefulWidget {
  final CategoryType categoryType;

  const CategorySelectionTab({Key key, this.categoryType}) : super(key: key);


  @override
  _CategorySelectionTabState createState() => _CategorySelectionTabState();
}

class _CategorySelectionTabState extends State<CategorySelectionTab> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    return Expanded(
      child: GridView.count(
        padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 0.0),
        crossAxisCount: 4,
        mainAxisSpacing: 8.0,
        childAspectRatio: 8/9,
        children: widget.categoryType == CategoryType.expense ? user.expenseCategories.map((e) => CategoryButton(
            color: Color(e.color).withOpacity(1),
            icon: IconData(e.icon, fontFamily: 'MaterialIcons'),
            name: e.name,
            categoryID: e.categoryID,
            value : user.getCategoryNet(month: DateTime.now().month, year: DateTime.now().year, categoryID: e.categoryID),
            currencySymbol: user.primaryCurrency.symbol,
            onCategoryClick: (int categoryID) {
              Navigator.pop(context, {
                "categoryID": categoryID,
              });
            }
        )).toList() : user.incomeCategories.map((e) => CategoryButton(
            color: Color(e.color).withOpacity(1),
            icon: IconData(e.icon, fontFamily: 'MaterialIcons'),
            name: e.name,
            categoryID: e.categoryID,
            value : user.getCategoryNet(month: DateTime.now().month, year: DateTime.now().year, categoryID: e.categoryID),
            currencySymbol: user.primaryCurrency.symbol,
            onCategoryClick: (int categoryID) {
              Navigator.pop(context, {
                "categoryID": categoryID,
              });
            }
        )).toList(),
      ),
    );
  }
}
