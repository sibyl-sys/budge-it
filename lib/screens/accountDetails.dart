import 'package:flutter/material.dart';
import 'package:money_tracker/screens/addTransaction.dart';
import 'package:money_tracker/screens/editAccount.dart';
import 'package:money_tracker/services/account.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/dateRangeBar.dart';
import 'package:money_tracker/widgets/totalHeader.dart';
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

  late DateTime from;
  late DateTime to;

  getValueColor(Transaction transaction, Account currentAccount) {
    if(transaction.transactionType == TransactionType.transfer) {
      if(currentAccount.accountID == transaction.fromID) {
        return Color(0xEB6467).withOpacity(1);
      } else {
        return Color(0x55C9C6).withOpacity(1);
      }
    } else {
      if(transaction.transactionType == TransactionType.expense) {
        return Color(0xEB6467).withOpacity(1);
      } else {
        return Color(0x55C9C6).withOpacity(1);
      }
    }
  }

  renderTransactionListPerDay(User user, List<Transaction> transactions, Account currentAccount) {
    return Column(
        children: transactions.map((transaction) =>
            TransactionCard(
              color: Color(transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID)!.color : user.findAccountByID(transaction.toID)!.color).withOpacity(1),
              icon: IconData(transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID)!.icon : transaction.fromID == currentAccount.accountID ? user.findAccountByID(transaction.toID)!.icon : user.findAccountByID(transaction.fromID)!.icon, fontFamily: "MaterialIcons"),
              categoryName: transaction.transactionType != TransactionType.transfer ? user.findCategoryByID(transaction.toID)!.name : user.findAccountByID(transaction.toID)!.name,
              description: transaction.note,
              value: transaction.value,
              transactionID: transaction.transactionID,
              currencySymbol: user.mySettings.getPrimaryCurrency().symbol,
              type: transaction.transactionType!,
              valueColor: getValueColor(transaction, currentAccount),
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
    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final User user = context.watch<User>();
    double monthlyNet = user.getAccountNet(from: from, to: to, accountID: arguments["accountIndex"]);

    final List<Map> transactionListPerDay = user.getTransactions(from: from, to: to, accountID: arguments["accountIndex"]);
    Account currentAccount = user.findAccountByID(arguments["accountIndex"])!;

    //TODO DATE PICKER
    //TODO IMPLEMENT DATE RANGE

    return currentAccount == null ? SizedBox(height: 0) : Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    barrierColor: Colors.black.withOpacity(0.25),
                    barrierDismissible: true,
                    opaque: false,
                    pageBuilder: (_, __, ___) => EditAccount(accountIndex: arguments["accountIndex"]),
                  )
                );
              },
              child: Text(
                  "EDIT",
              )
          )
        ],
        title: Text("Account Details")
      ),
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero
            ),
            margin: EdgeInsets.zero,
            color: Color(currentAccount.color).withOpacity(1),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Container(
                height: 75,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                          children : [
                            currentAccount.creditLimit == 0 ? CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                  IconData(currentAccount.icon, fontFamily: 'MaterialIcons'),
                                  color: Color(currentAccount.color).withOpacity(1),
                                  size: 24
                              ),
                            ) :CircularPercentIndicator(
                              radius: 24,
                              lineWidth: 4.0,
                              percent: user.getAccountProgress(currentAccount.accountID),
                              progressColor: Colors.lightGreen,
                              backgroundColor: currentAccount.creditLimit == 0 ? Colors.white.withAlpha(0) : Colors.grey.shade300,
                              center: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                    IconData(currentAccount.icon, fontFamily: 'MaterialIcons'),
                                    color: Color(currentAccount.color).withOpacity(1),
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
                                      currentAccount.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                      )
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                      currentAccount.description,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 12.0,
                                      )
                                  ),
                                ]
                            ),
                          ]
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
                        height: 65,
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
                              BorderSide.none
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              Colors.white
                            )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_downward,
                                size: 25,
                                color: Color(0x55C9C6).withOpacity(1),
                              ),
                              SizedBox(
                                height: 8
                              ),
                              Text(
                                  "Deposit",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 11
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 65,
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
                                  BorderSide.none
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.white
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                size: 25,
                                color: Color(0xEB6467).withOpacity(1),
                              ),
                              SizedBox(
                                  height: 8
                              ),
                              Text(
                                  "Withdraw",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 65,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)
                                  )
                              ),
                              side: MaterialStateProperty.all(
                                  BorderSide.none
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.white
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward,
                                size: 25,
                                color: Color(0XB6B6B6).withOpacity(1),
                              ),
                              SizedBox(
                                  height: 8
                              ),
                              Text(
                                  "Transfer",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 65,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)
                                  )
                              ),
                              side: MaterialStateProperty.all(
                                  BorderSide.none
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.white
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.autorenew,
                                size: 25,
                                color: Color(0x5F5C96).withOpacity(1)
                              ),
                              SizedBox(
                                  height: 8
                              ),
                              Text(
                                  "Balance",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
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
                TotalHeader(header: "Balance:", valueColor: Color(0x55C9C6).withOpacity(1), currencySymbol: user.mySettings.getPrimaryCurrency().symbol, value: currentAccount.balance, description:
                Text(user.getTransactionCount(from: from, to: to, accountID: currentAccount.accountID).toString() + " Transactions",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey
                    )),
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
                                                fontSize: 26,
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
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10,
                                                    color: Color(0x4F4F4F).withOpacity(1)
                                                )
                                            ),
                                            Text(
                                                months[e["month"]] + " " + e["year"].toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    color: Color(0xB6B6B6).withOpacity(1)
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
                                child:renderTransactionListPerDay(user, e["transactions"], currentAccount)
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
