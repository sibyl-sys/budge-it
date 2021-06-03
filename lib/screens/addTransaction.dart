import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_tracker/screens/accountSelection.dart';
import 'package:money_tracker/screens/categorySelection.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:provider/provider.dart';

enum Operator {
  addition,
  subtraction,
  multiplication,
  division,
  none
}

class AddTransaction extends StatefulWidget {


  @override
  _AddTransactionState createState() => _AddTransactionState();
}

//TODO GENERATE FONT COLOR DEPENDING ON TRANSACTION TYPE

class _AddTransactionState extends State<AddTransaction> {

  String firstValue = "";
  String secondValue = "";
  bool isDecimal = false;
  Operator operator = Operator.none;


  final TextEditingController notesController = TextEditingController();


  void eraseDigit() {
    if(operator == Operator.none) {
      setState(() {
        firstValue = firstValue.substring(0, firstValue.length - 1);
      });
    } else {
      if(secondValue == "") {
        setState(() {
          operator = Operator.none;
        });
      } else {

      }
      setState(() {
        secondValue = secondValue.substring(0, secondValue.length - 1);
      });
    }
  }

  void changeNumberSign () {
    if(secondValue == "") {
      setState(() {
        firstValue = pruneDecimalPlaces((double.parse(firstValue) * -1).toString());
      });
    } else {
      setState(() {
        secondValue = pruneDecimalPlaces((double.parse(secondValue) * -1).toString());
      });
    }
  }

  String getTextDisplay() {
    if(firstValue == "") {
      return "0";
    }
    switch(operator) {
      case Operator.addition:
        return firstValue + " + " + secondValue;
        break;
      case Operator.subtraction:
        return firstValue + " - " + secondValue;
        break;
      case Operator.multiplication:
        return firstValue + " x " + secondValue;
        break;
      case Operator.division:
        return firstValue + " ÷ " + secondValue;
        break;
      default:
        return firstValue;
    }
  }

  void addDigit(String digit) {
    if(operator == Operator.none) {
      if(digit == "." && firstValue.contains(".")) {
        return;
      }
      setState(() {
        firstValue+=digit;
      });
    } else {
      if(digit == "." && secondValue.contains(".")) {
        return;
      }
      setState(() {
        secondValue+=digit;
      });
    }
  }

  String pruneDecimalPlaces(String valueString) {
    if(double.parse(valueString) % 1 == 0) {
      return valueString.split(".")[0];
    } else {
      return valueString;
    }
  }

  void executeOperator() {
    switch(operator) {
      case Operator.addition:
        setState(() {
          firstValue = pruneDecimalPlaces((double.parse(firstValue) + double.parse(secondValue)).toString());
          secondValue = "";
        });
        break;
      case Operator.subtraction:
        setState(() {
          firstValue = pruneDecimalPlaces((double.parse(firstValue) - double.parse(secondValue)).toString());
          secondValue = "";
        });
        break;
      case Operator.multiplication:
        setState(() {
          firstValue = pruneDecimalPlaces((double.parse(firstValue) * double.parse(secondValue)).toString());
          secondValue = "";
        });
        break;
      case Operator.division:
        setState(() {
          firstValue = pruneDecimalPlaces((double.parse(firstValue) / double.parse(secondValue)).toString());
          secondValue = "";
        });
        break;
    }
  }

  void changeOperator(Operator newOperator) {
    if(secondValue != "") {
      executeOperator();
    }
    setState(() {
      operator = newOperator;
      isDecimal = false;
    });
  }


