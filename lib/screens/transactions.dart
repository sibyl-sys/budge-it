import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/transactionCard.dart';
import 'package:provider/provider.dart';


class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {

  int month = DateTime.now().month;
  int year = DateTime.now().year;

  renderTransactionListPerDay(User user, List<Transaction> transactions) {
    return Column(
      children: transactions.map((transaction) =>
      //TODO compute actual value based on currency
        TransactionCard(
          color: Color(transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID).color : user.findAccountByID(transaction.toID).color).withOpacity(1),
          icon: IconData(transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID).icon : user.findAccountByID(transaction.toID).icon, fontFamily: "MaterialIcons"),
          categoryName: transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID).name : user.findAccountByID(transaction.toID).name,
          description: transaction.note,
          value: transaction.value,
          type: transaction.transactionType,
          transactionID: transaction.transactionID,
          currencySymbol: user.primaryCurrency.symbol,
        )
      ).toList()
    );
  }

  nextMonth() {
    int nextMonth = month + 1;
    if(nextMonth > 12) {
      setState(() {
        month = 1;
        year += 1;
      });
    } else {
      print(nextMonth);
      setState(() {
        month = nextMonth;
      });
    }
  }

  previousMonth() {
    int nextMonth = month - 1;
    if(nextMonth == 0) {
      setState(() {
        month = 12;
        year -= 1;
      });
    } else {
      print(nextMonth);
      setState(() {
        month = nextMonth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();

    final moneyFormat = new NumberFormat("#,##0.00", "en_US");
    String _value = 'all';
    //TODO CREATE MONTH WIDGET
    List months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    List weekdays = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"];
    double monthlyNet = user.getMonthlyNet(month: month, year: year, accountID: -1);


    final List<Map> transactionListPerDay = user.getTransactions(month: month, year: year, accountID: -1);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Card(
            margin: EdgeInsets.zero,
            child: Container(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: Icon(Icons.chevron_left, color: Theme.of(context).primaryColor), onPressed: previousMonth),
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      SizedBox(width: 8),
                      Text("${months[month-1]} $year",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14
                          )),
                    ],
                  ),
                  IconButton(icon: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor), onPressed: nextMonth)
                ],
              ),
            )
        ),
        SizedBox(height: 4),
        Container(
          color: Colors.white,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Text(
                        monthlyNet.toString(),
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: monthlyNet >= 0 ? Colors.teal[700] : Colors.red[700]
                        )
                    ),
                  ),
                  Icon(
                    monthlyNet >= 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    size: 32,
                    color: monthlyNet >= 0 ? Colors.teal[700] : Colors.red[700],
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(user.getTransactionCount(month: month, year: year, accountID: -1).toString() + " Transactions",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey
                  )),
            ],
          ),
        ),
        SizedBox(height: 8),
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
                              fontSize: 24,
                              color: Color(0x4F4F4F).withOpacity(1)
                            )
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  weekdays[e["weekday"]-1],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Color(0x4F4F4F).withOpacity(1)
                                  )
                              ),
                              Text(
                                  months[e["month"]] + " " + e["year"].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color: Color(0x4F4F4F).withOpacity(1)
                                  )
                              ),
                            ],
                          )
                        ]
                      ),
                      Text(
                          e["value"].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
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
