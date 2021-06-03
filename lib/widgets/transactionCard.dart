import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/services/transaction.dart';

class TransactionCard extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String categoryName;
  final String description;
  final double value;
  final TransactionType type;

  TransactionCard({Key key, this.icon, this.color, this.description, this.value, this.type, this.categoryName});

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {

  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {
    print(widget.categoryName);
    print(widget.type);
    return Card(
      child: InkWell(
        splashColor:  Colors.teal[700].withAlpha(50),
        onTap: () {},
        child: Container(
          height: 75,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white60,
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 30,
                      )
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            widget.categoryName,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                            )
                        ),
                        SizedBox(height: 4),
                        Text(
                            widget.description,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                            )
                        ),
                      ],
                    )
                  ],
                ),
                RichText(
                  text: TextSpan(
                      text: "₱ ${moneyFormat.format(widget.value).split('.')[0]}",
                      style: TextStyle(
                          color: widget.type == TransactionType.income ? Colors.teal[700] : Colors.red[700],
                          fontSize: 20
                      ),
                      children: [
                        TextSpan(
                            text: ".${moneyFormat.format(widget.value).split('.')[1]}",
                            style: TextStyle(
                                color: widget.type == TransactionType.income ? Colors.teal[700] : Colors.red[700],
                                fontSize: 18
                            )
                        )
                      ]
                  ),
                )
              ],
            )
          ),
        ),
      )
    );
  }
}
