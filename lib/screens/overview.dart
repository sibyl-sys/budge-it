import 'package:flutter/material.dart';
import 'package:money_tracker/screens/overviewTab.dart';
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

class _OverviewState extends State<Overview> {
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
  DateRangeType rangeType = DateRangeType.MONTHLY;

  List months = [
    "JANUARY",
    "FEBRUARY",
    "MARCH",
    "APRIL",
    "MAY",
    "JUNE",
    "JULY",
    "AUGUST",
    "SEPTEMER",
    "OCTOBER",
    "NOVEMBER",
    "DECEMBER"
  ];

  late DateTime from;
  late DateTime to;

  int month = DateTime.now().month;
  int year = DateTime.now().year;

  @override
  void initState() {
    super.initState();

    var now = new DateTime.now();
    setState(() {
      from = DateTime(now.year, now.month, 1);
      to = DateTime(now.year, now.month + 1, 0);
    });
  }

  changeDate(Map dateMap) {
    setState(() {
      from = dateMap["from"];
      to = dateMap["to"];
      rangeType = dateMap["type"];
    });
  }

  getPercentage(User user, double current) {
    DateTime historicalFrom = DateTime(from.year, from.month - 1, from.day);
    DateTime historicalTo = DateTime(to.year, to.month - 1, to.day);

    if (rangeType == DateRangeType.YEARLY) {
      historicalFrom = DateTime(from.year - 1, from.month, from.day);
      historicalTo = DateTime(to.year - 1, to.month, to.day);
    } else if (rangeType == DateRangeType.DAILY) {
      historicalFrom = DateTime(from.year - 1, from.month, from.day);
      historicalTo = DateTime(to.year - 1, to.month, to.day);
    }

    return user.totalNetPercentageChange(historicalFrom, historicalTo, current);
  }

  getLastText() {
    String historicalText = "last month";

    if (rangeType == DateRangeType.YEARLY) {
      historicalText = "last year";
    } else if (rangeType == DateRangeType.DAILY) {
      historicalText = "yesterday";
    }

    return historicalText;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    double current = user.getRangeNet(from: this.from, to: this.to);

    double percentageChange = getPercentage(user, current);

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
              header: "Total net:",
              valueColor: Color(0xFF4F4F4F),
              currencySymbol: user.mySettings.getPrimaryCurrency().symbol,
              value: current,
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
                        Text("${percentageChange.abs()}% from ${getLastText()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[400],
                              fontSize: 12,
                            )),
                      ],
                    )),
          Expanded(child: OverviewTab(from: this.from, to: this.to)),
        ],
      )),
    );
  }
}
