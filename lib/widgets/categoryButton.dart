import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CategoryButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String name;
  final Function onCategoryClick;
  final int categoryID;
  final double value;

  const CategoryButton({Key key, this.icon, this.color, this.name, this.onCategoryClick, this.categoryID, this.value}) : super(key: key);

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () { widget.onCategoryClick(widget.categoryID);},
      child: Column(
        children: [
          Text(
              widget.name,
              style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w400
              ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.0),
          CircleAvatar(
              radius: 22,
              backgroundColor: widget.color,
              child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: 24
              ),
          ),
          SizedBox(height: 8.0),
          Text(
              "P. " + widget.value.toString(),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
              )
          )
        ],
      ),
    );
  }
}
