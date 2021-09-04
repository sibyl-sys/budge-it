import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountsType.dart';
import 'package:money_tracker/screens/categoriesTab.dart';
import 'package:money_tracker/screens/editAccount.dart';
import 'package:money_tracker/screens/editCategory.dart';
import 'package:money_tracker/services/account.dart';
import 'package:money_tracker/services/category.dart';
import 'package:intl/intl.dart';

class RearrangeCategories extends StatefulWidget {
  @override
  _RearrangeCategoriesState createState() => _RearrangeCategoriesState();
}

class _RearrangeCategoriesState extends State<RearrangeCategories> with SingleTickerProviderStateMixin {

  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
  String _value = 'all';
  //TODO CREATE MONTH WIDGET
  List months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMER", "OCTOBER", "NOVEMBER", "DECEMBER"];

  DateTime from;
  DateTime to;


  TabController _tabController;

  TabBar get _tabBar =>
      TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
            color : _tabController.index == 0 ? Colors.red[500].withOpacity(0.1) : Colors
                .teal[500].withOpacity(0.1),
            border: Border(
                bottom: BorderSide(width: 2.0, color:  _tabController.index == 0 ? Colors.red[500]: Colors
                    .teal[500])
            )
        ),
        indicatorColor: _tabController.index == 0 ? Colors.red[500] : Colors
            .teal[500],
        labelColor: _tabController.index == 0 ? Colors.red[500] : Colors
            .teal[500],
        unselectedLabelColor: _tabController.index == 1 ? Colors.red[500] : Colors
            .teal[500],
        tabs: [
          Tab(
              text: 'Expenses'
          ),
          Tab(
              text: 'Income'
          ),
        ],
      );

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    var now = new DateTime.now();
    setState(() {
      from = DateTime(now.year, now.month, 1);
      to = DateTime(now.year, now.month + 1, 0);
    });
  }

  void _handleTabChange() {
    setState(() {
    });
  }

  Future<void> _selectAccountType(BuildContext context) async {
    switch (await showDialog<AccountType>(
        context: context,
        builder: (BuildContext context) {
          return AccountsType();
        })) {
      case AccountType.wallet:
        Navigator.pushNamed(context, "/newAccount");
        break;
      case AccountType.savings:
        break;
      case AccountType.debt:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text("Edit Categories")
      ),
      body: Container(
          child: Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.5), width: 2.5)
                  )
                ),
                child: TextButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed("/addCategory");
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          size: 20,
                          color: Theme.of(context).primaryColor
                        ),
                        Text(
                          "ADD NEW CATEGORY",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16
                          )
                        ),
                      ],
                    )
                ),
              ),
              ColoredBox(
                  color: Colors.white,
                  child: _tabBar
              ),
              Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: [
                      CategoriesTab(
                        categoryType: CategoryType.expense,
                        from: from,
                        to: to,
                        onCategoryClick: (int categoryID) {
                          Navigator.of(context).push(
                              PageRouteBuilder(
                                barrierColor: Colors.black.withOpacity(0.25),
                                barrierDismissible: true,
                                opaque: false,
                                pageBuilder: (_, __, ___) => EditCategory(categoryID: categoryID),
                              )
                          );
                        },
                        isRearrange: true,
                      ),
                      CategoriesTab(
                        categoryType: CategoryType.income,
                        from: from,
                        to: to,
                        isRearrange: true,
                        onCategoryClick: (int categoryID) {
                          Navigator.of(context).push(
                              PageRouteBuilder(
                                barrierColor: Colors.black.withOpacity(0.25),
                                barrierDismissible: true,
                                opaque: false,
                                pageBuilder: (_, __, ___) => EditCategory(categoryID: categoryID),
                              )
                          );
                        },
                      ),
                    ]
                ),
              )
            ],
          )
      ),
    );
  }
}
