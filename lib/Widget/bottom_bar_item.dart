import 'package:flutter/material.dart';

class BottomBarItem extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final Function(int) onTap;
  const BottomBarItem(
      {Key key,
      @required this.index,
      @required this.selectedIndex,
      @required this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            shape: MaterialStateProperty.all(const CircleBorder())),
        onPressed: () {
          onTap(index);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Image.asset(index == selectedIndex
              ? "assets/tab${index + 1}_selected.png"
              : "assets/tab${index + 1}_unselected.png"),
        ),
      ),
      flex: 1,
    );
  }
}
