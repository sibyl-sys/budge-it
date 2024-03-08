import 'package:flutter/material.dart';
import 'package:money_tracker/constants/Constants.dart';

class IconSelection extends StatefulWidget {
  final IconData iconData;
  final Function onIconChange;

  const IconSelection(
      {Key? key, required this.iconData, required this.onIconChange})
      : super(key: key);

  @override
  _IconSelectionState createState() => _IconSelectionState();
}

class _IconSelectionState extends State<IconSelection> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Text("Account Icons"),
            GridView.count(
                padding: EdgeInsets.all(8.0),
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: accountIconList["Accounts"]!
                    .map((item) => OutlinedButton(
                        onPressed: () {
                          widget.onIconChange(item);
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                              width: widget.iconData == item ? 2.0 : 1.0,
                              color: widget.iconData == item
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade400),
                        ),
                        child: Icon(item)))
                    .toList()),
            Text("Categories"),
            GridView.count(
                padding: EdgeInsets.all(8.0),
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: accountIconList["Categories"]!
                    .map((item) => OutlinedButton(
                        onPressed: () {
                          widget.onIconChange(item);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              width: widget.iconData == item ? 2.0 : 1.0,
                              color: widget.iconData == item
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade400),
                          backgroundColor: Colors.white,
                        ),
                        child: Icon(item)))
                    .toList()),
          ],
        ),
      ),
    );
  }
}
