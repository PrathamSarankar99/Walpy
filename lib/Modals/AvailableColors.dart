import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvailableColors {
  static List<String> list = [
    "orange",
    "turquoise",
    "blue",
    "lilac",
    "pink",
    "red",
    "yellow",
    "green",
    "grayscale",
    "transparent",
    "black",
    "brown",
    "white",
    "gray",
  ];

  static Map<String, Color> colorForCode = {
    "grayscale": Colors.grey,
    "transparent": Colors.grey.withOpacity(0.3),
    "red": Colors.red,
    "orange": Colors.orange,
    "yellow": Colors.yellow,
    "green": Colors.green,
    "turquoise": Colors.cyan,
    "blue": Colors.blue,
    "lilac": Colors.purpleAccent,
    "pink": Colors.pink,
    "white": Colors.white,
    "gray": Colors.grey.shade500,
    "black": Colors.black,
    "brown": Colors.brown
  };
}
