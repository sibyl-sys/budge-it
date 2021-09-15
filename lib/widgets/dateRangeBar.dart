import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/screens/dateRangeSelection.dart';


enum DateRangeType {
  YEARLY,
  MONTHLY,
  DAILY,
  IRREGULAR
}

class DateRangeBar extends StatefulWidget {

  final DateTime from;
  final DateTime to;
  final Function onChanged;

  const DateRangeBar({Key key, this.from, this.to, this.onChanged}) : super(key: key);

  @override
  _DateRangeBarState createState() => _DateRangeBarState();
}

class _DateRangeBarState extends State<DateRangeBar> {

  getDateRangeType() {
    if(widget.from.month == 1 && widget.from.day == 1 && widget.from.year == widget.to.year && widget.to.month == 12 && widget.to.day == 31) {
      return DateRangeType.YEARLY;
    } else if(widget.from.month == widget.to.month && widget.from.day == 1 && widget.from.year == widget.to.year && widget.to.day == DateTime(widget.from.year, widget.from.month + 1, 0).day) {
      return DateRangeType.MONTHLY;
    } else if(widget.from.compareTo(widget.to) == 0) {
      return DateRangeType.DAILY;
    } else {
      return DateRangeType.IRREGULAR;
    }
  }

  getDateRangeText() {
    DateRangeType type = getDateRangeType();
    if(type == DateRangeType.YEARLY) {
      return widget.from.year.toString();
    } else if(type == DateRangeType.MONTHLY){
      return DateFormat.yMMMM().format(widget.from);
    } else if(type == DateRangeType.DAILY) {
      return DateFormat.yMMMMd().format(widget.from);
    } else {
      return DateFormat.yMMMMd().format(widget.from) + " - " + DateFormat.yMMMMd().format(widget.to);
    }
  }

  next() {
    DateRangeType type = getDateRangeType();

    if(type == DateRangeType.YEARLY) {
      widget.onChanged({
        "from": DateTime(widget.from.year + 1, widget.from.month, widget.from.day),
        "to": DateTime(widget.to.year + 1, widget.to.month, widget.to.day)
      });
    } else if (type == DateRangeType.MONTHLY) {
      widget.onChanged({
        "from": DateTime(widget.from.year, widget.from.month + 1, widget.from.day),
        "to": DateTime(widget.from.year, widget.from.month + 2, 0)
      });
    }  else if (type ==DateRangeType.DAILY) {
      widget.onChanged({
        "from": DateTime(widget.from.year, widget.from.month, widget.from.day + 1),
        "to": DateTime(widget.to.year, widget.to.month, widget.to.day + 1)
      });
    }
  }

  previous() {
    DateRangeType type = getDateRangeType();

    if(type == DateRangeType.YEARLY) {
      widget.onChanged({
        "from": DateTime(widget.from.year - 1, widget.from.month, widget.from.day),
        "to": DateTime(widget.to.year - 1, widget.to.month, widget.to.day)
      });
    } else if (type ==DateRangeType.MONTHLY) {
      widget.onChanged({
        "from": DateTime(widget.from.year, widget.from.month - 1, widget.from.day),
        "to": DateTime(widget.from.year, widget.from.month, 0)
      });
    }  else if (type ==DateRangeType.DAILY) {
      widget.onChanged({
        "from": DateTime(widget.from.year, widget.from.month, widget.from.day - 1),
        "to": DateTime(widget.to.year, widget.to.month, widget.to.day - 1)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
        child: InkWell(
          splashColor:  Colors.teal[700].withAlpha(50),
          onTap: () async {
            var results = await Navigator.of(context).push(
                PageRouteBuilder(
                  barrierColor: Colors.black.withOpacity(0.25),
                  barrierDismissible: true,
                  opaque: false,
                  pageBuilder: (_, __, ___) => DateRangeSelection(toDate:  widget.to, fromDate: widget.from),
                )
            );
            widget.onChanged(results);
          },
          child: Container(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: Icon(Icons.chevron_left, color: Theme.of(context).primaryColor), onPressed: previous),
                Row(
                  children: [
                    Icon(
                        Icons.calendar_today,
                        size: 14
                    ),
                    SizedBox(width: 8),
                    Text(getDateRangeText(),
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13.2
                        )),
                  ],
                ),
                IconButton(icon: Icon(Icons.chevron_right, color: Theme.of(context).primaryColor), onPressed: next)
              ],
            ),
          ),
        )
    );
  }
}
