import 'package:flutter/material.dart';
import 'package:money_tracker/screens/addTransaction.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/categoryButton.dart';
import 'package:provider/provider.dart';

class CategoriesTab extends StatefulWidget {
  final CategoryType categoryType;
  final int month;
  final int year;
  final Function onCategoryClick;
  final bool isRearrange;

  const CategoriesTab({Key key, this.categoryType, this.month, this.year, this.onCategoryClick, this.isRearrange}) : super(key: key);

  @override
  _CategoriesTabState createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {

  List generateCategoryList(User user) {
    List<Widget> categoryList = [];
    if(widget.categoryType == CategoryType.expense) {
      user.expenseCategories.forEach((e) => categoryList.add(
          CategoryButton(
              color: Color(e.color).withOpacity(1),
              icon: IconData(e.icon, fontFamily: 'MaterialIcons'),
              name: e.name,
              categoryID: e.categoryID,
              currencySymbol: e.categoryCurrency == null ? user.primaryCurrency.symbol : e.categoryCurrency,
              value : user.getCategoryNet(month: widget.month, year: widget.year, categoryID: e.categoryID),
              onCategoryClick: widget.onCategoryClick
          )
      ));
    } else {
      user.incomeCategories.forEach((e) => categoryList.add(
          CategoryButton(
              color: Color(e.color).withOpacity(1),
              icon: IconData(e.icon, fontFamily: 'MaterialIcons'),
              name: e.name,
              categoryID: e.categoryID,
              currencySymbol: e.categoryCurrency == null ? user.primaryCurrency.symbol : e.categoryCurrency,
              value : user.getCategoryNet(month: widget.month, year: widget.year, categoryID: e.categoryID),
              onCategoryClick: widget.onCategoryClick
          )
      ));
    }
    if(widget.isRearrange) {
      categoryList.add(
        IconButton(
            icon: Icon(Icons.add_circle_outline),
            iconSize: 50,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed("/addCategory");
              // final result = await Navigator.of(context).push(
              //     PageRouteBuilder(
              //       barrierColor: Colors.black.withOpacity(0.25),
              //       barrierDismissible: true,
              //       opaque: false,
              //       pageBuilder: (_, __, ___) => IconAndColorSelection(accountColor: this.accountColor, accountIcon: this.accountIcon, isDarkIcon: isDarkIcon),
              //     )
              // );
              // if(result != null) {
              //   setState(() {
              //     accountIcon = result["iconData"];
              //     accountColor = result["backgroundColor"];
              //     isDarkIcon = result["isDarkIcon"];
              //   });
              // }
            }
        ),
      );
    }

    return categoryList;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: widget.categoryType == CategoryType.expense ? Colors.red[600].withOpacity(0.2) : Colors.teal[600].withOpacity(0.2),
                      width: 2.0
                  ),
                  borderRadius: BorderRadius.circular(8.0)
                ),
                margin: EdgeInsets.all(8.0),
                child: Container(
                  height: 65,
                  child: Center(
                      child: Text(
                        user.getCategoryTypeNet(month: widget.month, year: widget.year, categoryType: widget.categoryType).toString(),
                      style: TextStyle(
                        color: widget.categoryType == CategoryType.expense ? Colors.red[600]: Colors.teal[600],
                        fontWeight: FontWeight.w400,
                        fontSize: 24
                      ))
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        Expanded(
          child: GridView.count(
            crossAxisCount: 4,
            children: generateCategoryList(user)
          ),
        )
        //TODO CATEGORY PROGRESS BAR
      ],
    );
  }
}
