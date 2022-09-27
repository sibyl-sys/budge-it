import 'package:flutter/material.dart';
class OverviewTab extends StatefulWidget {
  const OverviewTab({Key key}) : super(key: key);

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
          )
        ],
      )
    );
  }
}
