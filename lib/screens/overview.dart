import 'package:flutter/material.dart';
import 'package:money_tracker/screens/overviewTab.dart';
import 'package:money_tracker/services/category.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/dateRangeBar.dart';
import 'package:money_tracker/widgets/totalHeader.dart';
import 'package:provider/provider.dart';

class Overview extends StatefulWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> with SingleTickerProviderStateMixin {
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
  String _value = 'all';
  //TODO CREATE MONTH WIDGET
  List months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMER", "OCTOBER", "NOVEMBER", "DECEMBER"];

  late DateTime from;
  late DateTime to;

  int month = DateTime.now().month;
  int year = DateTime.now().year;

  late TabController _tabController;

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

  changeDate(Map dateMap) {
    setState(() {
      from = dateMap["from"];
      to = dateMap["to"];
    });
  }

  getCategoryType() {
    if(_tabController.index == 0) {
      return CategoryType.expense;
    } else {
      return CategoryType.income;
    }
  }

  getValueColor() {
    if(_tabController.index == 0) {
      return Color(0xEB6467).withOpacity(1);
    } else {
      return Color(0x55C9C6).withOpacity(1);
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    return Material(
      child: Container(
          child: Column(
            children: [
              DateRangeBar(
                from: this.from,
                to: this.to,
                onChanged: changeDate,
              ),
              TotalHeader(header: "Total net:", valueColor: Color(0xFF4F4F4F), currencySymbol: user.mySettings.getPrimaryCurrency().symbol, value: user.getRangeNet(from: this.from, to: this.to), description:
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_upward,
                    color: Color(0x55C9C6).withOpacity(1),
                    size: 12,
                  ),
                  Text("0% Total Savings",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[400],
                        fontSize: 12,
                      )
                  ),
                ],
              )),
              Expanded(child: OverviewTab(from: this.from, to: this.to)),
            ],
          )
      ),
    );
  }
}
