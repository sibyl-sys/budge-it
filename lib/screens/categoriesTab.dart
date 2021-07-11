import 'dart:math';

import 'package:flutter/material.dart';
import 'package:money_tracker/screens/addTransaction.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/categoryButton.dart';
import 'package:money_tracker/widgets/categoryPercentBar.dart';
import 'package:provider/provider.dart';
import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:drag_and_drop_gridview/drag.dart';

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
            }
        ),
      );
    }

    return categoryList;
  }

  Widget renderStaticGridView(User user) {
    return GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 0,
        childAspectRatio: 9/10,
        children: generateCategoryList(user)
    );
  }
  
  Widget renderDragAndDropView(User user) {
    List categoryList = generateCategoryList(user);
    return DragAndDropGridView(

        onWillAccept: (oldIndex, newIndex) {
          if(oldIndex == categoryList.length) {
            return false;
          }
          return true;
        },
        onReorder: (oldIndex, newIndex) {
          List<Category> categories;
          if(widget.categoryType == CategoryType.expense) {
            categories = user.expenseCategories;
          } else {
            categories = user.incomeCategories;
          }
          if(oldIndex > newIndex) {
            for(int i = newIndex; i < oldIndex; i++) {
              categories[i].index = categories[i].index + 1;
            }
          } else {
            for(int i = newIndex; i > oldIndex; i--) {
              categories[i].index = categories[i].index - 1;
            }
          }
          categories[oldIndex].index = newIndex;
          user.rearrangeCategories(categories);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4
        ),
        itemBuilder: (context, index) => DragItem(isDraggable: true, isDropable: true, child: categoryList[index]),
        itemCount: categoryList.length,
    );
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
        CategoryPercentBar(categoryType: widget.categoryType),
        SizedBox(height: 8.0),
        Expanded(
          child: widget.isRearrange ? renderDragAndDropView(user) : renderStaticGridView(user)
        )
        //TODO CATEGORY PROGRESS BAR
      ],
    );
  }
}
