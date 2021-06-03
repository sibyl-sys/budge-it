import 'package:flutter/material.dart';
import 'package:money_tracker/services/account.dart';

class AccountsType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Select Account Type'),
      backgroundColor: const Color(0xFFF2F2F2),
      children : [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, AccountType.wallet);
          },
          child: Container(
            color: Colors.white,
            width: 280.0,
            height: 70.0,
            padding: EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                    Icons.account_balance_wallet,
                    size: 32,
                    color: const Color(0xFF27AE60)
                ),
                SizedBox(width: 16),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Stash",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                      Text(
                          "Regular, Cash, Card, Bank",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey
                          ))
                    ]
                )
              ],
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, AccountType.savings);
          },
          child: Container(
            color: Colors.white,
            width: 280.0,
            height: 70.0,
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                    Icons.account_balance,
                    size: 32,
                    color: const Color(0xFF2D9CDB)
                ),
                SizedBox(width: 16),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Savings",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                      Text(
                          "Savings, Goals",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey
                          ))
                    ]
                )
              ],
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, AccountType.debt);
          },
          child: Container(
            color: Colors.white,
            width: 280.0,
            height: 70.0,
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                    Icons.credit_card,
                    size: 32,
                    color: Colors.redAccent
                ),
                SizedBox(width: 16),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Debt",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                      Text(
                          "Credit, Mortgage",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey
                          ))
                    ]
                )
              ],
            ),
          ),
        )
      ]
    );
  }
}
