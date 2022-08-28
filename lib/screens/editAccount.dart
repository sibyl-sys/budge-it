import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountsType.dart';
import 'package:money_tracker/screens/calculator.dart';
import 'package:money_tracker/screens/currencySelection.dart';
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


  Color generateMoneyStyle(double value) {
    if(value < 0) {
      return Color(0xFFEB6467);
    } else if(value == 0) {
      return Color(0xFFB6B6B6);
    } else {
      return Color(0xFF55C9C6);
    }
  }

  Color generateLimitStyle(double value) {
    if (value == 0) {
      return Color(0xFFB6B6B6);
    } else {
      return Color(0xFF4F4F4F);
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

  String getLimitHeader() {
    switch(_accountType) {
      case AccountType.wallet:
        return "Expense Limit";
      case AccountType.savings:
        return "Goal";
      case AccountType.debt:
        return "Total Debt";
      default:
        return "Expense Limit";
    }
  }

  String getLimitDescription() {
    switch(_accountType) {
      case AccountType.wallet:
        return "Monthly Limit";
      case AccountType.savings:
        return "Savings Target";
      case AccountType.debt:
        return "";
      default:
        return "Expense Limit";
    }
  }

  String getBalanceHeader() {
    switch(_accountType) {
      case AccountType.wallet:
        return "Balance";
      case AccountType.savings:
        return "Balance";
      case AccountType.debt:
        return "Debt Balance";
      default:
        return "Expense Limit";
    }
  }

  String getBalanceDescription() {
    switch(_accountType) {
      case AccountType.wallet:
        return "Current Amount";
      case AccountType.savings:
        return "Current Amount";
      case AccountType.debt:
        if(balance > 0)
          return "I am Owed";
        else
          return "I Owe";
        break;
      default:
        return "Expense Limit";
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
              if(userModel.findAccountByID(widget.accountIndex).balance != balance) {
                userModel.addTransaction(
                    Transaction(
                        value: userModel.findAccountByID(widget.accountIndex).balance-balance,
                        note: "Account adjustment " + accountNameController.text,
                        fromID: widget.accountIndex,
                        toID: 9,
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
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero
              ),
              margin: EdgeInsets.zero,
              color: accountColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                child: Container(
                  height: 75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children : [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                  icon: Icon(accountIcon, size: 30),
                                  color: accountColor,
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
                            SizedBox(width: 20),
                            InkWell(
                              onTap: () {
                                _selectAccountType(context);
                              },
                              splashColor: Colors.white.withOpacity(0.5),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                width: 250,
                                height: 50,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Type",
                                          style: TextStyle(
                                            color: Color(0xB6B6B6).withOpacity(1),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.0,
                                          )
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                              getAccountTypeString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0,
                                              )
                                          ),
                                          Icon(
                                              Icons.arrow_drop_down_sharp,
                                              color: Colors.white,
                                              size: 24
                                          )
                                        ],
                                      ),
                                    ]
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  nameFocusNode.requestFocus();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[400].withOpacity(0.5), width: 1)
                    ),
                  ),
                  height: 74,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            )
                        ),
                        SizedBox(height: 8.0),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: const Color(0xFF4F4F4F)
                            ),
                            focusNode: nameFocusNode,
                            controller: accountNameController,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              hintText: "Untitled Account",
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: const Color(0xFFBDBDBD)
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ),
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () async {
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
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                    ),
                  ),
                  width: double.infinity,
                  height: 74,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Currency",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor
                            )
                        ),
                        RichText(
                          text: TextSpan(
                              text: "${selectedCurrency.symbol} ",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF4F4F4F)
                              ),
                              children: [
                                TextSpan(
                                    text: " (${selectedCurrency.name})",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF4F4F4F)
                                    )
                                ),
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.of(context).push(
                      PageRouteBuilder(
                        barrierColor: Colors.black.withOpacity(0.25),
                        barrierDismissible: true,
                        opaque: false,
                        pageBuilder: (_, __, ___) => Calculator(valueCurrencySymbol: this.selectedCurrency.symbol, header: getBalanceHeader(), isDebt: false),
                      )
                  );
                  if(result != null) {
                    setState(() {
                      balance = result;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                    ),
                  ),
                  width: double.infinity,
                  height: 74,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            getBalanceHeader(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor
                            )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "${selectedCurrency.symbol} ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: generateMoneyStyle(this.balance)
                                  ),
                                  children: [
                                    TextSpan(
                                        text: "${moneyFormat.format(this.balance)}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            color: generateMoneyStyle(this.balance)
                                        )
                                    ),
                                  ]
                              ),
                            ),
                            Text(
                                getBalanceDescription(),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFB6B6B6)
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.of(context).push(
                      PageRouteBuilder(
                        barrierColor: Colors.black.withOpacity(0.25),
                        barrierDismissible: true,
                        opaque: false,
                        pageBuilder: (_, __, ___) => Calculator(valueCurrencySymbol: this.selectedCurrency.symbol, header: getLimitHeader(), isDebt: false),
                      )
                  );
                  if(result != null) {
                    setState(() {
                      limit = result;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                    ),
                  ),
                  width: double.infinity,
                  height: 74,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            getLimitHeader(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor
                            )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "${selectedCurrency.symbol} ",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: generateLimitStyle(this.limit)
                                  ),
                                  children: [
                                    TextSpan(
                                        text: "${moneyFormat.format(this.limit)}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            color: generateLimitStyle(this.limit)
                                        )
                                    ),
                                  ]
                              ),
                            ),
                            Text(
                                getLimitDescription(),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFB6B6B6)
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  descriptionFocusNode.requestFocus();
                },
                child: Container(
                  height: 74,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                )
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              width: 200,
                              height: 14,
                              child: TextField(
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: const Color(0xFF4F4F4F)
                                ),
                                focusNode: descriptionFocusNode,
                                controller: descriptionController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                              ),
                            )

                          ],
                        ),
                        Text(
                            "Ex. Daily carry wallet",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFB6B6B6)
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isIncludedInTotalNet = !isIncludedInTotalNet;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                    ),
                  ),
                  width: double.infinity,
                  height: 74,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Include in Total Net",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF4F4F4F)
                                )
                            ),
                            Text(
                                "Balance added to total net worth",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFFB6B6B6)
                                )
                            ),
                          ],
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
                  ),
                ),
              ),
            ),
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () async {
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
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                    ),
                  ),
                  width: double.infinity,
                  height: 74,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Archive Account",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF4F4F4F)
                            )
                        ),
                        Text(
                            "Hide account and transactions",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFB6B6B6)
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Ink(
              color: Colors.white,
              child: InkWell(
                onTap: () async {
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
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[400].withOpacity((0.5)), width: 1)
                    ),
                  ),
                  width: double.infinity,
                  height: 74,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Delete Account",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFEB6467)
                            )
                        ),
                        Text(
                            "Permanently remove account and transactions",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFB6B6B6)
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
