import 'package:flutter/material.dart';
import 'package:money_tracker/screens/accountSelection.dart';
import 'package:money_tracker/screens/dateSelection.dart';
import 'package:money_tracker/screens/recipientSelection.dart';
import 'package:money_tracker/services/category.dart';
import 'package:money_tracker/services/transaction.dart';
import 'package:money_tracker/services/user.dart';
import 'package:money_tracker/widgets/toggleButton.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

enum Operator { addition, subtraction, multiplication, division, none }

class AddTransaction extends StatefulWidget {
  final String initialValue;

  const AddTransaction({Key? key, this.initialValue = ""}) : super(key: key);

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

//TODO GENERATE FONT COLOR DEPENDING ON TRANSACTION TYPE

class _AddTransactionState extends State<AddTransaction> {
  String firstValue = "";
  String secondValue = "";
  bool isDecimal = false;
  Operator operator = Operator.none;
  DateTime currentDate = DateTime.now();
  DateFormat dateFormatter = DateFormat('EEEE, MMMM dd, yyyy');
  int subcategoryID = -1;

  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    notesController.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != "") {
      setState(() {
        firstValue = widget.initialValue;
      });
    }
  }

  void eraseDigit() {
    if (operator == Operator.none) {
      setState(() {
        firstValue = firstValue.substring(0, firstValue.length - 1);
      });
    } else {
      if (secondValue == "") {
        setState(() {
          operator = Operator.none;
        });
      } else {}
      setState(() {
        secondValue = secondValue.substring(0, secondValue.length - 1);
      });
    }
  }

  void changeNumberSign() {
    if (secondValue == "") {
      setState(() {
        firstValue =
            pruneDecimalPlaces((double.parse(firstValue) * -1).toString());
      });
    } else {
      setState(() {
        secondValue =
            pruneDecimalPlaces((double.parse(secondValue) * -1).toString());
      });
    }
  }

  String getToLabel(TransactionType transactionType) {
    if (transactionType == TransactionType.expense) {
      return "To Expense";
    } else if (transactionType == TransactionType.income) {
      return "To Income";
    } else {
      return "To Account";
    }
  }

  String getValueLabel(TransactionType transactionType) {
    if (transactionType == TransactionType.expense) {
      return "Expense";
    } else if (transactionType == TransactionType.income) {
      return "Income";
    } else {
      return "Transfer";
    }
  }

  String getTextDisplay() {
    if (firstValue == "") {
      return "0";
    }
    switch (operator) {
      case Operator.addition:
        return firstValue + " + " + secondValue;
      case Operator.subtraction:
        return firstValue + " - " + secondValue;
      case Operator.multiplication:
        return firstValue + " x " + secondValue;
      case Operator.division:
        return firstValue + " ÷ " + secondValue;
      default:
        return firstValue;
    }
  }

  void addDigit(String digit) {
    if (operator == Operator.none) {
      if (digit == "." && firstValue.contains(".")) {
        return;
      }
      setState(() {
        firstValue += digit;
      });
    } else {
      if (digit == "." && secondValue.contains(".")) {
        return;
      }
      setState(() {
        secondValue += digit;
      });
    }
  }

  String pruneDecimalPlaces(String valueString) {
    if (double.parse(valueString) % 1 == 0) {
      return valueString.split(".")[0];
    } else {
      return valueString;
    }
  }

  void executeOperator() {
    switch (operator) {
      case Operator.addition:
        setState(() {
          firstValue = pruneDecimalPlaces(
              (double.parse(firstValue) + double.parse(secondValue))
                  .toString());
          secondValue = "";
        });
        break;
      case Operator.subtraction:
        setState(() {
          firstValue = pruneDecimalPlaces(
              (double.parse(firstValue) - double.parse(secondValue))
                  .toString());
          secondValue = "";
        });
        break;
      case Operator.multiplication:
        setState(() {
          firstValue = pruneDecimalPlaces(
              (double.parse(firstValue) * double.parse(secondValue))
                  .toString());
          secondValue = "";
        });
        break;
      case Operator.division:
        setState(() {
          firstValue = pruneDecimalPlaces(
              (double.parse(firstValue) / double.parse(secondValue))
                  .toString());
          secondValue = "";
        });
        break;
      default:
        break;
    }
  }

  void changeOperator(Operator newOperator) {
    if (secondValue != "") {
      executeOperator();
    }
    setState(() {
      operator = newOperator;
      isDecimal = false;
    });
  }

  Widget generateIconButton(double width, double height, IconData icon,
      Color color, Color iconColor, Function() onPressed) {
    return Container(
        width: width,
        height: height,
        child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
                backgroundColor: color,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(
                        color: Colors.grey.shade400.withOpacity(0.25),
                        width: 0.5,
                        style: BorderStyle.solid))),
            child: Icon(
              icon,
              color: iconColor,
              size: 36,
            )));
  }

  Widget generateButton(double width, double height, String label, Color color,
      Color textColor, Function() onPressed) {
    return Container(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
              backgroundColor: color,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(
                      color: Colors.grey.shade400.withOpacity(0.25),
                      width: 1,
                      style: BorderStyle.solid))),
          child: Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 36, color: textColor),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    Category? category;
    TransactionType transactionType =
        user.mySettings.getSelectedTransactionType();
    double baseButtonSize = MediaQuery.of(context).size.width / 5;

    TransactionImportance transactionImportance = user
                .findCategoryByID(user.mySettings.selectedCategoryTo)!
                .lastTransactionImportance ==
            null
        ? TransactionImportance.need
        : user
            .findCategoryByID(user.mySettings.selectedCategoryTo)!
            .lastTransactionImportance!;

    if (transactionType != TransactionType.transfer) {
      category = user.findCategoryByID(user.mySettings.selectedCategoryTo);
    }

    return Material(
      type: MaterialType.transparency,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(children: [
              Expanded(
                child: Ink(
                  color: Color(user
                          .findAccountByID(user.mySettings.selectedAccountFrom)!
                          .color)
                      .withOpacity(1),
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.5),
                    onTap: () async {
                      final result =
                          await Navigator.of(context).push(PageRouteBuilder(
                        barrierColor: Colors.black.withOpacity(0.25),
                        barrierDismissible: true,
                        opaque: false,
                        pageBuilder: (_, __, ___) => AccountSelection(),
                      ));
                      if (result != null) {
                        user.selectAccountFrom(result["accountID"]);
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0.0, 4.0, 16.0, 4.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white)),
                        height: 60,
                        child: Stack(children: [
                          Positioned(
                            left: -4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                      IconData(
                                          user
                                              .findAccountByID(user.mySettings
                                                  .selectedAccountFrom)!
                                              .icon,
                                          fontFamily: 'MaterialIcons'),
                                      color: Colors.white.withOpacity(0.3),
                                      size: 50),
                                ]),
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 55),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("From Account",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10)),
                                        Text(
                                          user
                                              .findAccountByID(user.mySettings
                                                  .selectedAccountFrom)!
                                              .name,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ]),
                                ),
                              ]),
                        ])),
                  ),
                ),
              ),
              Expanded(
                child: Ink(
                  color: Color(transactionType != TransactionType.transfer
                          ? user
                              .findCategoryByID(
                                  user.mySettings.selectedCategoryTo)!
                              .color
                          : user
                              .findAccountByID(
                                  user.mySettings.selectedAccountTo)!
                              .color)
                      .withOpacity(1),
                  child: InkWell(
                    splashColor: Colors.white.withOpacity(0.5),
                    onTap: () async {
                      final results =
                          await Navigator.of(context).push(PageRouteBuilder(
                        barrierColor: Colors.black.withOpacity(0.25),
                        barrierDismissible: true,
                        opaque: false,
                        pageBuilder: (_, __, ___) => RecipientSelection(),
                      ));
                      if (results != null) {
                        user.selectRecipient(
                            results["recipientID"], results["transactionType"]);
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0.0, 4.0, 16.0, 4.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white)),
                        height: 60,
                        child: Stack(children: [
                          Positioned(
                            left: -4,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                      IconData(
                                          transactionType !=
                                                  TransactionType.transfer
                                              ? user
                                                  .findCategoryByID(user
                                                      .mySettings
                                                      .selectedCategoryTo)!
                                                  .icon
                                              : user
                                                  .findAccountByID(user
                                                      .mySettings
                                                      .selectedAccountTo)!
                                                  .icon,
                                          fontFamily: 'MaterialIcons'),
                                      color: Colors.white.withOpacity(0.3),
                                      size: 50),
                                ]),
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 55),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(getToLabel(transactionType),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10)),
                                        Text(
                                          transactionType !=
                                                  TransactionType.transfer
                                              ? user
                                                  .findCategoryByID(user
                                                      .mySettings
                                                      .selectedCategoryTo)!
                                                  .name
                                              : user
                                                  .findAccountByID(user
                                                      .mySettings
                                                      .selectedAccountTo)!
                                                  .name,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ]),
                                ),
                              ]),
                        ])),
                  ),
                ),
              ),
            ]),
            transactionType != TransactionType.transfer &&
                    category != null &&
                    category.subcategories.length > 0
                ? Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: category.subcategories
                            .map(
                              (element) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ToggleButton(
                                    onChange: () {
                                      setState(() {
                                        subcategoryID = element.id;
                                      });
                                    },
                                    selected: subcategoryID == element.id,
                                    color: Color(category!.color),
                                    text: element!.name,
                                    icon: IconData(element.icon,
                                        fontFamily: "MaterialIcons")),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  )
                : Spacer(),
            Container(
                color: const Color(0xFBFBFBFF),
                width: double.infinity,
                height: baseButtonSize,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(getValueLabel(transactionType),
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          )),
                      SizedBox(height: 8.0),
                      Text(getTextDisplay(),
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor))
                    ])),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Colors.grey.shade400.withOpacity(0.25),
                      width: 1.0),
                ),
                color: Colors.white,
              ),
              child: TextField(
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color(0xFF4F4F4F)),
                textAlign: TextAlign.center,
                controller: notesController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    isDense: true,
                    border: InputBorder.none,
                    hintText: "Add Notes...",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: const Color(0xFFBDBDBD))),
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  generateButton(baseButtonSize, baseButtonSize, "÷",
                      const Color(0xFFFCFCFC), Colors.black, () {
                    changeOperator(Operator.division);
                  }),
                  generateButton(baseButtonSize, baseButtonSize, "7",
                      Colors.white, Colors.black, () {
                    addDigit("7");
                  }),
                  generateButton(baseButtonSize, baseButtonSize, "8",
                      Colors.white, Colors.black, () {
                    addDigit("8");
                  }),
                  generateButton(baseButtonSize, baseButtonSize, "9",
                      Colors.white, Colors.black, () {
                    addDigit("9");
                  }),
                  generateIconButton(
                      baseButtonSize,
                      baseButtonSize,
                      Icons.backspace_outlined,
                      const Color(0xFFFCFCFC),
                      Colors.black,
                      eraseDigit),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  generateButton(baseButtonSize, baseButtonSize, "x",
                      const Color(0xFFFCFCFC), Colors.black, () {
                    changeOperator(Operator.multiplication);
                  }),
                  generateButton(baseButtonSize, baseButtonSize, "4",
                      Colors.white, Colors.black, () {
                    addDigit("4");
                  }),
                  generateButton(baseButtonSize, baseButtonSize, "5",
                      Colors.white, Colors.black, () {
                    addDigit("5");
                  }),
                  generateButton(baseButtonSize, baseButtonSize, "6",
                      Colors.white, Colors.black, () {
                    addDigit("6");
                  }),
                  generateIconButton(
                      baseButtonSize,
                      baseButtonSize,
                      Icons.camera_alt_outlined,
                      const Color(0xFFFCFCFC),
                      Colors.black,
                      () {}),
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
                          generateButton(baseButtonSize, baseButtonSize, "-",
                              const Color(0xFFFCFCFC), Colors.black, () {
                            changeOperator(Operator.subtraction);
                          }),
                          generateButton(baseButtonSize, baseButtonSize, "1",
                              Colors.white, Colors.black, () {
                            addDigit("1");
                          }),
                          generateButton(baseButtonSize, baseButtonSize, "2",
                              Colors.white, Colors.black, () {
                            addDigit("2");
                          }),
                          generateButton(baseButtonSize, baseButtonSize, "3",
                              Colors.white, Colors.black, () {
                            addDigit("3");
                          }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          generateButton(baseButtonSize, baseButtonSize, "+",
                              const Color(0xFFFCFCFC), Colors.black, () {
                            changeOperator(Operator.addition);
                          }),
                          generateButton(baseButtonSize * 2, baseButtonSize,
                              "0", Colors.white, Colors.black, () {
                            addDigit("0");
                          }),
                          generateButton(baseButtonSize, baseButtonSize, ".",
                              Colors.white, Colors.black, () {
                            addDigit(".");
                          }),
                        ],
                      ),
                    )
                  ],
                ),
                (operator == Operator.none)
                    ? generateIconButton(
                        baseButtonSize,
                        baseButtonSize * 2,
                        Icons.done,
                        Theme.of(context).primaryColor,
                        Colors.white, () {
                        User userModel = context.read<User>();
                        print(transactionType);
                        userModel.addTransaction(Transaction(
                            value: double.parse(this.firstValue),
                            note: notesController.text,
                            fromID: user.mySettings.selectedAccountFrom,
                            toID: transactionType == TransactionType.transfer
                                ? user.mySettings.selectedAccountTo
                                : user.mySettings.selectedCategoryTo,
                            timestamp: currentDate,
                            transactionType: transactionType,
                            isArchived: false,
                            importance: transactionImportance,
                            subcategoryID: subcategoryID));
                        Navigator.pop(context);
                      })
                    : generateButton(baseButtonSize, baseButtonSize * 2, "=",
                        Theme.of(context).primaryColor, Colors.white, () {
                        changeOperator(Operator.none);
                      })
              ],
            ),
            TextButton(
                onPressed: () async {
                  var results =
                      await Navigator.of(context).push(PageRouteBuilder(
                    barrierColor: Colors.black.withOpacity(0.25),
                    barrierDismissible: true,
                    opaque: false,
                    pageBuilder: (_, __, ___) =>
                        DateSelection(currentDate: this.currentDate),
                  ));
                  if (results != null) {
                    setState(() {
                      currentDate = results["currentDate"];
                    });
                  }
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.all(16), backgroundColor: Colors.white),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.date_range,
                        color: Theme.of(context).primaryColor,
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(dateFormatter.format(currentDate).toUpperCase(),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500))
                    ]))
          ],
        ),
      ),
    );
  }
}
