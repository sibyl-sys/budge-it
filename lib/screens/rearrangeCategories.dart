import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountsType.dart';
import 'package:money_tracker/screens/categoriesTab.dart';
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

  int month = DateTime.now().month;
  int year = DateTime.now().year;

  nextMonth() {
    int nextMonth = month + 1;
    if(nextMonth > 12) {
      setState(() {
        month = 1;
        year += 1;
      });
    } else {
      setState(() {
        month = nextMonth;
      });
    }
  }

  previousMonth() {
    int nextMonth = month - 1;
    if(nextMonth == 0) {
      setState(() {
        month = 12;
        year -= 1;
      });
    } else {
      setState(() {
        month = nextMonth;
      });
    }
  }

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

    return Material(
      child: Container(
          child: Column(
            children: [
              Card(
                  margin: EdgeInsets.zero,
                  child: Container(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(icon: Icon(Icons.chevron_left, color: Theme.of(context).primaryColor), onPressed: previousMonth),
                        Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 8),
                            Text("${months[month-1]} $year",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14
                                )),
                          ],
                        ),
                        IconButton(icon: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor), onPressed: nextMonth)
                      ],
                    ),
                  )
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
                        month: month,
                        year: year,
                        isRearrange: true,
                      ),
                      CategoriesTab(
                        categoryType: CategoryType.income,
                        month: month,
                        year: year,
                        isRearrange: true,
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
