import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walpy/Services/auth_service.dart';
import 'package:walpy/Widget/sign_in_option.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({Key key}) : super(key: key);
  @override
  _LoginOptionsState createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 40),
            child: SafeArea(
              child: Text(
                "Signin Options",
                style: GoogleFonts.varelaRound(
                  color: const Color.fromRGBO(38, 39, 43, 1),
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  //rgb(38, 39, 43)
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Divider(
              color: Colors.black.withOpacity(0.3),
              thickness: 3,
              height: 5,
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SignInOption(
                  onTap: () {
                    AuthService.signInWithGoogle().then((value) {
                      Fluttertoast.showToast(msg: value);
                    });
                  },
                  asset: "assets/google.png",
                  option: "Google",
                ),
                // SignInOption(
                //   onTap: () {},
                //   asset: "assets/phone.png",
                //   option: "Phone",
                // ),
                // SignInOption(
                //   onTap: () {},
                //   asset: "assets/email.png",
                //   option: "Email",
                // ),
                SignInOption(
                  onTap: () {
                    AuthService.signInWithFacebook().then((value) {
                      Fluttertoast.showToast(msg: value);
                    });
                  },
                  asset: "assets/facebook.png",
                  option: "Facebook",
                ),
                // SignInOption(
                //   onTap: () {},
                //   asset: "assets/twitter.png",
                //   option: "Twitter",
                // ),
                // SignInOption(
                //   onTap: () {},
                //   asset: "assets/github.png",
                //   option: "Github",
                // ),
                // SignInOption(
                //   onTap: () {},
                //   asset: "assets/yahoo.png",
                //   option: "Yahoo",
                // ),
                // SignInOption(
                //   onTap: () {},
                //   asset: "assets/google_play.png",
                //   option: "Google Play",
                // ),
                // SignInOption(
                //   onTap: () {},
                //   asset: "assets/microsoft.png",
                //   option: "Microsoft",
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
