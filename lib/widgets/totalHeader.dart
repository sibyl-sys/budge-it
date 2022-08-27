import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TotalHeader extends StatefulWidget {
  final String currencySymbol;
  final String header;
  final double value;
  final Color valueColor;
  final Widget description;
  final bool isDebt;

  const TotalHeader({Key key, this.currencySymbol, this.header, this.value, this.valueColor, this.description, this.isDebt = false}) : super(key: key);

  @override
  _TotalHeaderState createState() => _TotalHeaderState();
}

class _TotalHeaderState extends State<TotalHeader> {
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");

  String getCurrencyAndSign() {
    if(widget.isDebt) {
      widget.value < 0 ? "${widget.currencySymbol} " : "-${widget.currencySymbol} ";
    } else {
      return widget.value < 0 ? "- ${widget.currencySymbol} " : "${widget.currencySymbol} ";
    }
    return "${widget.currencySymbol}";
  }

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
            Text(widget.header,
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
                      text: getCurrencyAndSign(),
                      style: TextStyle(
                          color: widget.valueColor,
                          fontSize: 21,
                        fontWeight: FontWeight.w500
                      ),
                      children: [
                        TextSpan(
                            text: "${moneyFormat.format(widget.value.abs())}",
                            style: TextStyle(
                                color: widget.valueColor,
                                fontSize: 21,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500
                            )
                        ),
                      ]
                  ),
                ),
                widget.description
              ],
            )
          ],
        ),
      )
    );
  }
}
