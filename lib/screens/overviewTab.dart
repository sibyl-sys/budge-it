import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

enum DateRangeType {
  DAILY,
  WEEKLY,
  MONTHLY
}

class OverviewTab extends StatefulWidget {
  final DateTime from;
  final DateTime to;

  const OverviewTab({Key? key, required this.from, required this.to}) : super(key: key);

  @override
  _OverviewTabState createState() => _OverviewTabState();

}

List<Widget> overviewTypes = [
  Container(child: Text('Categories')),
  Container(child: Text('Importance')),
  Container(child: Text('Type'))
];

class _OverviewTabState extends State<OverviewTab> with SingleTickerProviderStateMixin {
  final List<bool> _selectedType = [true, false, false];
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
  final monthFormat = new DateFormat('MMM', "en_US");
  final monthlyFormat = new DateFormat('yMMM', "en_US");
  final weekFormat = new DateFormat('E', "en_US");
  final toolTipFormat = new DateFormat('yMMMMd', 'en_US');
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    print(DateTime(widget.from.year, widget.from.month, 32));
  }

  void _handleTabChange() {
    setState(() {
    });
  }

  int monthsBetween(DateTime startDate, DateTime endDate) {
    int years = endDate.year - startDate.year;
    int months = endDate.month - startDate.month;

    // Adjust for negative months in the same year
    if (months < 0) {
      years--;
      months += 12;
    }

    // Consider days in the last month
    if (endDate.day < startDate.day) {
      months--;
    }

    return years * 12 + months;
  }

  int getSelectedType() {
    for(int i = 0; i < _selectedType.length; i++) {
      if(_selectedType[i] == true) {
        return i;
      }
    }

    return 0;
  }

  BarTooltipItem getTooltipItem(group, groupIndex, rod, rodIndex) {
    DateRangeType rangeType = DateRangeType.DAILY;
    int noDays = (widget.to.difference(widget.from).inHours / 24).round();
    if(noDays > 31) {
      rangeType = DateRangeType.MONTHLY;
    } else if(noDays == 6) {
      rangeType = DateRangeType.WEEKLY;
    }
    String text = "";if(rangeType == DateRangeType.MONTHLY) {
      text = monthlyFormat.format(DateTime(widget.from.year, widget.from.month)) + ": " + rod.toY.toString();
    } else {
      text = toolTipFormat.format(DateTime(widget.from.year, widget.from.month, group.x.toInt())) + ": " + rod.toY.toString();
    }
    return BarTooltipItem(
      text,
      TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12
      )
    );
  }

  CategoryType getCategoryType() {
    if(_tabController.index == 0) {
      return CategoryType.expense;
    } else {
      return CategoryType.income;
    }
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    //TODO: TEMPORARILY MONTH, DO VARIATIONS DEPENDING ON DATE SET AFTER.
    String text = "";
    DateRangeType rangeType = DateRangeType.DAILY;
    int noDays = (widget.to.difference(widget.from).inHours / 24).round();
    if(noDays > 31) {
      rangeType = DateRangeType.MONTHLY;
    } else if(noDays == 6) {
      rangeType = DateRangeType.WEEKLY;
    }
    if(rangeType == DateRangeType.DAILY && (value.floor() % 5 == 0 || value.floor() == 1)) {
      text = value.floor().toString();
    } else if(rangeType == DateRangeType.MONTHLY) {
      text = monthFormat.format(DateTime(widget.from.year, widget.from.month, 1).add(Duration(days: 30 * value.floor() - 1)));
    } else if(rangeType == DateRangeType.WEEKLY) {
      text = weekFormat.format(DateTime(widget.from.year, widget.from.month, widget.from.day).add(Duration(days: value.floor())));
      print(DateTime(widget.from.year, widget.from.month, widget.from.day));
      print(value.floor().toString() + " " + text);
    }
    return SideTitleWidget(child: Text(text, style: TextStyle(color: Color(0xFFB6B6B6), fontSize: 10)), axisSide: meta.axisSide);
  }

  Widget leftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(child: Text(value.toString(), style: TextStyle(color: Color(0xFFB6B6B6), fontSize: 10)), axisSide: meta.axisSide);
  }

  List<BarChartGroupData> getData(DateTime from, DateTime to, List<Category> categories, User user) {
    DateRangeType rangeType = DateRangeType.DAILY;
    int noDays = (to.difference(from).inHours / 24).round();
    int noMonths = monthsBetween(from, to);
    if(noDays > 31) {
      rangeType = DateRangeType.MONTHLY;
    } else if(noDays == 6) {
      rangeType = DateRangeType.WEEKLY;
    }

    int barCount = rangeType == DateRangeType.MONTHLY ? noMonths : noDays;
    List<BarChartGroupData> groupData = [];
    for(int i = 0; i <= barCount; i++) {
      //BARCHARTGROUPDATA
      List rodValues = [];
      List<BarChartRodStackItem> rodData = [];
      double total = 0;
      double lastValue = 0;
      if(getSelectedType() == 0) {
        categories.forEach((category) {
          double categoryValue = 0;
          if(rangeType == DateRangeType.MONTHLY) {
            categoryValue = user.getCategoryNet(from: DateTime(from.year, from.month + i, 1), to: DateTime(from.year, from.month + i + 1, 1).subtract(Duration(days: 1)), categoryID: category.categoryID);
          } else {
            categoryValue = user.getCategoryNet(from: DateTime(from.year, from.month, i + from.day), to: DateTime(from.year, from.month, from.day + i), categoryID: category.categoryID);
          }
          total += categoryValue;
          rodValues.add(
            {
              "value" : categoryValue,
              "color" : category.color
            }
          );
          //ROD DATA
        });
      } else if(getSelectedType() == 1) {
        TransactionImportance.values.forEach((importance) {
          double categoryValue = 0;
          if(rangeType == DateRangeType.MONTHLY) {
            categoryValue = user.getImportanceNet(from: DateTime(from.year, from.month + i, 1), to: DateTime(from.year, from.month + i + 1, 1).subtract(Duration(days: 1)), transactionImportance: importance);
          } else {
            categoryValue = user.getImportanceNet(from: DateTime(from.year, from.month, i), to: DateTime(from.year, from.month, i), transactionImportance: importance);
          }
          total += categoryValue;
          int importanceColor = Theme.of(context).primaryColor.value;
          if(importance == TransactionImportance.want)
            importanceColor = Colors.yellow.shade700.value;
          else if(importance == TransactionImportance.sudden)
            importanceColor = Colors.orange.shade700.value;

          rodValues.add(
              {
                "value" : categoryValue,
                "color" : importanceColor
              }
          );
        });
      } else {
        double netValue = 0;
        if(rangeType == DateRangeType.MONTHLY) {
          netValue = user.getRangeNet(from: DateTime(from.year, from.month + i, 1), to: DateTime(from.year, from.month + i + 1, 1).subtract(Duration(days: 1)));
        } else {
          netValue = user.getRangeNet(from: DateTime(from.year, from.month, i), to: DateTime(from.year, from.month, i));
        }

        total = netValue;
        rodValues.add(
            {
              "value": netValue,
              "color": netValue < 0 ? Colors.red.shade500.value : Colors.teal.shade500.value
            }
        );
      }
      rodValues.sort((a, b) => b["value"].compareTo(a["value"]));
      rodValues.forEach((e) {
        if(e["value"] != 0) {
          print(e["value"]);
          rodData.add(BarChartRodStackItem(lastValue, lastValue + e["value"], Color(e["color"]).withOpacity(1)));
          lastValue += e["value"];
        }
      });
        groupData.add(
          BarChartGroupData(
            x: rangeType == DateRangeType.MONTHLY ? from.month + i : rangeType == DateRangeType.WEEKLY ? i : from.add(Duration(days: i)).day,
            barsSpace: 2,
            barRods: [
              BarChartRodData(
                toY: total,
                rodStackItems: rodData,
                borderRadius: const BorderRadius.all(Radius.zero),
              )
            ]
          )
        );

    }
    return groupData;
  }

  Widget generateCharts(List<Category> categories, User user) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: getTooltipItem,
                tooltipMargin: 1.0,
                maxContentWidth: 300
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: bottomTitles
                )
              ),
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: false,
                      reservedSize: 62,
                      getTitlesWidget: leftTitles,

                  )
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false
                )
              ),
              rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: false
                  )
              )
            ),
            gridData: FlGridData(
              show:  true,
              checkToShowHorizontalLine: (value) => value % 10 == 0,
              getDrawingHorizontalLine: (value) => FlLine(
                color: Color(0xFFe7e8ec),
                strokeWidth: 1,
              ),
              drawVerticalLine: false,
            ),
            borderData: FlBorderData(
                show: false
            ),
            groupsSpace: 4,
            barGroups: getData(widget.from, widget.to, categories, user),
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    List<Category> categories = [];

    if(getCategoryType() == CategoryType.expense) {
      categories = user.expenseCategories;
    } else {
      categories = user.incomeCategories;
    }

    return Container(
      child: Column(
        children: [
          SizedBox(height: 16.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Color(0x1FB6B6B6),
            ),
            child: ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for(int i = 0; i < _selectedType.length; i++) {
                    _selectedType[i] = i == index;
                  }
                });
              },
              renderBorder: false,
              selectedColor: Color(0xFF333333),
              fillColor: Colors.white,
              color: Color(0xFFB6B6B6),
              constraints: BoxConstraints(minHeight: 35, minWidth: 110, maxWidth: 120),
              isSelected: _selectedType,
              children: overviewTypes,
            ),
          ),
          generateCharts(categories, user),
          ColoredBox(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                    color : _tabController.index == 0 ? Colors.red.withOpacity(0.1) : Colors
                        .teal.withOpacity(0.1),
                    border: Border(
                        bottom: BorderSide(width: 2.0, color:  _tabController.index == 0 ? Colors.red: Colors
                            .teal)
                    )
                ),
                indicatorColor: _tabController.index == 0 ? Colors.red : Colors
                    .teal,
                labelColor: _tabController.index == 0 ? Colors.red : Colors
                    .teal,
                unselectedLabelColor: _tabController.index == 1 ? Colors.red : Colors
                    .teal,
                tabs: [
                  Tab(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Expenses', style: TextStyle(fontSize: 9, color: Color(0xFF333333))),
                        RichText(
                          text: TextSpan(
                              text: "${user.mySettings.getPrimaryCurrency().symbol} ",
                              style: TextStyle(
                                  color: Color(0xffEB6467),
                                  fontSize: 14,
                                  fontWeight: _tabController.index == 0 ? FontWeight.w500 : FontWeight.w400
                              ),
                              children: [
                                TextSpan(
                                    text: "${moneyFormat.format(user.getCategoryTypeNet(from: widget.from, to: widget.to, categoryType: CategoryType.expense).abs()).split('.')[0]}",
                                    style: TextStyle(
                                        color: Color(0xffEB6467),
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                        fontWeight: _tabController.index == 0 ? FontWeight.w500 : FontWeight.w400
                                    )
                                ),
                                TextSpan(
                                    text: ".${moneyFormat.format(user.getCategoryTypeNet(from: widget.from, to: widget.to, categoryType: CategoryType.expense).abs()).split('.')[1]}",
                                    style: TextStyle(
                                        color: Color(0xffEB6467),
                                        fontSize: 12,
                                        fontFamily: "Poppins",
                                        fontWeight: _tabController.index == 0 ? FontWeight.w500 : FontWeight.w400
                                    )
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Income', style: TextStyle(fontSize: 9, color: Color(0xFF333333))),
                        RichText(
                          text: TextSpan(
                              text: "${user.mySettings.getPrimaryCurrency().symbol} ",
                              style: TextStyle(
                                  color: Color(0xff55C9C6),
                                  fontSize: 14,
                                  fontWeight: _tabController.index == 1 ? FontWeight.w500 : FontWeight.w400
                              ),
                              children: [
                                TextSpan(
                                    text: "${moneyFormat.format(user.getCategoryTypeNet(from: widget.from, to: widget.to, categoryType: CategoryType.income).abs()).split('.')[0]}",
                                    style: TextStyle(
                                        color: Color(0xff55C9C6),
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                        fontWeight: _tabController.index == 1 ? FontWeight.w500 : FontWeight.w400
                                    )
                                ),
                                TextSpan(
                                    text: ".${moneyFormat.format(user.getCategoryTypeNet(from: widget.from, to: widget.to, categoryType: CategoryType.income).abs()).split('.')[1]}",
                                    style: TextStyle(
                                        color: Color(0xff55C9C6),
                                        fontSize: 12,
                                        fontFamily: "Poppins",
                                        fontWeight: _tabController.index == 1 ? FontWeight.w500 : FontWeight.w400
                                    )
                                )
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ),
        ],
      )
    );
  }
}
