import 'dart:math';

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
  final bool isDebt;

  AccountCard({Key? key, required this.accountName, required this.balance, required this.icon, required this.color, required this.creditLimit, required this.progress, required this.description, required this.accountIndex, required this.onAccountTapped, required this.currencySymbol, this.isDebt = false}) : super(key:key);


  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {

  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {
    print(widget.progress);
    return Card(
      surfaceTintColor: Colors.white,
      child: InkWell(
        splashColor:  Colors.teal.shade700.withAlpha(50),
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
                        radius: 24,
                        lineWidth: 4.0,
                        percent: widget.creditLimit == 0 ? 0 : max(0, min(widget.progress / 100, 1)),
                        progressColor: Colors.lightGreen,
                        backgroundColor: widget.creditLimit == 0 ? Colors.white.withAlpha(0) : Colors.grey.shade300,
                        center: CircleAvatar(
                          backgroundColor: widget.color,
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 24
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
                            fontSize: 12.0,
                          )
                        ),
                        SizedBox(height: 4),
                        RichText(
                            text: TextSpan(
                                text: widget.balance > 0 || widget.isDebt ? "${widget.currencySymbol} " : "- ${widget.currencySymbol} ",
                                style: TextStyle(
                                    color: widget.balance > 0 ? Color(0x55C9C6).withOpacity(1) :Color(0xEB6467).withOpacity(1) ,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),
                                children: [
                                  TextSpan(
                                    text: "${moneyFormat.format(widget.balance.abs()).split('.')[0]}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: widget.balance > 0 ? Color(0x55C9C6).withOpacity(1) :Color(0xEB6467).withOpacity(1) ,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500
                                    )
                                  ),
                                  TextSpan(
                                      text: ".${moneyFormat.format(widget.balance).split('.')[1]}",
                                      style: TextStyle(
                                          color: widget.balance > 0 ? Color(0x55C9C6).withOpacity(1) :Color(0xEB6467).withOpacity(1) ,
                                          fontSize: 14,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500
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
                            fontSize: 10.0,
                            color: Colors.grey[600]
                        )
                    ),
                    SizedBox(height: 4),
                    CreditLimitText(currencySymbol: widget.currencySymbol, creditLimit: widget.creditLimit, progress: widget.progress)
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
