import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalHeader extends StatefulWidget {
  final String currencySymbol;
  final String header;
  final double value;
  final double percentage;

  const TotalHeader({Key key, this.currencySymbol, this.header, this.value, this.percentage}) : super(key: key);

  @override
  _TotalHeaderState createState() => _TotalHeaderState();
}

class _TotalHeaderState extends State<TotalHeader> {
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column (
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Balance",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey[400],
                fontSize: 12
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                      text: "${widget.currencySymbol} ",
                      style: TextStyle(
                          color: Color(0x333333).withOpacity(1),
                          fontSize: 21,
                        fontWeight: FontWeight.w500
                      ),
                      children: [
                        TextSpan(
                            text: "${moneyFormat.format(widget.value)}",
                            style: TextStyle(
                                color: Color(0x333333).withOpacity(1),
                                fontSize: 21,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500
                            )
                        ),
                      ]
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      widget.percentage > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                      color: widget.percentage > 0 ? Color(0x55C9C6).withOpacity(1) : Color(0xEB6467).withOpacity(1),
                      size: 12,
                    ),
                    Text("${widget.percentage}% from last month",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[400],
                          fontSize: 12,
                        )
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
