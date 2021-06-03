import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/widgets/creditLimitText.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AccountCard extends StatefulWidget {

  final String accountName;
  final double balance;
  final double creditLimit;
  final IconData icon;
  final Color color;
  final double progress;
  final String description;
  final int accountIndex;
  final Function(int) onAccountTapped;
  final String currencySymbol;

  AccountCard({Key key, this.accountName, this.balance, this.icon, this.color, this.creditLimit, this.progress, this.description, this.accountIndex, this.onAccountTapped, this.currencySymbol}) : super(key:key);


  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {

  final moneyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor:  Colors.teal[700].withAlpha(50),
        onTap: () {
          widget.onAccountTapped(widget.accountIndex);
        },
        child: Container(
          height: 75,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children : [
                    CircularPercentIndicator(
                        radius: 48,
                        lineWidth: 4.0,
                        percent: widget.creditLimit == 0 ? 0 : widget.progress / 100,
                        progressColor: Colors.lightGreen,
                        backgroundColor: widget.creditLimit == 0 ? Colors.white.withAlpha(0) : Colors.grey[300],
                        center: CircleAvatar(
                          backgroundColor: widget.color,
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 30
                          ),
                        ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            widget.accountName,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                          )
                        ),
                        SizedBox(height: 4),
                        RichText(
                            text: TextSpan(
                                text: "${widget.currencySymbol} ${moneyFormat.format(widget.balance).split('.')[0]}",
                                style: TextStyle(
                                    color: Colors.green[700],
                                    fontSize: 16
                                ),
                                children: [
                                  TextSpan(
                                      text: ".${moneyFormat.format(widget.balance).split('.')[1]}",
                                      style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 14
                                      )
                                  )
                                ]
                            ),
                        ),
                      ]
                    ),
                  ]
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        "${widget.description}",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            fontSize: 12.0,
                            color: Colors.grey[600]
                        )
                    ),
                    SizedBox(height: 4),
                    CreditLimitText(creditLimit: widget.creditLimit, progress: widget.progress,)
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
