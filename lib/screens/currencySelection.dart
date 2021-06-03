import 'package:flutter/material.dart';
import 'package:money_tracker/constants/Constants.dart';


class CurrencySelection extends StatefulWidget {
  const CurrencySelection({Key key}) : super(key: key);

  @override
  _CurrencySelectionState createState() => _CurrencySelectionState();
}

class _CurrencySelectionState extends State<CurrencySelection> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 350,
          height: 368,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child:  Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SizedBox(
                      height: 25,
                      child: Center(
                        child: Text(
                          "Select Account Icon",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: currencyList.map((currency) =>
                          Material(
                            color: Colors.white.withOpacity(0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context, currency);
                              },
                              splashColor: Theme.of(context).primaryColor.withOpacity(0.7),
                              child: Container(
                                height: 50,
                                padding: EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      currency.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400
                                      ),
                                    ),
                                    Text(
                                      currency.symbol,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                      ).toList()
                    ),
                  ),
                  SizedBox(height: 16.0)
                ]
            ),
          ),
        ),
    );
  }
}
