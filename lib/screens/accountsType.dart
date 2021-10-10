import 'package:flutter/material.dart';
import 'package:money_tracker/services/account.dart';

class AccountsType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  "Add New Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500
                )
              ),
              SizedBox(height: 16),
              Ink(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, AccountType.wallet);
                  },
                  splashColor: Color(0x5F5C96).withOpacity(0.5),
                  child: Container(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0x5F5C96).withOpacity(1),
                            radius: 25,
                            child: Icon(
                              Icons.account_balance_wallet_outlined,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Stash",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Text(
                                "Cash, Debit Cards, Wallet...",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xB6B6B6).withOpacity(1)
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.add,
                            color: Color(0x5F5C96).withOpacity(1),
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Ink(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, AccountType.savings);
                  },
                  splashColor: Color(0x55C9C6).withOpacity(0.5),
                  child: Container(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0x55C9C6).withOpacity(1),
                            radius: 25,
                            child: Icon(
                              Icons.account_balance_outlined,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Savings",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              Text(
                                "Investments, Deposits, Goals...",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xB6B6B6).withOpacity(1)
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.add,
                            color: Color(0x55C9C6).withOpacity(1),
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Ink(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, AccountType.debt);
                  },
                  splashColor: Color(0xEB6468).withOpacity(0.5),
                  child: Container(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xEB6468).withOpacity(1),
                            radius: 25,
                            child: Icon(
                              Icons.credit_card_outlined,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Debt",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              Text(
                                "Credit, Mortgage, Lendings...",
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xB6B6B6).withOpacity(1)
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(
                            Icons.add,
                            color: Color(0xEB6468).withOpacity(1),
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
