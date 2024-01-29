import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final selected, onChange, childSelected, childUnselected, outlineColor;

  ToggleButton({this.childSelected, this.childUnselected, this.selected, this.onChange, this.outlineColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      crossFadeState: selected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: Container(
        width: double.infinity,
        child: ElevatedButton(
          child: childUnselected,
          onPressed: () {
            onChange();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white
          )
        ),
      ),
      secondChild: Container(
        width: double.infinity,
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: outlineColor,
                width: 1.5
              )
            ),
          child: childSelected,
          onPressed: null
        ),
      ),
    );
  }
}