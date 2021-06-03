import 'package:flutter/material.dart';

enum Operator {
  addition,
  subtraction,
  multiplication,
  division,
  none
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  String firstValue = "";
  String secondValue = "";
  bool isDecimal = false;
  Operator operator = Operator.none;

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
    return Material(
      type: MaterialType.transparency,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: const Color(0xFFf6FBFB),
              width: double.infinity,
              height: 82,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Account Balance",
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
                    Navigator.pop(context, (this.firstValue == "") ? 0.0 : double.parse(this.firstValue));
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
