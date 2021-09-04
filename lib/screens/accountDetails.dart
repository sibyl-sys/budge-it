import 'package:flutter/material.dart';
import 'package:money_tracker/screens/addTransaction.dart';
import 'package:money_tracker/screens/editAccount.dart';
import 'package:money_tracker/services/account.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/creditLimitText.dart';
import 'package:money_tracker/widgets/dateRangeBar.dart';
import 'package:money_tracker/widgets/transactionCard.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AccountDetails extends StatefulWidget {

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");

  List months = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"];
  List weekdays = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"];

  DateTime from;
  DateTime to;

  renderTransactionListPerDay(User user, List<Transaction> transactions) {
    return Column(
        children: transactions.map((transaction) =>
            TransactionCard(
              color: Color(transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID).color : user.findAccountByID(transaction.toID).color).withOpacity(1),
              icon: IconData(transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID).icon : user.findAccountByID(transaction.toID).icon, fontFamily: "MaterialIcons"),
              categoryName: transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID).name : user.findAccountByID(transaction.toID).name,
              description: transaction.note,
              value: transaction.value,
              transactionID: transaction.transactionID,
              currencySymbol: user.primaryCurrency.symbol,
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
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final User user = context.watch<User>();
    double monthlyNet = user.getMonthlyNet(from: from, to: to, accountID: arguments["accountIndex"]);

    final List<Map> transactionListPerDay = user.getTransactions(from: from, to: to, accountID: arguments["accountIndex"]);
    Account currentAccount = user.findAccountByID(arguments["accountIndex"]);

    //TODO DATE PICKER
    //TODO IMPLEMENT DATE RANGE

    return currentAccount == null ? SizedBox(height: 0) : Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(onPressed: () {
            Navigator.of(context).push(
                PageRouteBuilder(
                  barrierColor: Colors.black.withOpacity(0.25),
                  barrierDismissible: true,
                  opaque: false,
                  pageBuilder: (_, __, ___) => EditAccount(accountIndex: arguments["accountIndex"]),
                )
            );
          }, child: Text("EDIT",
              style: TextStyle(color: Colors.white)
            )
          )
        ],
        title: Text("Account Details")
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Container(
                height: 75,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children : [
                            CircularPercentIndicator(
                              radius: 48,
                              lineWidth: 4.0,
                              percent: currentAccount.creditLimit > 0 ? currentAccount.balance / currentAccount.creditLimit / 100 : 0,
                              progressColor: Colors.lightGreen,
                              backgroundColor: currentAccount.creditLimit == 0 ? Colors.white.withAlpha(0) : Colors.grey[300],
                              center: CircleAvatar(
                                backgroundColor: Color(currentAccount.color).withOpacity(1),
                                child: Icon(
                                    IconData(currentAccount.icon, fontFamily: 'MaterialIcons'),
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
                                      currentAccount.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                      )
                                  ),
                                  SizedBox(height: 4),
                                  RichText(
                                    text: TextSpan(
                                        text: "${currentAccount.currency.symbol} ${moneyFormat.format(currentAccount.balance).split('.')[0]}",
                                        style: TextStyle(
                                            color: Colors.green[700],
                                            fontSize: 16
                                        ),
                                        children: [
                                          TextSpan(
                                              text: ".${moneyFormat.format(currentAccount.balance).split('.')[1]}",
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
                              "${currentAccount.description}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12.0,
                                  color: Colors.grey[600]
                              )
                          ),
                          SizedBox(height: 4),
                          CreditLimitText(creditLimit: currentAccount.creditLimit, progress: currentAccount.balance / currentAccount.creditLimit)
                        ],
                      ),
                    ],
                  ),
              ),
            ),
          ),
          SizedBox(height: 1.0),
          DateRangeBar(
            from: this.from,
            to: this.to,
            onChanged: changeDate,
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 85,
                        height: 85,
                        child: OutlinedButton(
                          onPressed: () {
                            final user = context.read<User>();
                            user.selectAccountFrom(currentAccount.accountID);
                            user.selectRecipient(user.incomeCategories[0].categoryID, TransactionType.income);
                            Navigator.of(context).push(
                                PageRouteBuilder(
                                  barrierColor: Colors.black.withOpacity(0.25),
                                  barrierDismissible: true,
                                  opaque: false,
                                  pageBuilder: (_, __, ___) => AddTransaction(),
                                )
                            );
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)
                              )
                            ),
                            side: MaterialStateProperty.all(
                              BorderSide(
                                color: Colors.teal[400],
                                width: 2.0,
                              )
                            )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                size: 32,
                                color: Colors.teal[400],
                              ),
                              SizedBox(
                                height: 8
                              ),
                              Text(
                                  "Deposit",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 85,
                        height: 85,
                        child: OutlinedButton(
                          onPressed: () {
                            final user = context.read<User>();
                            user.selectAccountFrom(currentAccount.accountID);
                            user.selectRecipient(user.expenseCategories[0].categoryID, TransactionType.expense);
                            Navigator.of(context).push(
                                PageRouteBuilder(
                                  barrierColor: Colors.black.withOpacity(0.25),
                                  barrierDismissible: true,
                                  opaque: false,
                                  pageBuilder: (_, __, ___) => AddTransaction(),
                                )
                            );
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)
                                  )
                              ),
                              side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: Colors.red[700],
                                    width: 2.0,
                                  )
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                size: 32,
                                color: Colors.red[700],
                              ),
                              SizedBox(
                                  height: 8
                              ),
                              Text(
                                  "Withdraw",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 85,
                        height: 85,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)
                                  )
                              ),
                              side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: Colors.blue[700],
                                    width: 2.0,
                                  )
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward,
                                size: 32,
                                color: Colors.blue[700],
                              ),
                              SizedBox(
                                  height: 8
                              ),
                              Text(
                                  "Transfer",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 85,
                        height: 85,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)
                                  )
                              ),
                              side: MaterialStateProperty.all(
                                  BorderSide(
                                    color: Colors.yellow[700],
                                    width: 2.0,
                                  )
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.autorenew,
                                size: 32,
                                color: Colors.yellow[700],
                              ),
                              SizedBox(
                                  height: 8
                              ),
                              Text(
                                  "Re-balance",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                      Text(user.getTransactionCount(from: from, to: to, accountID: currentAccount.accountID).toString() + " Transactions",
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
            ),
          )
        ],
      ),
    );
  }
}
