import 'package:flutter/material.dart';
import 'package:money_tracker/constants/Constants.dart';

class IconSelection extends StatefulWidget {
  final IconData iconData;
  final Function onIconChange;

  const IconSelection({Key key, this.iconData, this.onIconChange}) : super(key: key);

  @override
  _IconSelectionState createState() => _IconSelectionState();
}

class _IconSelectionState extends State<IconSelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
            children: accountIconList["Accounts"].map((item) => OutlineButton(
                onPressed: () {
                  widget.onIconChange(item);
                },
                color: Colors.white,
                borderSide: BorderSide(
                    width:  widget.iconData == item ? 2.0 : 1.0,
                    color: widget.iconData == item ? Theme.of(context).primaryColor : Colors.grey[400]
                ),
                child: Icon(item)
              )
            ).toList()
          ),
          Text("Categories"),
          GridView.count(
              padding: EdgeInsets.all(8.0),
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: accountIconList["Categories"].map((item) => OutlineButton(
                  onPressed: () {
                    widget.onIconChange(item);
                  },
                  borderSide: BorderSide(
                    width:  widget.iconData == item ? 2.0 : 1.0,
                    color: widget.iconData == item ? Theme.of(context).primaryColor : Colors.grey[400]
                  ),
                  color: Colors.white,
                  child: Icon(item)
              )
              ).toList()
          ),
        ],
      ),
    );
  }
}
