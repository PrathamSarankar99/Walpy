import 'package:flutter/material.dart';

class GoogleSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      margin: EdgeInsets.only(
        bottom: 70,
        right: width * 0.04,
        left: width * 0.04,
      ),
      width: width,
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: width * 0.04,
          ),
          Container(
            width: 25,
            child: Image.asset("assets/google.png"),
          ),
          Spacer(),
          Container(
            width: 25,
            child: Image.asset("assets/google_voice.png"),
          ),
          SizedBox(
            width: width * 0.04,
          ),
        ],
      ),
    );
  }
}
