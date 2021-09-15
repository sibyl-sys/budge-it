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
    return Ink(
      color: Colors.white,
      child: InkWell(
        splashColor: widget.color.withOpacity(0.5),
        onTap: () { widget.onCategoryClick(widget.categoryID);},
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 4),
              Text(
                  widget.name,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400
                  ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.0),
              Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.45),
                      width: 2,
                    ),
                    color: widget.color
                  ),
                  child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 30
                  ),
              ),
              SizedBox(height: 8.0),
              RichText(
                text: TextSpan(
                    text: "${widget.currencySymbol} ",
                    style: TextStyle(
                      color: Color(0x333333).withOpacity(1),
                      fontSize: 12,
                    ),
                    children: [
                      TextSpan(
                          text: "${moneyFormat.format(widget.value).split('.')[0]}",
                          style: TextStyle(
                            color: Color(0x333333).withOpacity(1),
                            fontSize: 12,
                            fontFamily: "Poppins",

                          )
                      ),
                      TextSpan(
                          text: ".${moneyFormat.format(widget.value).split('.')[1]}",
                          style: TextStyle(
                            color: Color(0x333333).withOpacity(1),
                            fontSize: 12,
                            fontFamily: "Poppins",
                          )
                      )
                    ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
