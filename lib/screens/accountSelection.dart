import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountsTab.dart';

class AccountSelection extends StatefulWidget {
  @override
  _AccountSelectionState createState() => _AccountSelectionState();
}

class _AccountSelectionState extends State<AccountSelection> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 350,
          height: 500,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: Column(
            children: [
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.5),
                      width: 2.0
                    )
                  )
                ),
                child: Center(
                  child: Text(
                    "Select Account",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16
                    )
                  ),
                )
              ),
              Expanded(
                child: Container(
                  child: AccountsTab(
                      onAccountTapped: (int accountID) {
                        Navigator.pop(context, {
                          "accountID": accountID
                        });
                      }
                  ),
                ),
              )
            ]
          ),
        )
      ),
    );
  }
}
