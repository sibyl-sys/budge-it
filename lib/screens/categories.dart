import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountsType.dart';
import 'package:money_tracker/screens/addTransaction.dart';
import 'package:money_tracker/screens/categoriesTab.dart';
import 'package:money_tracker/services/account.dart';
import 'package:money_tracker/services/category.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/dateRangeBar.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> with SingleTickerProviderStateMixin {

  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
  String _value = 'all';
  //TODO CREATE MONTH WIDGET
  List months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMER", "OCTOBER", "NOVEMBER", "DECEMBER"];

  DateTime from;
  DateTime to;

  int month = DateTime.now().month;
  int year = DateTime.now().year;

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

  changeDate(Map dateMap) {
    setState(() {
      from = dateMap["from"];
      to = dateMap["to"];
    });
  }


  @override
  Widget build(BuildContext context) {

    return Material(
      child: Container(
          child: Column(
            children: [
              DateRangeBar(
                from: this.from,
                to: this.to,
                onChanged: changeDate,
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
                          final user = context.read<User>();
                          user.selectRecipient(categoryID, TransactionType.expense);
                          Navigator.of(context).push(
                              PageRouteBuilder(
                                barrierColor: Colors.black.withOpacity(0.25),
                                barrierDismissible: true,
                                opaque: false,
                                pageBuilder: (_, __, ___) => AddTransaction(),
                              )
                          );
                        },
                        isRearrange: false,
                      ),
                      CategoriesTab(
                        categoryType: CategoryType.income,
                        from: from,
                        to: to,
                        onCategoryClick: (int categoryID) {
                          final user = context.read<User>();
                          user.selectRecipient(categoryID, TransactionType.income);
                          Navigator.of(context).push(
                              PageRouteBuilder(
                                barrierColor: Colors.black.withOpacity(0.25),
                                barrierDismissible: true,
                                opaque: false,
                                pageBuilder: (_, __, ___) => AddTransaction(),
                              )
                          );
                        },
                        isRearrange: false,
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
