import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountsType.dart';
import 'package:money_tracker/screens/calculator.dart';
import 'package:money_tracker/screens/currencySelection.dart';
import 'package:money_tracker/screens/iconAndColorSelection.dart';
import 'package:money_tracker/services/account.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';


class NewAccount extends StatefulWidget {
  @override
  _NewAccountState createState() => _NewAccountState();
}


class _NewAccountState extends State<NewAccount> {
  //TODO INITIALIZE CURRENCY
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");

  AccountType _accountType = AccountType.wallet;
  bool isIncludedInTotalNet = true;
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  double balance = 0;
  double limit = 0;
  IconData accountIcon = Icons.account_balance_wallet;
  Color accountColor = Colors.blue[700];
  bool isDarkIcon = false;
  Currency selectedCurrency;

  void initState() {
    super.initState();
    User userModel = context.read<User>();
    setState(() {
      selectedCurrency = userModel.primaryCurrency;
    });
  }

  Future<void> _selectAccountType(BuildContext context) async {
    AccountType newAccountType = await showDialog<AccountType>(
        context: context,
        builder: (BuildContext context) {
          return AccountsType();
        }
    );
    setState(() {
      _accountType = newAccountType;
    });
  }

  TextStyle generateMoneyStyle(double value) {
    if(value > 0) {
      return TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          color: Colors.teal[400]
      );
    } else {
      return TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: const Color(0xFFBDBDBD)
      );
    }
  }

  String getAccountTypeString() {
    switch(_accountType) {
      case AccountType.wallet:
        return "Stash";
      case AccountType.savings:
        return "Savings - Goals";
      case AccountType.debt:
        return "Debt - Mortgage";
      default:
        return "Stash";
    }
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              User userModel = context.read<User>();
              if(userModel.accounts.length < 0) {
                userModel.changePrimaryCurrency(selectedCurrency);
              }
              userModel.addAccount(
                Account(
                  name: accountNameController.text,
                  icon: accountIcon.codePoint,
                  color: accountColor.value,
                  balance: balance,
                  accountType: _accountType,
                  creditLimit: limit,
                  description: descriptionController.text,
                  isIncludedInTotalNet: isIncludedInTotalNet,
                  isDarkIcon : isDarkIcon,
                  accountID: userModel.newAccountID,
                  isArchived: false,
                  currency: selectedCurrency
                ),
              );
              Navigator.pop(context);
            },)
        ],
        title: Text("New Account"),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 20.0, 16.0, 20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: accountColor,
                      child: IconButton(
                          icon: Icon(accountIcon, size: 30),
                          color: isDarkIcon ? Colors.black.withOpacity(0.2) : Colors.white,
                          onPressed: () async {
                            final result = await Navigator.of(context).push(
                                PageRouteBuilder(
                                  barrierColor: Colors.black.withOpacity(0.25),
                                  barrierDismissible: true,
                                  opaque: false,
                                  pageBuilder: (_, __, ___) => IconAndColorSelection(accountColor: this.accountColor, accountIcon: this.accountIcon, isDarkIcon: isDarkIcon),
                                )
                            );
                            if(result != null) {
                              setState(() {
                                accountIcon = result["iconData"];
                                accountColor = result["backgroundColor"];
                                isDarkIcon = result["isDarkIcon"];
                              });
                            }

                          }
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _selectAccountType(context);
                      },
                      child: Container(
                        width: 250,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                                getAccountTypeString(),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400
                                )
                            ),
                            Icon(
                              Icons.arrow_right,
                              color: Theme.of(context).primaryColor,
                              size: 28
                            )
                          ],
                        )
                      )
                    )
                  ]
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                      color: Colors.white,
                      height: 70,
                      onPressed: (){
                        nameFocusNode.requestFocus();
                      },
                      shape: Border(
                          top: BorderSide(color: Colors.grey[400].withOpacity(0.5), width: 1),
                          bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                      ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: const Color(0xFF4F4F4F)
                          )
                      ),
                      SizedBox(
                        width: 250,
                        child: TextField(
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: const Color(0xFF4F4F4F)
                          ),
                          focusNode: nameFocusNode,
                          textAlign: TextAlign.right,
                          controller: accountNameController,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: "Untitled Account",
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: const Color(0xFFBDBDBD)
                            )
                          ),
                        ),
                      )

                    ],
                  ),
                )
              ]
            ),
            Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      color: Colors.white,
                      height: 70,
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                            PageRouteBuilder(
                              barrierColor: Colors.black.withOpacity(0.25),
                              barrierDismissible: true,
                              opaque: false,
                              pageBuilder: (_, __, ___) => Calculator(),
                            )
                        );
                        if(result != null) {
                          setState(() {
                            balance = result;
                          });
                        }
                      },
                      shape: Border(
                          top: BorderSide(color: Colors.grey[400].withOpacity(0.5), width: 1),
                          bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0),
                    child: IgnorePointer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Balance",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color(0xFF4F4F4F)
                              )
                          ),
                          Text(
                              "P ${moneyFormat.format(this.balance)}",
                              style: generateMoneyStyle(this.balance),
                          ),
                        ],
                      ),
                    ),
                  )
                ]
            ),
            Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      color: Colors.white,
                      height: 70,
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          PageRouteBuilder(
                            barrierColor: Colors.black.withOpacity(0.25),
                            barrierDismissible: true,
                            opaque: false,
                            pageBuilder: (_, __, ___) => Calculator(),
                          )
                        );
                        if(result != null) {
                          setState(() {
                            limit = result;
                          });
                        }
                      },
                      shape: Border(
                          top: BorderSide(color: Colors.grey[400].withOpacity(0.5), width: 1),
                          bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0),
                    child: IgnorePointer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Limit",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color(0xFF4F4F4F)
                              )
                          ),
                          Text(
                              "P ${moneyFormat.format(this.limit)}",
                              style: generateMoneyStyle(this.limit)
                          ),
                        ],
                      ),
                    ),
                  )
                ]
            ),
            Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      color: Colors.white,
                      height: 70,
                      onPressed: () async{
                        //TODO CURRENCY SELECTION
                        final result = await Navigator.of(context).push(
                            PageRouteBuilder(
                              barrierColor: Colors.black.withOpacity(0.25),
                              barrierDismissible: true,
                              opaque: false,
                              pageBuilder: (_, __, ___) => CurrencySelection(),
                            )
                        );
                        if(result != null) {
                          setState(() {
                            selectedCurrency = result;
                          });
                        }
                      },
                      shape: Border(
                          top: BorderSide(color: Colors.grey[400].withOpacity(0.5), width: 1),
                          bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0),
                    child: IgnorePointer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Currency",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color(0xFF4F4F4F)
                              )
                          ),
                          Text(
                              "${selectedCurrency.symbol} (${selectedCurrency.name})",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: const Color(0xFFBDBDBD)
                              )
                          ),
                        ],
                      ),
                    ),
                  )
                ]
            ),
            Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      color: Colors.white,
                      height: 70,
                      onPressed: (){
                        descriptionFocusNode.requestFocus();
                      },
                      shape: Border(
                          top: BorderSide(color: Colors.grey[400].withOpacity(0.5), width: 1),
                          bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Description",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: const Color(0xFF4F4F4F)
                            )
                        ),
                        SizedBox(
                          width: 250,
                          child: TextField(
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color(0xFF4F4F4F)
                            ),
                            focusNode: descriptionFocusNode,
                            textAlign: TextAlign.right,
                            controller: descriptionController,
                            decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: "ex. Daily carry wallet",
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18,
                                    color: const Color(0xFFBDBDBD)
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]
            ),
            Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      color: Colors.white,
                      height: 70,
                      onPressed: (){
                        setState(() {
                          isIncludedInTotalNet = !isIncludedInTotalNet;
                        });
                      },
                      shape: Border(
                          top: BorderSide(color: Colors.grey[400].withOpacity(0.5), width: 1),
                          bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 10.0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Include in Total Net",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: const Color(0xFF4F4F4F)
                            )
                        ),
                        SizedBox(
                          width: 60,
                          child: Switch(
                            onChanged: (bool isOn) {
                              setState(() {
                                isIncludedInTotalNet = isOn;
                              });
                            },
                            value: isIncludedInTotalNet,
                            activeColor: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                  )
                ]
            ),
          ],
        ),
      ),
    );
  }
}
