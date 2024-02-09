import 'package:flutter/material.dart';
import 'package:money_tracker/constants/Constants.dart';

class ColorSelection extends StatefulWidget {
  final Color colorData;
  final Function onColorChange;
  final bool isDarkIcon;

  const ColorSelection({Key? key, required this.colorData, required this.onColorChange, required this.isDarkIcon}) : super(key: key);

  @override
  _ColorSelectionState createState() => _ColorSelectionState();
}

class _ColorSelectionState extends State<ColorSelection> {

  late String colorName;
  late int colorShade;

  void getColorData() {
    for(var map in accountColorList) {
      if(map["value"] == widget.colorData) {
        setState(() {
          colorName = map["name"];
          colorShade = map["shade"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getColorData();
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Selected Color:"
                ),
                Text(
                  colorName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: widget.colorData
                  )
                )
              ],
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                padding: EdgeInsets.all(8.0),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: accountColorList.map((color) => TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(4.0)),
                        backgroundColor: MaterialStateProperty.all(color["value"]),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))
                    ),
                    onPressed: () {
                      widget.onColorChange(color["value"], color["isDarkIcon"]);
                    },
                    child: widget.colorData == color["value"] ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 3,
                              color: Colors.white
                          )
                      ),
                    ) : SizedBox(width: 0)
                )
                ).toList(),
              ),
            )
          ],
        )
    );
  }
}
