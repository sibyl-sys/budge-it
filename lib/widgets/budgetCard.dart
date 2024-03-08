import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class BudgetCard extends StatefulWidget {
  final String name;
  final int id;
  final Color color;
  final IconData icon;
  final double amount;
  final double cap;
  final String currencySymbol;
  final Function onClick;

  const BudgetCard(
      {Key? key,
      required this.name,
      required this.id,
      required this.color,
      required this.icon,
      required this.amount,
      required this.cap,
      required this.currencySymbol,
      required this.onClick})
      : super(key: key);

  @override
  _BudgetCardState createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        surfaceTintColor: Colors.white,
        child: InkWell(
            splashColor: Colors.teal.shade700.withAlpha(50),
            onTap: () {
              widget.onClick();
            },
            child: Container(
                height: 75,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16, 8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.45),
                                  width: 2,
                                ),
                                color: widget.color),
                            child: Icon(widget.icon,
                                color: Colors.white, size: 25),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(widget.name,
                                              style: TextStyle(
                                                color: Color(0xFF4F4F4F),
                                                fontSize: 14,
                                              )),
                                          widget.cap == 0
                                              ? Spacer()
                                              : RichText(
                                                  text: TextSpan(
                                                      text:
                                                          " ${widget.currencySymbol} ",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF4F4F4F),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                "${moneyFormat.format((widget.cap - widget.amount))}",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF4F4F4F),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      ]),
                                                )
                                        ]),
                                    LinearPercentIndicator(
                                        lineHeight: 3.0,
                                        percent: widget.cap == 0
                                            ? 0
                                            : min((widget.amount / widget.cap),
                                                1),
                                        backgroundColor: Colors.grey,
                                        progressColor: widget.color,
                                        padding: EdgeInsets.zero),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                                text:
                                                    " ${widget.currencySymbol} ",
                                                style: TextStyle(
                                                    color: widget.color,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "${moneyFormat.format((widget.amount))}",
                                                      style: TextStyle(
                                                          color: widget.color,
                                                          fontSize: 12,
                                                          fontFamily: "Poppins",
                                                          fontWeight:
                                                              FontWeight.w500)),
                                                ]),
                                          ),
                                          widget.cap == 0
                                              ? Spacer()
                                              : RichText(
                                                  text: TextSpan(
                                                      text:
                                                          "/ ${widget.currencySymbol} ",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFFB6B6B6),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                "${moneyFormat.format((widget.cap))}",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFFB6B6B6),
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    "Poppins",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      ]),
                                                ),
                                        ]),
                                  ]),
                            ),
                          )
                        ])))),
      ),
    );
  }
}
