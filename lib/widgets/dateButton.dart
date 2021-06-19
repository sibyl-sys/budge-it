import 'package:flutter/material.dart';

class DateButton extends StatefulWidget {
  final IconData icon;
  final String header;
  final String subtitle;
  final bool isActive;
  final Function onTap;

  const DateButton({Key key, this.icon, this.header, this.subtitle, this.isActive, this.onTap}) : super(key: key);

  @override
  _DateButtonState createState() => _DateButtonState();
}

class _DateButtonState extends State<DateButton> {

  Widget renderDisabledButton(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
            top: 16.0,
            bottom: 16.0
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 24,
              color: Colors.white
            ),
            SizedBox(height: 8.0),
            Text(
                widget.header,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.white
                )
            ),
            SizedBox(height: 4.0),
            Text(
                widget.subtitle,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.grey
                )
            )
          ],
        ),
      ),
    );
  }

  Widget renderActiveButton() {
    return Expanded(
      child: Material(
        color: Colors.white.withOpacity(0),
        child: Ink(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          child: InkWell(
            splashColor: Theme.of(context).primaryColor.withOpacity(0.5),
            borderRadius: BorderRadius.all(Radius.circular(5)),
            onTap: widget.onTap,
            child: Container(
              padding: EdgeInsets.only(
                  top: 16.0,
                  bottom: 16.0
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      widget.icon,
                      size: 24
                  ),
                  SizedBox(height: 8.0),
                  Text(
                      widget.header,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16
                      )
                  ),
                  SizedBox(height: 4.0),
                  Text(
                      widget.subtitle,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.grey
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isActive ? renderActiveButton() : renderDisabledButton(context);
  }
}
