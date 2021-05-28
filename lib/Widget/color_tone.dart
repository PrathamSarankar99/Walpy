import 'package:flutter/material.dart';
import 'package:walpy/Modals/AvailableColors.dart';

class ColorTone extends StatelessWidget {
  final String color;
  final Function(String) onPressed;
  const ColorTone({Key key, @required this.color, @required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 55,
      child: TextButton(
        onPressed: () {
          onPressed(color);
        },
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            backgroundColor:
                MaterialStateProperty.all(AvailableColors.colorForCode[color]),
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ))),
        child: Container(),
      ),
    );
  }
}
