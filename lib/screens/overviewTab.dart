import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';

class OverviewTab extends StatefulWidget {
  final DateTime from;
  final DateTime to;
  final CategoryType categoryType;

  const OverviewTab({Key? key, required this.from, required this.to, required this.categoryType}) : super(key: key);

  @override
  _OverviewTabState createState() => _OverviewTabState();

}

List<Widget> overviewTypes = [
  Container(child: Text('Categories')),
  Container(child: Text('Importance')),
  Container(child: Text('Type'))
];

class _OverviewTabState extends State<OverviewTab> {
  final List<bool> _selectedType = [true, false, false];

  int getSelectedType() {
    for(int i = 0; i < _selectedType.length; i++) {
      if(_selectedType[i] == true) {
        return i;
      }
    }

    return 0;
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    //TODO: TEMPORARILY MONTH, DO VARIATIONS DEPENDING ON DATE SET AFTER.
    String text = "";
    if(value.floor() % 5 == 0 || value.floor() == 1) {
      text = value.floor().toString();
    }
    return SideTitleWidget(child: Text(text, style: TextStyle(color: Color(0xFFB6B6B6), fontSize: 10)), axisSide: meta.axisSide);
  }

  Widget leftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(child: Text(value.toString(), style: TextStyle(color: Color(0xFFB6B6B6), fontSize: 10)), axisSide: meta.axisSide);
  }

  List<BarChartGroupData> getData(DateTime from, DateTime to, List<Category> categories, User user) {
    //TODO: HANDLE DIFFERENT VARIATIONS FOR WEEKLY/YEARLY AND IMPORTANCE/TYPE
    int noDays = (to.difference(from).inHours / 24).round();
    List<BarChartGroupData> groupData = [];

    for(int i = from.day; i <= noDays; i++) {
      //BARCHARTGROUPDATA
      List rodValues = [];
      List<BarChartRodStackItem> rodData = [];
      double total = 0;
      double lastValue = 0;
      if(getSelectedType() == 0) {
        categories.forEach((category) {
          double categoryValue = user.getCategoryNet(from: DateTime(from.year, from.month, i), to: DateTime(from.year, from.month, i + 1).subtract(Duration(seconds: 1)), categoryID: category.categoryID);
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
          double categoryValue = user.getImportanceNet(from: DateTime(from.year, from.month, i), to: DateTime(from.year, from.month, i + 1).subtract(Duration(seconds: 1)), transactionImportance: importance);
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
        double netValue = user.getRangeNet(from: DateTime(from.year, from.month, i), to: DateTime(from.year, from.month, i + 1).subtract(Duration(seconds: 1)));
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
            x: i,
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

    if(widget.categoryType == CategoryType.expense) {
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
          generateCharts(categories, user)
        ],
      )
    );
  }
}
