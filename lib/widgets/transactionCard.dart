import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/screens/transactionDetails.dart';
import 'package:money_tracker/services/transaction.dart';

class TransactionCard extends StatefulWidget {
  //TODO ADD FROM TO
  final IconData icon;
  final Color color;
  final String categoryName;
  final String description;
  final double value;
  final TransactionType type;
  final int transactionID;
  final String currencySymbol;

  TransactionCard({Key key, this.icon, this.color, this.description, this.value, this.type, this.categoryName, this.transactionID, this.currencySymbol});

  @override
  _TransactionCardState createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {

  getIcon() {
    if(widget.type == TransactionType.transfer) {
      return CircleAvatar(
          backgroundColor: widget.color,
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: 24,
          )
      );
    } else {
      return Container(
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
            size: 25
        ),
      );
    }
  }


  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
  @override
  Widget build(BuildContext context) {

    return Card(
      child: InkWell(
        splashColor:  Colors.teal[700].withAlpha(50),
        onTap: () {
          Navigator.of(context).push(
              PageRouteBuilder(
                barrierColor: Colors.black.withOpacity(0.25),
                barrierDismissible: true,
                opaque: false,
                pageBuilder: (_, __, ___) => TransactionDetails(transactionID: widget.transactionID),
              )
          );
        },
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
                    getIcon(),
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
                              color: Color(0x4F4F4F).withOpacity(1)
                            )
                        ),
                        SizedBox(height: 4),
                        Text(
                            widget.description,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              fontStyle: FontStyle.italic,
                              color: Color(0xB6B6B6).withOpacity(1)
                            )
                        ),
                      ],
                    )
                  ],
                ),
                RichText(
                  text: TextSpan(
                      text: "${widget.currencySymbol} ",
                      style: TextStyle(
                          color: widget.type != TransactionType.expense ? Colors.teal[700] : Colors.red[700],
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                      ),
                      children: [
                        TextSpan(
                            text: "${moneyFormat.format(widget.value).split('.')[0]}",
                            style: TextStyle(
                                color: widget.type != TransactionType.expense ? Colors.teal[700] : Colors.red[700],
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500

                            )
                        ),
                        TextSpan(
                            text: ".${moneyFormat.format(widget.value).split('.')[1]}",
                            style: TextStyle(
                                color: widget.type != TransactionType.expense ? Colors.teal[700] : Colors.red[700],
                                fontSize: 14,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500
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
