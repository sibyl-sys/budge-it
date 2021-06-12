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
  final TextEditingController notesController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    notesController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      final user = context.read<User>();
      Transaction transaction = user.findTransactionByID(widget.transactionID);
      transaction.note = notesController.text;
      user.updateTransaction(transaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    Transaction transaction = user.findTransactionByID(widget.transactionID);
    notesController.text = transaction.note;
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
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
                        color: Color(user.findAccountByID(transaction.accountID).color).withOpacity(1),
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
                              transaction.accountID = result["accountID"];
                              user.updateTransaction(transaction);
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
                                          IconData(user.findAccountByID(transaction.accountID).icon, fontFamily: 'MaterialIcons'),
                                          color: Colors.white,
                                          size: 32
                                      ),
                                      SizedBox(width: 8.0),
                                      Flexible(
                                        child: Text(
                                          user.findAccountByID(transaction.accountID).name,
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
                        color: Color(user.findCategoryByID(transaction.categoryID).color).withOpacity(1),
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
                              transaction.categoryID = results["categoryID"];
                              user.updateTransaction(transaction);
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
                                    transaction.transactionType == TransactionType.expense ? "To Expense" : "To Income",
                                    style: TextStyle(
                                        color: Colors.white
                                    )
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                    children: [
                                      Icon(
                                          IconData(user.findCategoryByID(transaction.categoryID).icon, fontFamily: 'MaterialIcons'),
                                          color: Colors.white,
                                          size: 32
                                      ),
                                      SizedBox(width: 8.0),
                                      Flexible(
                                        child: Text(
                                          user.findCategoryByID(transaction.categoryID).name,
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
                      "${user.findAccountByID(transaction.accountID).currency.symbol} ${transaction.value}",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 32,
                          color: Colors.red[700]
                      )
                    )
                  ]
                )
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[400].withOpacity(0.25), width: 1.0),
                  ),
                  color: Colors.white,
                ),
                child: TextField(
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: const Color(0xFF4F4F4F)
                  ),
                  textAlign: TextAlign.center,
                  controller: notesController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12.0) ,
                      isDense: true,
                      border: InputBorder.none,
                      hintText: "Notes...",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: const Color(0xFFBDBDBD)
                      )
                  ),
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}
