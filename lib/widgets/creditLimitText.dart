import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CreditLimitText extends StatefulWidget {

  final double creditLimit;
  final double progress;

  CreditLimitText({Key key, this.creditLimit, this.progress});

  @override
  _CreditLimitTextState createState() => _CreditLimitTextState();
}

class _CreditLimitTextState extends State<CreditLimitText> {

  final moneyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    if(widget.creditLimit > 0) {
      return RichText(
        text: TextSpan(
            text: "₱ ${moneyFormat.format(widget.creditLimit)} (",
            style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14
            ),
            children: [
              TextSpan(
                text: "${widget.progress.toStringAsFixed(2)}%",
                style: TextStyle(
                    color: Colors.lightGreen[600],
                    fontSize: 14
                ),
              ),
              TextSpan(
                text: ")",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14
                ),
              ),
            ]
        ),
      );
    } else {
      return SizedBox(height: 20);
    }
  }
}