  Widget generateIconButton(int widthMultiplier, int heightMultiplier, IconData icon, Color color, Color iconColor, Function onPressed) {
    return Container(
        width: 82.0 * widthMultiplier,
        height: 82.0 * heightMultiplier,
        child: FlatButton(
          height: 82,
          onPressed: onPressed,
          color: color,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(
                  color: Colors.grey[400].withOpacity(0.25),
                  width: 1,
                  style: BorderStyle.solid
              )
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 36,
          )
        )
    );
  }

  Widget generateButton(int widthMultiplier, int heightMultiplier, String label, Color color, Color textColor, Function onPressed) {
    return Container(
        width: 82.0 * widthMultiplier,
        height: 82.0 * heightMultiplier,
        child: FlatButton(
          height: 82,
          onPressed: onPressed,
          color: color,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(
              color: Colors.grey[400].withOpacity(0.25),
              width: 1,
              style: BorderStyle.solid
            )
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 36,
              color: textColor
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    final user = context.watch<User>();

    TransactionType transactionType = user.findCategoryByID(user.lastSelectedCategory).categoryType == CategoryType.expense ? TransactionType.expense : TransactionType.income;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15.0)
                ),
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  "Expense Details",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    fontSize: 14
                  )
                ),
              ),
            ),
            //TODO ADD INKWELL TO CONTAINERS
            Row(
              children: [
                Expanded(
                  child: Ink(
                    color: Color(user.findAccountByID(user.lastSelectedAccount).color).withOpacity(1),
                    child: InkWell(
                      splashColor: Colors.white.withOpacity(0.5),
                      onTap: () async {
                          final result = await Navigator.of(context).push(
                            PageRouteBuilder(
                              barrierColor: Colors.black.withOpacity(0.25),
                              barrierDismissible: true,
                              opaque: false,
                              pageBuilder: (_, __, ___) => AccountSelection(),
                            ));
                            if(result != null) {
                              user.selectAccount(result["accountID"]);
                            }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        height: 75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "From Account",
                                style: TextStyle(
                                  color: Colors.white
                                )
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                Icon(
                                    IconData(user.findAccountByID(user.lastSelectedAccount).icon, fontFamily: 'MaterialIcons'),
                                    color: Colors.white,
                                    size: 32
                                ),
                                SizedBox(width: 8.0),
                                Flexible(
                                  child: Text(
                                    user.findAccountByID(user.lastSelectedAccount).name,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ]
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Ink(
                    color: Color(user.findCategoryByID(user.lastSelectedCategory).color).withOpacity(1),
                    child: InkWell(
                      onTap: () async {
                        final results = await Navigator.of(context).push(
                            PageRouteBuilder(
                              barrierColor: Colors.black.withOpacity(0.25),
                              barrierDismissible: true,
                              opaque: false,
                              pageBuilder: (_, __, ___) => CategorySelection(),
                            )
                        );
                        if(results != null) {
                          user.selectCategory(results["categoryID"]);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        height: 75,
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  transactionType == TransactionType.expense ? "To Expense" : "To Income",
                                  style: TextStyle(
                                      color: Colors.white
                                  )
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                  children: [
                                    Icon(
                                        IconData(user.findCategoryByID(user.lastSelectedCategory).icon, fontFamily: 'MaterialIcons'),
                                        color: Colors.white,
                                        size: 32
                                    ),
                                    SizedBox(width: 8.0),
                                    Flexible(
                                      child: Text(
                                          user.findCategoryByID(user.lastSelectedCategory).name,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500
                                          ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ]
                              )
                            ],
                          ),
                      ),
                    ),
                  ),
                )
              ]
            ),
            Container(
              color: const Color(0xFFf6FBFB),
              width: double.infinity,
              height: 82,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Expense",
                    style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,

                    )
                  ),
                  SizedBox(
                    height: 8.0
                  ),
                  Text(
                      getTextDisplay(),
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor
                      )
                  )
                ]
              )
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[400].withOpacity(0.25), width: 1.0),
                ),
                color: Colors.white,
              ),
              child: TextField(
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color(0xFF4F4F4F)
                ),
                textAlign: TextAlign.center,
                controller: notesController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12.0) ,
                    isDense: true,
                    border: InputBorder.none,
                    hintText: "Notes...",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: const Color(0xFFBDBDBD)
                    )
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  generateButton(1, 1, "÷", const Color(0xFFFCFCFC), Colors.black,() {changeOperator(Operator.division);}),
                  generateButton(1, 1, "7", Colors.white, Colors.black,(){addDigit("7");}),
                  generateButton(1, 1, "8", Colors.white, Colors.black,(){addDigit("8");}),
                  generateButton(1, 1, "9", Colors.white,Colors.black, (){addDigit("9");}),
                  generateIconButton(1, 1, Icons.backspace_outlined, const Color(0xFFFCFCFC), Colors.black, eraseDigit),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  generateButton(1, 1, "x", const Color(0xFFFCFCFC), Colors.black, (){changeOperator(Operator.multiplication);}),
                  generateButton(1, 1, "4", Colors.white, Colors.black,(){addDigit("4");}),
                  generateButton(1, 1, "5", Colors.white, Colors.black,(){addDigit("5");}),
                  generateButton(1, 1, "6", Colors.white, Colors.black,(){addDigit("6");}),
                  generateButton(1, 1, "±", const Color(0xFFFCFCFC), Colors.black,(){changeNumberSign();}),
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          generateButton(1, 1, "-", const Color(0xFFFCFCFC), Colors.black, (){changeOperator(Operator.subtraction);}),
                          generateButton(1, 1, "1", Colors.white,Colors.black, (){addDigit("1");}),
                          generateButton(1, 1, "2", Colors.white,Colors.black, (){addDigit("2");}),
                          generateButton(1, 1, "3", Colors.white, Colors.black,(){addDigit("3");}),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          generateButton(1, 1, "+", const Color(0xFFFCFCFC), Colors.black,(){changeOperator(Operator.addition);}),
                          generateButton(2, 1, "0", Colors.white, Colors.black,(){addDigit("0");}),
                          generateButton(1, 1, ".", Colors.white, Colors.black, (){addDigit(".");}),
                        ],
                      ),
                    )
                  ],
                ),
                (operator == Operator.none) ?
                  generateIconButton(1, 2, Icons.done, Theme.of(context).primaryColor, Colors.white, (){
                    User userModel = context.read<User>();
                    userModel.addTransaction(
                      Transaction(
                        value: double.parse(this.firstValue),
                        note: notesController.text,
                        accountID: user.lastSelectedAccount,
                        categoryID: user.lastSelectedCategory,
                        transactionID: userModel.transactions.length,
                        timestamp: DateTime.now(),
                        transactionType: transactionType
                      )
                    );
                    Navigator.pop(context);
                  }) :
                    generateButton(1, 2, "=", Theme.of(context).primaryColor, Colors.white, (){changeOperator(Operator.none);})
              ],
            ),
          ],
        ),
      ),
    );
  }
}
