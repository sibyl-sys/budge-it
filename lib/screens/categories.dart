import 'package:flutter/material.dart';
import 'package:money_tracker/screens/addTransaction.dart';
import 'package:money_tracker/screens/categoriesTab.dart';
import 'package:money_tracker/services/category.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/dateRangeBar.dart';
import 'package:money_tracker/widgets/totalHeader.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories>
    with SingleTickerProviderStateMixin {
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
  DateRangeType rangeType = DateRangeType.MONTHLY;

  late DateTime from;
  late DateTime to;

  int month = DateTime.now().month;
  int year = DateTime.now().year;

  late TabController _tabController;

  TabBar get _tabBar => TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
            color: _tabController.index == 0
                ? Colors.red.withOpacity(0.1)
                : Colors.teal.withOpacity(0.1),
            border: Border(
                bottom: BorderSide(
                    width: 2.0,
                    color:
                        _tabController.index == 0 ? Colors.red : Colors.teal))),
        indicatorColor:
            _tabController.index == 0 ? Colors.red[500] : Colors.teal[500],
        labelColor:
            _tabController.index == 0 ? Colors.red[500] : Colors.teal[500],
        unselectedLabelColor:
            _tabController.index == 1 ? Colors.red[500] : Colors.teal[500],
        tabs: [
          Tab(text: 'Expenses'),
          Tab(text: 'Income'),
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
    setState(() {});
  }

  changeDate(Map dateMap) {
    setState(() {
      from = dateMap["from"];
      to = dateMap["to"];
      rangeType = dateMap["type"];
    });
  }

  getCategoryType() {
    if (_tabController.index == 0) {
      return CategoryType.expense;
    } else {
      return CategoryType.income;
    }
  }

  getValueColor() {
    if (_tabController.index == 0) {
      return Color(0xFFEB6467);
    } else {
      return Color(0xFF55C9C6);
    }
  }

  getHeaderText() {
    if (_tabController.index == 0) {
      return "You've spent:";
    } else {
      return "You've earned:";
    }
  }

  getPercentage(User user, double net) {
    DateTime historicalFrom = DateTime(from.year, from.month - 1, from.day);
    DateTime historicalTo = DateTime(to.year, to.month - 1, to.day);

    if (rangeType == DateRangeType.YEARLY) {
      historicalFrom = DateTime(from.year - 1, from.month, from.day);
      historicalTo = DateTime(to.year - 1, to.month, to.day);
    } else if (rangeType == DateRangeType.DAILY) {
      historicalFrom = DateTime(from.year - 1, from.month, from.day);
      historicalTo = DateTime(to.year - 1, to.month, to.day);
    }

    return user.categoryTypePercentageChange(
        historicalFrom, historicalTo, getCategoryType(), net);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    double categoryNet = user
        .getCategoryTypeNet(
            from: this.from, to: this.to, categoryType: getCategoryType())
        .abs();
    double percentageChange = getPercentage(user, categoryNet);

    return Material(
      child: Container(
          child: Column(
        children: [
          DateRangeBar(
            from: this.from,
            to: this.to,
            onChanged: changeDate,
          ),
          TotalHeader(
              header: getHeaderText(),
              valueColor: getValueColor(),
              currencySymbol: user.mySettings.getPrimaryCurrency().symbol,
              value: categoryNet,
              description: rangeType == DateRangeType.IRREGULAR
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          percentageChange >= 0
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: percentageChange >= 0
                              ? Color(0xFF55C9C6)
                              : Color(0xFFEB6467),
                          size: 12,
                        ),
                        Text("${percentageChange}% from last month",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[400],
                              fontSize: 12,
                            )),
                      ],
                    )),
          ColoredBox(color: Colors.white, child: _tabBar),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              CategoriesTab(
                categoryType: CategoryType.expense,
                from: from,
                to: to,
                onCategoryClick: (int categoryID) {
                  final user = context.read<User>();
                  user.selectRecipient(categoryID, TransactionType.expense);
                  Navigator.of(context).push(PageRouteBuilder(
                    barrierColor: Colors.black.withOpacity(0.25),
                    barrierDismissible: true,
                    opaque: false,
                    pageBuilder: (_, __, ___) => AddTransaction(),
                  ));
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
                  Navigator.of(context).push(PageRouteBuilder(
                    barrierColor: Colors.black.withOpacity(0.25),
                    barrierDismissible: true,
                    opaque: false,
                    pageBuilder: (_, __, ___) => AddTransaction(),
                  ));
                },
                isRearrange: false,
              ),
            ]),
          )
        ],
      )),
    );
  }
}
