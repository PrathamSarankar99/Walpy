import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInOption extends StatelessWidget {
  final String option;
  final Function onTap;
  final String asset;
  const SignInOption({Key key, this.option, this.onTap, this.asset})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            onTap();
          },
          minVerticalPadding: 25,
          contentPadding: const EdgeInsets.only(left: 18),
          title: Text(
            "Sign in with $option",
            style: GoogleFonts.varelaRound(
              color: Colors.black.withOpacity(0.4),
              fontSize: 18,
              fontWeight: FontWeight.w300,
              //rgb(38, 39, 43)
            ),
            overflow: TextOverflow.ellipsis,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            height: 2000,
            width: 60,
            child: Image.asset(asset),
            // color: Colors.white,
          ),
        ),
        Divider(
          color: Colors.black.withOpacity(0.3),
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
