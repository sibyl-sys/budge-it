import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final bool selected;
  final Function onChange;
  final String text;
  final IconData icon;
  final Color color;

  ToggleButton(
      {required this.selected,
      required this.onChange,
      required this.text,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      crossFadeState:
          selected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: OutlinedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              side: BorderSide(color: color, width: 1.5)),
          child: Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: 4),
              Text(text,
                  style: TextStyle(
                      color: color, fontSize: 14, fontWeight: FontWeight.w500))
            ],
          ),
          onPressed: () {
            onChange();
          }),
      secondChild: OutlinedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              side: BorderSide(color: color, width: 1.5)),
          child: Row(
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 4),
              Text(text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500))
            ],
          ),
          onPressed: null),
    );
  }
}
