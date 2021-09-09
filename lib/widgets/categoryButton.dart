import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CategoryButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String name;
  final Function onCategoryClick;
  final int categoryID;
  final double value;
  final String currencySymbol;

  const CategoryButton({Key key, this.icon, this.color, this.name, this.onCategoryClick, this.categoryID, this.value, this.currencySymbol}) : super(key: key);

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
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
          RichText(
            text: TextSpan(
                text: "${widget.currencySymbol} ",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500
                ),
                children: [
                  TextSpan(
                      text: "${moneyFormat.format(widget.value).split('.')[0]}",
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500

                      )
                  ),
                  TextSpan(
                      text: ".${moneyFormat.format(widget.value).split('.')[1]}",
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500
                      )
                  )
                ]
            ),
          )
        ],
      ),
    );
  }
}
