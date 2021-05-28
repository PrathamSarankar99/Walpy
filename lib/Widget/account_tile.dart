import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountTile extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  const AccountTile({
    Key key,
    @required this.controller,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 18, right: 18),
      child: TextField(
        style: GoogleFonts.varelaRound(
          color: Colors.black.withOpacity(0.7),
          fontSize: 18,
          fontWeight: FontWeight.w100,
          //rgb(38, 39, 43)
        ),
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: GoogleFonts.varelaRound(
              color: Colors.black.withOpacity(0.4),
              fontSize: 18,
              fontWeight: FontWeight.w300,
              //rgb(38, 39, 43)
            ),
            contentPadding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                color: Colors.black.withOpacity(0.4),
                width: 2,
              ),
            )),
      ),
    );
  }
}
