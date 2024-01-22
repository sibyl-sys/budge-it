import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({Key? key}) : super(key: key);

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

  Widget bottomTitles(double value, TitleMeta meta) {
    //TODO: TEMPORARILY MONTH, DO VARIATIONS DEPENDING ON DATE SET AFTER.
    return SideTitleWidget(child: Text(value.floor().toString(), style: TextStyle(color: Color(0xFFB6B6B6), fontSize: 10)), axisSide: meta.axisSide);
  }

  Widget leftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(child: Text(value.toString(), style: TextStyle(color: Color(0xFFB6B6B6), fontSize: 10)), axisSide: meta.axisSide);
  }

  List<BarChartGroupData> getData() {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
              toY: 60000,
              rodStackItems: [
                BarChartRodStackItem(0, 30000, Colors.red),
                BarChartRodStackItem(30000, 60000, Colors.blue),
              ],
              borderRadius: const BorderRadius.all(Radius.zero),
            //TODO DYNAMIC WIDTH
            width: 10,
          ),
        ]
      ),
      BarChartGroupData(
          x: 1,
          barsSpace: 4,
          barRods: [
            BarChartRodData(
                toY: 60000,
                rodStackItems: [
                  BarChartRodStackItem(0, 30000, Colors.red),
                  BarChartRodStackItem(30000, 60000, Colors.blue),
                ],
              borderRadius: const BorderRadius.all(Radius.zero),
              width: 10,
            ),
          ]
      ),
      BarChartGroupData(
          x: 2,
          barsSpace: 4,
          barRods: [
            BarChartRodData(
                toY: 60000,
                rodStackItems: [
                  BarChartRodStackItem(0, 30000, Colors.red),
                  BarChartRodStackItem(30000, 60000, Colors.blue),
                ],
                borderRadius: const BorderRadius.all(Radius.zero),
              width: 10,
            ),
          ]
      ),
      BarChartGroupData(
          x: 3,
          barsSpace: 4,
          barRods: [
            BarChartRodData(
                toY: 60000,
                rodStackItems: [
                  BarChartRodStackItem(0, 30000, Colors.red),
                  BarChartRodStackItem(30000, 60000, Colors.blue),
                ],
                borderRadius: const BorderRadius.all(Radius.zero),
              width: 10,
            ),
          ]
      )
    ];
  }

  Widget generateCharts() {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceEvenly,
            barTouchData: BarTouchData(
              enabled: false,
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
                      showTitles: true,
                      reservedSize: 62,
                      getTitlesWidget: leftTitles
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
            barGroups: getData(),
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
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
          generateCharts()
        ],
      )
    );
  }
}
