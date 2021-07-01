import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountsType.dart';
import 'package:money_tracker/screens/calculator.dart';
import 'package:money_tracker/screens/iconAndColorSelection.dart';
import 'package:money_tracker/services/account.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/services/currency.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';


class EditAccount extends StatefulWidget {
  final int accountIndex;
  const EditAccount({Key key, this.accountIndex}) : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = context.read<User>();
    Account currentAccount = user.findAccountByID(widget.accountIndex);
    setState(() {
      accountNameController.text = currentAccount.name;
      descriptionController.text = currentAccount.description;
      balance = currentAccount.balance;
      limit = currentAccount.creditLimit;
      accountColor = Color(currentAccount.color).withOpacity(1.0);
      accountIcon = IconData(currentAccount.icon, fontFamily: 'MaterialIcons');
      isIncludedInTotalNet = currentAccount.isIncludedInTotalNet;
      isDarkIcon = currentAccount.isDarkIcon;
      selectedCurrency = currentAccount.currency;
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
    accountNameController.dispose();
    descriptionController.dispose();
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
              //TODO: ADD TRANSACTION FOR BALANCE DIFFERENCE (OTHERS CATEGORY)
              if(userModel.findAccountByID(widget.accountIndex).balance != balance) {
                userModel.addTransaction(
                    Transaction(
                        value: userModel.findAccountByID(widget.accountIndex).balance-balance,
                        note: "Account adjustment " + accountNameController.text,
                        accountID: widget.accountIndex,
                        categoryID: 9,
                        transactionID: userModel.transactions.length,
                        timestamp: DateTime.now(),
                        transactionType: TransactionType.expense
                    )
                );
              }
              userModel.updateAccount(
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
                  accountID: widget.accountIndex,
                  currency: selectedCurrency,
                  isArchived: false
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
                      onPressed: (){
                        //TODO CURRENCY SELECTION
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
                    child: IgnorePointer(
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
            Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      color: Colors.white,
                      height: 70,
                      onPressed: () {
                        //TODO: ARCHIVE CONFIMRATION POPUP
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                title: Text("Archive ${accountNameController.text}?"),
                                content: Text("All transactions in this account will be archived as well. You may unarchive the account in the Archives menu.",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400
                                        ),
                                ),
                                actions: [
                                  TextButton(onPressed: (){
                                    Navigator.pop(context);
                                  }, child: Text('Cancel')),
                                  TextButton(onPressed: (){
                                    User userModel = context.read<User>();
                                    userModel.archiveAccount(widget.accountIndex);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }, child: Text(
                                      'Archive',
                                  )),
                                ]
                            )
                        );
                      },
                      shape: Border(
                          top: BorderSide(color: Colors.grey[400].withOpacity(0.5), width: 1),
                          bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 10.0, 0),
                    child: IgnorePointer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "Archive Account",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color(0xFF4F4F4F)
                              )
                          )
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
                        //TODO: ADD TRANSACTION COUNT
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Delete ${accountNameController.text}?"),
                            content: RichText(
                                text: TextSpan(
                                  text: "All transactions in this account will be deleted permanently. \n\nIf you wish to hide this account, you may consider ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400
                                  ),
                                  children: [
                                    TextSpan(
                                        text: "Archive",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                        )
                                    ),
                                    TextSpan(
                                      text: " instead",
                                    )
                                  ]
                                )
                            ),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                              }, child: Text('Cancel')),
                              TextButton(onPressed: () {
                                User userModel = context.read<User>();
                                userModel.deleteAccount(widget.accountIndex);
                                Navigator.pushNamedAndRemoveUntil(context, "/home", (Route<dynamic> route) => false);
                              }, child: Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.red[700]
                                )
                              )),
                            ]
                          )
                        );
                      },
                      shape: Border(
                          top: BorderSide(color: Colors.grey[400].withOpacity(0.5), width: 1),
                          bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 10.0, 0),
                    child: IgnorePointer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "Delete Account",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.red[700]
                              )
                          )
                        ],
                      ),
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
