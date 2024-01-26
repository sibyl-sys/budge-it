import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/dateRangeBar.dart';
import 'package:money_tracker/widgets/favTransactionButton.dart';
import 'package:money_tracker/widgets/totalHeader.dart';
import 'package:money_tracker/widgets/transactionCard.dart';
import 'package:provider/provider.dart';


class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {

  late DateTime from;
  late DateTime to;

  int month = DateTime.now().month;
  int year = DateTime.now().year;

  getValueColor(Transaction transaction) {
    if(transaction.transactionType == TransactionType.transfer) {
        return Color(0xB6B6B6).withOpacity(1);
    } else if(transaction.transactionType == TransactionType.expense) {
        return Color(0xEB6467).withOpacity(1);
    } else {
      return Color(0x55C9C6).withOpacity(1);
    }
  }

  renderTransactionListPerDay(User user, List<Transaction> transactions) {
    return Column(
      children: transactions.map((transaction) =>
      //TODO compute actual value based on currency
        TransactionCard(
          color: Color(transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID)!.color : user.findAccountByID(transaction.toID)!.color).withOpacity(1),
          icon: IconData(transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID)!.icon : user.findAccountByID(transaction.toID)!.icon, fontFamily: "MaterialIcons"),
          categoryName: transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID)!.name : user.findAccountByID(transaction.toID)!.name,
          description: transaction.note,
          value: transaction.value,
          type: transaction.transactionType!,
          transactionID: transaction.transactionID,
          currencySymbol: user.mySettings.getPrimaryCurrency().symbol,
          valueColor: getValueColor(transaction),
          importance: transaction.importance!,
        )
      ).toList()
    );
  }

  changeDate(Map dateMap) {
    setState(() {
      from = dateMap["from"];
      to = dateMap["to"];
    });
  }

  @override
  void initState() {
    super.initState();
    var now = new DateTime.now();
    setState(() {
      from = DateTime(now.year, now.month, 1);
      to = DateTime(now.year, now.month + 1, 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    final moneyFormat = new NumberFormat("#,##0.00", "en_US");
    String _value = 'all';
    //TODO CREATE MONTH WIDGET
    List months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    List weekdays = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"];
    double monthlyNet = user.getMonthlyNet(from: from, to: to, accountID: -1);


    final List<Map> transactionListPerDay = user.getTransactions(from: from, to: to, accountID: -1);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DateRangeBar(
          from: this.from,
          to: this.to,
          onChanged: changeDate,
        ),
        SizedBox(height: 4),
        TotalHeader(header: "Total Net:", valueColor: Color(0x4F4F4F).withOpacity(1), currencySymbol: user.mySettings.getPrimaryCurrency().symbol, value: user.getMonthlyNet(from: from, to: to, accountID: -1), description:
        RichText(
          text: TextSpan(
              text: "xx%",
              style: TextStyle(
                color: Color(0x55C9C6).withOpacity(1),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              children: [
                TextSpan(
                    text: " Total Savings",
                    style: TextStyle(
                        color: Color(0xB6B6B6).withOpacity(1),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins"
                    )
                ),
              ]
          ),
        )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text("Favorites", style: TextStyle(color: Color(0xFFB6B6B6), fontSize: 12, fontWeight: FontWeight.w500)),
        ),
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: 16.0),
        //   height: 50,
        //   child: ListView.builder(
        //       itemCount: user.favoriteTransactions.length,
        //       scrollDirection: Axis.horizontal,
        //       itemBuilder: (context, index) {
        //         Transaction transaction = user.favoriteTransactions[index];
        //         return FavTransactionButton(
        //           color: Color(transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID)!.color : user.findAccountByID(transaction.toID)!.color).withOpacity(1),
        //           icon: IconData(transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID)!.icon : user.findAccountByID(transaction.toID)!.icon, fontFamily: "MaterialIcons"),
        //           categoryName: transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID)!.name : user.findAccountByID(transaction.toID)!.name,
        //           value: transaction.value,
        //           type: transaction.transactionType,
        //           currencySymbol: user.primaryCurrency.symbol,
        //           importance: transaction.importance,
        //           fromID: transaction.fromID,
        //           toID: transaction.toID
        //         );
        //       }
        //   ),
        // ),
        Column(
          children: transactionListPerDay.map((e) =>
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            e["day"].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 26,
                              color: Color(0x3C3A5F).withOpacity(1)
                            )
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  weekdays[e["weekday"]-1],
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0x3C3A5F).withOpacity(1)
                                  )
                              ),
                              Text(
                                  months[e["month"]] + " " + e["year"].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Color(0x5F5C96).withOpacity(1)
                                  )
                              ),
                            ],
                          )
                        ]
                      ),
                      Text(
                          e["value"].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Color(0x4F4F4F).withOpacity(1)
                          )
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:renderTransactionListPerDay(user, e["transactions"])
                )
              ],
            )
          ).toList()
        )
      ],
    );
  }
}
