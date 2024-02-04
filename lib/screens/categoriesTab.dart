import 'dart:math';

import 'package:flutter/material.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/categoryButton.dart';
import 'package:money_tracker/widgets/categoryPercentBar.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

class CategoriesTab extends StatefulWidget {
  final CategoryType categoryType;
  final DateTime from;
  final DateTime to;
  final Function onCategoryClick;
  final bool isRearrange;

  const CategoriesTab({Key? key, required this.categoryType, required this.from, required this.to, required this.onCategoryClick, required this.isRearrange}) : super(key: key);

  @override
  _CategoriesTabState createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {

  List<Widget> generateCategoryList(User user) {
    List<Widget> categoryList = [];
    if(widget.categoryType == CategoryType.expense) {
      user.expenseCategories.forEach((e) => categoryList.add(
          CategoryButton(
              key: Key(e.categoryID.toString()),
              color: Color(e.color).withOpacity(1),
              icon: IconData(e.icon, fontFamily: 'MaterialIcons'),
              name: e.name,
              categoryID: e.categoryID,
              currencySymbol: e.getCurrency() == null ? user.mySettings.getPrimaryCurrency().symbol : e.getCurrency()!.symbol,
              value : user.getCategoryNet(from: widget.from, to: widget.to, categoryID: e.categoryID),
              onCategoryClick: widget.onCategoryClick
          )
      ));
    } else {
      user.incomeCategories.forEach((e) => categoryList.add(
          CategoryButton(
              key: Key(e.categoryID.toString()),
              color: Color(e.color).withOpacity(1),
              icon: IconData(e.icon, fontFamily: 'MaterialIcons'),
              name: e.name,
              categoryID: e.categoryID,
              currencySymbol: e.getCurrency() == null ? user.mySettings.getPrimaryCurrency().symbol : e.getCurrency()!.symbol,
              value : user.getCategoryNet(from: widget.from, to: widget.to, categoryID: e.categoryID),
              onCategoryClick: widget.onCategoryClick
          )
      ));
    }
    if(widget.isRearrange) {
      categoryList.add(
        IconButton(
            key: Key("Add"),
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
        padding: EdgeInsets.all(8),
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 6,
        childAspectRatio: 4/5,
        children: generateCategoryList(user)
    );
  }
  
  Widget renderDragAndDropView(User user) {
    List<Widget> categoryList = generateCategoryList(user);
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
        child: ReorderableGridView(
          onReorder: (oldIndex, newIndex) {
            List<Category> categories;
            if (widget.categoryType == CategoryType.expense) {
              categories = user.expenseCategories;
            } else {
              categories = user.incomeCategories;
            }
            if (oldIndex > newIndex) {
              for (int i = newIndex; i < oldIndex; i++) {
                categories[i].index = categories[i].index + 1;
              }
            } else {
              for (int i = newIndex; i > oldIndex; i--) {
                categories[i].index = categories[i].index - 1;
              }
            }
            categories[oldIndex].index = newIndex;
            user.updateCategories(categories);
          },
          children: categoryList,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 6,
            childAspectRatio: 4/5
          )
        )
        // child: ReorderableBuilder(
        //   children: categoryList,
        //   enableDraggable: true,
        //   scrollController: _scrollController,
        //   onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
        //     List<Category> categories;
        //     if(widget.categoryType == CategoryType.expense) {
        //       categories = user.expenseCategories;
        //     } else {
        //       categories = user.incomeCategories;
        //     }
        //     for(final orderUpdateEntity in orderUpdateEntities) {
        //       final category = categories.removeAt(orderUpdateEntity.oldIndex);
        //       categories.insert(orderUpdateEntity.newIndex, category);
        //     }
        //     user.updateCategories(categories);
        //   },
        //   builder: (children) {
        //     return GridView(
        //       children: children,
        //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 4,
        //         mainAxisSpacing: 8,
        //         crossAxisSpacing: 6,
        //         childAspectRatio: 4/5
        //       ));
        //   }
        // )
  //     child: DragAndDropGridView(
  //
  //         onWillAccept: (oldIndex, newIndex) {
  //           if(oldIndex == categoryList.length) {
  //             return false;
  //           }
  //           return true;
  //         },
  //         onReorder: (oldIndex, newIndex) {
  //           List<Category> categories;
  //           if(widget.categoryType == CategoryType.expense) {
  //             categories = user.expenseCategories;
  //           } else {
  //             categories = user.incomeCategories;
  //           }
  //           if(oldIndex > newIndex) {
  //             for(int i = newIndex; i < oldIndex; i++) {
  //               categories[i].index = categories[i].index + 1;
  //             }
  //           } else {
  //             for(int i = newIndex; i > oldIndex; i--) {
  //               categories[i].index = categories[i].index - 1;
  //             }
  //           }
  //           categories[oldIndex].index = newIndex;
  //           user.rearrangeCategories(categories);
  //         },
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 4,
  //           mainAxisSpacing: 8,
  //           crossAxisSpacing: 6,
  //           childAspectRatio: 4/5
  //         ),
  //         itemBuilder: (context, index) => DragItem(isDraggable: true, isDropable: true, child: categoryList[index]),
  //         itemCount: categoryList.length,
  //     ),
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
          // child: renderStaticGridView(user)
        )
      ],
    );
  }
}
