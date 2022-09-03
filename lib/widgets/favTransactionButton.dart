import 'package:flutter/material.dart';
import 'package:money_tracker/screens/addTransaction.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';



class FavTransactionButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String categoryName;
  final double value;
  final TransactionType type;
  final int fromID;
  final int toID;
  final String currencySymbol;
  final TransactionImportance importance;


  const FavTransactionButton({Key key, this.icon, this.color, this.categoryName, this.value, this.type, this.fromID, this.toID, this.currencySymbol, this.importance}) : super(key: key);

  @override
  _FavTransactionButtonState createState() => _FavTransactionButtonState();
}

class _FavTransactionButtonState extends State<FavTransactionButton> {
  //TODO CHANGE TO BUTTON
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");
  getIcon() {
    if(widget.type == TransactionType.transfer) {
      return CircleAvatar(
          backgroundColor: widget.color,
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: 18,
          )
      );
    } else {
      return Container(
        width: 30,
        height: 30,
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
            size: 18
        ),
      );
    }
  }

  getImportanceIcon () {
    if(widget.type == TransactionType.expense) {
      if(widget.importance == TransactionImportance.need) {
        return CircleAvatar(
          child: Icon(
            Icons.favorite,
            size: 10.0,
            color: Colors.white,
          ),
          radius: 6.0,
          backgroundColor: Theme.of(context).primaryColor,
        );
      } else if (widget.importance == TransactionImportance.want) {
        return CircleAvatar(
          child: Icon(
            Icons.favorite,
            size: 10.0,
            color: Colors.white,
          ),
          radius: 6.0,
          backgroundColor: Theme.of(context).primaryColor,
        );
      } else if (widget.importance == TransactionImportance.sudden) {
        return CircleAvatar(
          child: Text("*",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12
              )
          ),
          radius: 4.0,
          backgroundColor: Colors.orange[700].withOpacity(0.5),
        );
      }
    } else {
      return SizedBox(width: 0);
    }

  }

  @override
  Widget build(BuildContext context) {
    User user = context.watch<User>();
    return Material(
      type: MaterialType.transparency,
      child: Container(
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              user.selectAccountFrom(widget.fromID);
              user.selectRecipient(widget.toID, widget.type);
              if(user.accounts.length > 0) {
                Navigator.of(context).push(
                    PageRouteBuilder(
                      barrierColor: Colors.black.withOpacity(0.25),
                      barrierDismissible: true,
                      opaque: false,
                      pageBuilder: (_, __, ___) => AddTransaction(initialValue: "${widget.value}"),
                    )
                );

                //TODO UPDATE FAVORITE TRANSACTION BASED ON THE NEW VALUE INPUT
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  getIcon(),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.categoryName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF4F4F4F)
                            )
                          ),
                          SizedBox(width: 4),
                          getImportanceIcon()
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                            text: "${widget.currencySymbol} ",
                            style: TextStyle(
                                color: Color(0xFFB6B6B6),
                                fontSize: 12,
                                fontWeight: FontWeight.w500
                            ),
                            children: [
                              TextSpan(
                                  text: "${moneyFormat.format(widget.value).split('.')[0]}",
                                  style: TextStyle(
                                      color: Color(0xFFB6B6B6),
                                      fontSize: 12,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500

                                  )
                              ),
                              TextSpan(
                                  text: ".${moneyFormat.format(widget.value).split('.')[1]}",
                                  style: TextStyle(
                                      color: Color(0xFFB6B6B6),
                                      fontSize: 11,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500
                                  )
                              )
                            ]
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
