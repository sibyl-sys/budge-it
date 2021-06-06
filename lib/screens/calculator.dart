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


  Widget generateIconButton(double width, double height, IconData icon, Color color, Color iconColor, Function onPressed) {
    return Container(
        width: width,
        height: height,
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

  Widget generateButton(double width, double height, String label, Color color, Color textColor, Function onPressed) {
    return Container(
        width: width,
        height: height,
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
    double baseButtonSize = MediaQuery.of(context).size.width / 5;

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
                  generateButton(baseButtonSize, baseButtonSize, "÷", const Color(0xFFFCFCFC), Colors.black,() {changeOperator(Operator.division);}),
                  generateButton(baseButtonSize, baseButtonSize, "7", Colors.white, Colors.black,(){addDigit("7");}),
                  generateButton(baseButtonSize, baseButtonSize, "8", Colors.white, Colors.black,(){addDigit("8");}),
                  generateButton(baseButtonSize, baseButtonSize, "9", Colors.white,Colors.black, (){addDigit("9");}),
                  generateIconButton(baseButtonSize, baseButtonSize, Icons.backspace_outlined, const Color(0xFFFCFCFC), Colors.black, eraseDigit),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  generateButton(baseButtonSize, baseButtonSize, "x", const Color(0xFFFCFCFC), Colors.black, (){changeOperator(Operator.multiplication);}),
                  generateButton(baseButtonSize, baseButtonSize, "4", Colors.white, Colors.black,(){addDigit("4");}),
                  generateButton(baseButtonSize, baseButtonSize, "5", Colors.white, Colors.black,(){addDigit("5");}),
                  generateButton(baseButtonSize, baseButtonSize, "6", Colors.white, Colors.black,(){addDigit("6");}),
                  generateButton(baseButtonSize, baseButtonSize, "±", const Color(0xFFFCFCFC), Colors.black,(){changeNumberSign();}),
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
                          generateButton(baseButtonSize, baseButtonSize, "-", const Color(0xFFFCFCFC), Colors.black, (){changeOperator(Operator.subtraction);}),
                          generateButton(baseButtonSize, baseButtonSize, "1", Colors.white,Colors.black, (){addDigit("1");}),
                          generateButton(baseButtonSize, baseButtonSize, "2", Colors.white,Colors.black, (){addDigit("2");}),
                          generateButton(baseButtonSize, baseButtonSize, "3", Colors.white, Colors.black,(){addDigit("3");}),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          generateButton(baseButtonSize, baseButtonSize, "+", const Color(0xFFFCFCFC), Colors.black,(){changeOperator(Operator.addition);}),
                          generateButton(baseButtonSize * 2, baseButtonSize, "0", Colors.white, Colors.black,(){addDigit("0");}),
                          generateButton(baseButtonSize, baseButtonSize, ".", Colors.white, Colors.black, (){addDigit(".");}),
                        ],
                      ),
                    )
                  ],
                ),
                (operator == Operator.none) ?
                  generateIconButton(baseButtonSize, baseButtonSize * 2, Icons.done, Theme.of(context).primaryColor, Colors.white, (){
                    Navigator.pop(context, (this.firstValue == "") ? 0.0 : double.parse(this.firstValue));
                  }) :
                    generateButton(baseButtonSize, baseButtonSize * 2, "=", Theme.of(context).primaryColor, Colors.white, (){changeOperator(Operator.none);})
              ],
            ),
          ],
        ),
      ),
    );
  }
}
