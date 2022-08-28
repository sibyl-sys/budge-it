import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:money_tracker/widgets/dateButton.dart';
import 'package:intl/intl.dart';

class DateRangeSelection extends StatefulWidget {
  final DateTime toDate;
  final DateTime fromDate;

  const DateRangeSelection({Key key, this.fromDate, this.toDate}) : super(key: key);

  @override
  _DateRangeSelectionState createState() => _DateRangeSelectionState();
}

class _DateRangeSelectionState extends State<DateRangeSelection> {

  bool compareDates(DateTime dateA, DateTime dateB) {
    return dateA.year == dateB.year && dateA.month == dateB.month && dateA.day == dateB.day;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));
    DateFormat dateFormatter = DateFormat('dd MMM');

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 350,
          height: 425,
          decoration: BoxDecoration(
              color: const Color(0xF2F2F2).withOpacity(1),
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
                          "Select Date Range",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DateButton(
                          icon: Icons.calendar_today,
                          header: "This Year",
                          subtitle: "None",
                          isActive: !(compareDates(widget.fromDate, DateTime(now.year, 1, 1)) && compareDates(widget.toDate, DateTime(now.year + 1, 1, 0))),
                          onTap: () {
                            Navigator.of(context).pop(
                                {
                                  "from" : DateTime(now.year, 1, 1),
                                  "to" : DateTime(now.year + 1, 1, 0)
                                }
                            );
                          },

                      ),
                      SizedBox(width: 16.0),
                      DateButton(
                          icon: Icons.calendar_view_month,
                          header: "This Month",
                          subtitle: "None",
                          isActive: !(compareDates(widget.fromDate, DateTime(now.year, now.month, 1)) && compareDates(widget.toDate, DateTime(now.year, now.month + 1, 0))),
                          onTap: () {
                            Navigator.of(context).pop(
                                {
                                  "from" : DateTime(now.year, now.month, 1),
                                  "to" : DateTime(now.year, now.month + 1, 0)
                                }
                            );
                          },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.white.withOpacity(0),
                          child: Ink(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            ),
                            child: InkWell(
                              onTap: () async {
                                var results = await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime(1990),
                                    lastDate: DateTime(2050),
                                    builder: (BuildContext context, Widget child) {
                                      return Theme(
                                        data: ThemeData.light(),
                                        child: child
                                      );
                                    },
                                );
                                if(results != null) {
                                  Navigator.of(context).pop(
                                      {"from": results.start,
                                      "to": results.end});
                                }
                              },
                              splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 16.0,
                                    bottom: 16.0
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                        Icons.calendar_today,
                                        size: 24
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                        "Select Day",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DateButton(
                        icon: Icons.mode_night_outlined,
                        header: "Yesterday",
                        subtitle: "${dateFormatter.format(yesterday)}",
                        isActive: !(compareDates(widget.fromDate, yesterday) && compareDates(widget.toDate, yesterday)),
                        onTap: () {
                          Navigator.of(context).pop({
                            "from" : yesterday,
                            "to" : yesterday
                          });
                        },
                      ),
                      SizedBox(width: 16.0),
                      DateButton(
                        icon: Icons.light_mode_outlined,
                        header: "Today",
                        subtitle: "${dateFormatter.format(now)}",
                        isActive: !(compareDates(widget.fromDate, now) && compareDates(widget.toDate, now)),
                        onTap: () {
                          Navigator.of(context).pop(
                              {
                                "from" : now,
                                "to" : now
                              }
                            );
                        },

                      ),
                    ],
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}
