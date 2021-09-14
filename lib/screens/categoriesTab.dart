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
  final DateTime from;
  final DateTime to;
  final Function onCategoryClick;
  final bool isRearrange;

  const CategoriesTab({Key key, this.categoryType, this.from, this.to, this.onCategoryClick, this.isRearrange}) : super(key: key);

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
              value : user.getCategoryNet(from: widget.from, to: widget.to, categoryID: e.categoryID),
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
              value : user.getCategoryNet(from: widget.from, to: widget.to, categoryID: e.categoryID),
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
        SizedBox(height: 16.0),
        CategoryPercentBar(from: widget.from, to: widget.to, categoryType: widget.categoryType),
        SizedBox(height: 16.0),
        Expanded(
          child: widget.isRearrange ? renderDragAndDropView(user) : renderStaticGridView(user)
        )
        //TODO CATEGORY PROGRESS BAR
      ],
    );
  }
}
