import 'package:flutter/material.dart';
import 'package:money_tracker/services/account.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/accountCard.dart';
import 'package:money_tracker/widgets/totalHeader.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DebtsTab extends StatefulWidget {
  final Function(int) onAccountTapped;

  const DebtsTab({Key? key, required this.onAccountTapped}) : super(key: key);

  @override
  _DebtsTabState createState() => _DebtsTabState();
}

class _DebtsTabState extends State<DebtsTab> {

  final moneyFormat = new NumberFormat("#,##0.00", "en_US");

  Widget renderCallToAction() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 75,
            backgroundColor: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
            child: Text(
                "Ooops! You don't have a debt account yet",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18
                )
            ),
          ),
          Text(
              "Add new account",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                  fontSize: 18
              )
          ),
        ],
      ),
    );
  }

  Widget renderIOweAccounts(User user) {
    final iOwed = user.iOwedAccounts;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "I Owe",
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                )
            ),
            RichText(
              text: TextSpan(
                  text: "${user.primaryCurrency.symbol} ",
                  style: TextStyle(
                    color: Color(0x55C9C6).withOpacity(1),
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                        text: "${moneyFormat.format(user.totalRegular).split('.')[0]}",
                        style: TextStyle(
                            color: Color(0x55C9C6).withOpacity(1),
                            fontSize: 14,
                            fontFamily: "Poppins"
                        )
                    ),
                    TextSpan(
                        text: ".${moneyFormat.format(user.totalRegular).split('.')[1]}",
                        style: TextStyle(
                            color: Color(0x55C9C6).withOpacity(1),
                            fontSize: 12,
                            fontFamily: "Poppins"
                        )
                    )
                  ]
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        renderAccounts(user, iOwed),
        SizedBox(height: 32),
      ],
    );
  }

  Widget renderIAmOwedAccounts(User user) {
    final iAmOwed = user.iAmOwedAccounts;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "I am owed",
                style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                )
            ),
            RichText(
              text: TextSpan(
                  text: "${user.primaryCurrency.symbol} ",
                  style: TextStyle(
                    color: Color(0x55C9C6).withOpacity(1),
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                        text: "${moneyFormat.format(user.totalSavings).split('.')[0]}",
                        style: TextStyle(
                            color: Color(0x55C9C6).withOpacity(1),
                            fontSize: 14,
                            fontFamily: "Poppins"
                        )
                    ),
                    TextSpan(
                        text: ".${moneyFormat.format(user.totalSavings).split('.')[1]}",
                        style: TextStyle(
                            color: Color(0x55C9C6).withOpacity(1),
                            fontSize: 12,
                            fontFamily: "Poppins"
                        )
                    )
                  ]
              ),
            ),
          ],
        ),
        SizedBox(height: 8.0),
        renderAccounts(user, iAmOwed),
      ],
    );
  }
  //TODO COMPUTATION FOR INCREASE
  Widget renderAllAccounts(User user) {
    final iAmOwed = user.iAmOwedAccounts;
    final iOwed = user.iOwedAccounts;
    return Column(
      children: [
        TotalHeader(header: "Total Debts", valueColor: Color(0x333333).withOpacity(1), currencySymbol: user.primaryCurrency.symbol, value: user.totalDebts, description:
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_upward,
              color: Color(0x55C9C6).withOpacity(1),
              size: 12,
            ),
            Text("0% from last month",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[400],
                  fontSize: 12,
                )
            ),
          ],
        ),
        isDebt: true),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                iAmOwed.length > 0 ? renderIAmOwedAccounts(user) : SizedBox(height: 0),
                iOwed.length > 0 ? renderIOweAccounts(user) : SizedBox(height: 0)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget renderAccounts(User user, List<Account> accounts) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: accounts.map((account) =>
            AccountCard(
              accountName: account.name,
              icon: IconData(account.icon, fontFamily: 'MaterialIcons'),
              color: Color(account.color).withOpacity(1),
              balance: account.balance,
              creditLimit: account.creditLimit,
              progress: user.getAccountExpenses(account.accountID, DateTime.now().month, DateTime.now().year) / account.creditLimit * 100,
              description: account.description,
              accountIndex: account.accountID,
              onAccountTapped: widget.onAccountTapped,
              currencySymbol : account.currency.symbol,
              isDebt: true,
            )
        ).toList()
    );
  }

  @override
  Widget build(BuildContext context) {

    final user = context.watch<User>();
    return user.accounts.length > 0 ? renderAllAccounts(user) : renderCallToAction();
  }
}
