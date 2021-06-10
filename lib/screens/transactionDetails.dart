import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountSelection.dart';
import 'package:money_tracker/screens/categorySelection.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';

class TransactionDetails extends StatefulWidget {

  final int transactionID;

  const TransactionDetails({Key key, this.transactionID}) : super(key: key);

  @override
  _TransactionDetailsState createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {

  int from;
  int to;
  String currencySymbol;
  double value;
  TransactionType transactionType;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = context.read<User>();
    Transaction transaction = user.findTransactionByID(widget.transactionID);
    setState(() {
      from = transaction.accountID;
      to = transaction.categoryID;
      currencySymbol = user.findAccountByID(transaction.accountID).currency.symbol;
      value = transaction.value;
      transactionType = transaction.transactionType;
    });



  }


  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    return Material(
      type: MaterialType.transparency,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(15.0)
                ),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                    "Transaction Details",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontSize: 14
                    )
                ),
              ),
            ),
            Row(
                children: [
                  Expanded(
                    child: Ink(
                      color: Color(user.findAccountByID(from).color).withOpacity(1),
                      child: InkWell(
                        splashColor: Colors.white.withOpacity(0.5),
                        onTap: () async {
                          final result = await Navigator.of(context).push(
                              PageRouteBuilder(
                                barrierColor: Colors.black.withOpacity(0.25),
                                barrierDismissible: true,
                                opaque: false,
                                pageBuilder: (_, __, ___) => AccountSelection(),
                              ));
                          if(result != null) {
                            //TODO UPDATE TRANSACTION
                            //user.selectAccount(result["accountID"]);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          height: 75,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "From Account",
                                  style: TextStyle(
                                      color: Colors.white
                                  )
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                  children: [
                                    Icon(
                                        IconData(user.findAccountByID(from).icon, fontFamily: 'MaterialIcons'),
                                        color: Colors.white,
                                        size: 32
                                    ),
                                    SizedBox(width: 8.0),
                                    Flexible(
                                      child: Text(
                                        user.findAccountByID(from).name,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ]
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Ink(
                      color: Color(user.findCategoryByID(to).color).withOpacity(1),
                      child: InkWell(
                        onTap: () async {
                          final results = await Navigator.of(context).push(
                              PageRouteBuilder(
                                barrierColor: Colors.black.withOpacity(0.25),
                                barrierDismissible: true,
                                opaque: false,
                                pageBuilder: (_, __, ___) => CategorySelection(),
                              )
                          );
                          if(results != null) {
                            //TODO UPDATE TRANSACTION
                            //user.selectCategory(results["categoryID"]);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                          height: 75,
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  transactionType == TransactionType.expense ? "To Expense" : "To Income",
                                  style: TextStyle(
                                      color: Colors.white
                                  )
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                  children: [
                                    Icon(
                                        IconData(user.findCategoryByID(to).icon, fontFamily: 'MaterialIcons'),
                                        color: Colors.white,
                                        size: 32
                                    ),
                                    SizedBox(width: 8.0),
                                    Flexible(
                                      child: Text(
                                        user.findCategoryByID(to).name,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ]
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ]
            ),
            Container(
              color: const Color(0xFBFBFB).withOpacity(1),
              width: double.infinity,
              height: 82,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Expense",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.red[700]
                    )
                  ),
                  SizedBox(height: 14),
                  Text(
                    "$currencySymbol $value",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 32,
                        color: Colors.red[700]
                    )
                  )
                ]
              )
            )
          ],
        )
      )
    );
  }
}
