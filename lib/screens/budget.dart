import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/dateRangeBar.dart';
import 'package:money_tracker/widgets/totalHeader.dart';
import 'package:money_tracker/widgets/budgetCard.dart';

class Budget extends StatefulWidget {
  const Budget({Key? key}) : super(key: key);

  @override
  _BudgetState createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");

  late DateTime from;
  late DateTime to;

  int month = DateTime.now().month;
  int year = DateTime.now().year;

  @override
  void initState() {
    super.initState();

    var now = new DateTime.now();
    setState(() {
      from = DateTime(now.year, now.month, 1);
      to = DateTime(now.year, now.month + 1, 0);
    });
  }

  changeDate(Map dateMap) {
    setState(() {
      from = dateMap["from"];
      to = dateMap["to"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    double totalBudget = 0;
    double totalRemaining = 0;

    return Material(
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateRangeBar(
            from: this.from,
            to: this.to,
            onChanged: changeDate,
          ),
          TotalHeader(
              header: "Budget Expenses:",
              valueColor: Color(0xFF4F4F4F),
              currencySymbol: user.mySettings.getPrimaryCurrency().symbol,
              value: user.getRangeNet(from: this.from, to: this.to),
              description: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_upward,
                    color: Color(0x55C9C6).withOpacity(1),
                    size: 12,
                  ),
                  Text("0% budget increase",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[400],
                        fontSize: 12,
                      )),
                ],
              )),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text("Main Budget",
                style: TextStyle(
                    color: Color(0xFFB6B6B6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ),
          Column(
            children: user.getActiveBudgets(from, to).map((e) {
              double budgetCap = user.getMonthlyBudgetCap(from, to, e.budgetID);
              double budgetExpenditures =
                  user.getBudgetExpenditures(from, to, e.budgetID);
              totalBudget += budgetCap;
              totalRemaining += (budgetCap - budgetExpenditures);
              return BudgetCard(
                  name: e.name,
                  amount: budgetExpenditures,
                  cap: budgetCap,
                  id: e.budgetID,
                  color: Color(e.color).withOpacity(1),
                  icon: IconData(e.icon, fontFamily: 'MaterialIcons'),
                  currencySymbol: "\$");
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Current Total",
                      style: TextStyle(
                          color: Color(0xFFB6B6B6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  RichText(
                    text: TextSpan(
                        text: "${user.mySettings.getPrimaryCurrency().symbol}",
                        style: TextStyle(
                            color: Color(0xFF4f4f4f),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                              text: "${moneyFormat.format((totalRemaining))}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400)),
                        ]),
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              RichText(
                text: TextSpan(
                    text: "/ ${user.mySettings.getPrimaryCurrency().symbol}",
                    style: TextStyle(
                        color: Color(0xFFB6B6B6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                          text: "${moneyFormat.format((totalBudget))}",
                          style: TextStyle(
                              color: Color(0xFFB6B6B6),
                              fontSize: 12,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500)),
                    ]),
              ),
            ]),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text("Inactive Budget",
                style: TextStyle(
                    color: Color(0xFFB6B6B6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
          ),
          Column(
            children: user
                .getInactiveBudgets(from, to)
                .map(
                  (e) => BudgetCard(
                      name: e.name,
                      amount: user.getBudgetExpenditures(from, to, e.budgetID),
                      cap: user.getMonthlyBudgetCap(from, to, e.budgetID),
                      id: e.budgetID,
                      color: Color(e.color).withOpacity(1),
                      icon: IconData(e.icon, fontFamily: 'MaterialIcons'),
                      currencySymbol: "\$"),
                )
                .toList(),
          ),
        ],
      )),
    );
  }
}
