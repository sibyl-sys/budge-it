import 'package:flutter/material.dart';

class ImportanceToggleButton extends StatelessWidget {
  final bool selected;
  final Function onChange;
  final String text;
  final IconData icon;
  final Color color;

  ImportanceToggleButton(
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
      firstChild: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: color,
                  radius: 10,
                  child: Icon(icon, color: Colors.white, size: 14)),
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
              backgroundColor: color.withOpacity(0.06), side: BorderSide.none),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: color,
                  radius: 10,
                  child: Icon(icon, color: Colors.white, size: 14)),
              SizedBox(width: 4),
              Text(text,
                  style: TextStyle(
                      color: color, fontSize: 14, fontWeight: FontWeight.w500))
            ],
          ),
          onPressed: null),
    );
  }
}
