import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/screens/calculator.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class SetBudget extends StatefulWidget {
  final String currencySymbol;
  const SetBudget({super.key, required this.currencySymbol});

  @override
  State<SetBudget> createState() => _SetBudgetState();
}

class _SetBudgetState extends State<SetBudget> {
  final DateFormat dateFormatter = DateFormat("MMM y", "en_us");
  final moneyFormat = new NumberFormat("#,##0.00", "en_US");

  DateTime schedule = DateTime.now();
  bool isRepeatedAllYear = false;
  double budget = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Center(
            child: Container(
          width: 350,
          height: 300,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            children: [
              Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.withOpacity(0.5),
                              width: 2.0))),
                  child: Center(
                      child: Text("Allocate Budget",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          )))),
              Ink(
                color: Colors.white,
                child: InkWell(
                  onTap: () async {
                    final result = await showMonthPicker(
                      context: context,
                      selectedMonthBackgroundColor:
                          Theme.of(context).primaryColor,
                      selectedMonthTextColor: Colors.white,
                    );
                    if (result != null) {
                      setState(() {
                        schedule = result;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade400.withOpacity((0.5)),
                              width: 1)),
                    ),
                    width: double.infinity,
                    height: 74,
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Schedule",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColor)),
                          Text(
                            dateFormatter.format(schedule),
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4F4F4F)),
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
                      isRepeatedAllYear = !isRepeatedAllYear;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade400.withOpacity((0.5)),
                              width: 1)),
                    ),
                    width: double.infinity,
                    height: 74,
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Repeat All Year",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF4F4F4F))),
                              Text("Set budget each month for the year",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFB6B6B6))),
                            ],
                          ),
                          SizedBox(
                            width: 60,
                            child: Switch(
                              onChanged: (bool isOn) {
                                setState(() {
                                  isRepeatedAllYear = isOn;
                                });
                              },
                              value: isRepeatedAllYear,
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
                    final result =
                        await Navigator.of(context).push(PageRouteBuilder(
                      barrierColor: Colors.black.withOpacity(0.25),
                      barrierDismissible: true,
                      opaque: false,
                      pageBuilder: (_, __, ___) => Calculator(
                          valueCurrencySymbol: widget.currencySymbol,
                          header: "Budget",
                          isDebt: false),
                    ));
                    if (result != null) {
                      setState(() {
                        budget = result;
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade400.withOpacity((0.5)),
                              width: 1)),
                    ),
                    width: double.infinity,
                    height: 74,
                    child: Padding(
                      padding:
                          const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Budget",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColor)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                    text: widget.currencySymbol,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF55C9C6)),
                                    children: [
                                      TextSpan(
                                          text: "${moneyFormat.format(budget)}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF55C9C6))),
                                    ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("CANCEL",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          "schedule": schedule,
                          "isRepeatedAllYear": isRepeatedAllYear,
                          "budget": budget
                        });
                      },
                      child: Text("DONE",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor)),
                    )
                  ])
            ],
          ),
        )));
  }
}
