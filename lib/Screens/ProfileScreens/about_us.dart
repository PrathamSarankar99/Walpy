import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key key}) : super(key: key);
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String tos = '\n';
  String uts = '\n';
  @override
  void initState() {
    rootBundle.loadString('assets/tos.txt').then((value) {
      setState(() {
        tos += value;
      });
    });
    rootBundle.loadString('assets/uts.txt').then((value) {
      setState(() {
        uts += value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 18.0, top: 40, right: 10, bottom: 5),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      "Walpy",
                      style: GoogleFonts.varelaRound(
                        color: const Color.fromRGBO(38, 39, 43, 1),
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        //rgb(38, 39, 43)
                      ),
                    ),
                  ),
                  Text(
                    "Powered by Pixabay",
                    style: GoogleFonts.varelaRound(
                      color:
                          const Color.fromRGBO(38, 39, 43, 1).withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      //rgb(38, 39, 43)
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.black.withOpacity(0.3),
            thickness: 3,
            height: 5,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(right: 18, left: 18, top: 10),
              children: [
                RichText(
                  text: TextSpan(
                      text: "Terms of service",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 27,
                      ),
                      children: [
                        const TextSpan(
                          text: "\ntrans",
                          style:
                              TextStyle(fontSize: 8, color: Colors.transparent),
                        ),
                        TextSpan(
                          style: GoogleFonts.montserrat(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 15,
                          ),
                          text: tos,
                        ),
                        const TextSpan(
                          text: "\ntrans",
                          style: TextStyle(
                              fontSize: 15, color: Colors.transparent),
                        ),
                        TextSpan(
                          text: "\nUse of the Service",
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 27,
                          ),
                        ),
                        const TextSpan(
                          text: "\ntrans",
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.transparent,
                          ),
                        ),
                        TextSpan(
                          style: GoogleFonts.montserrat(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 15,
                          ),
                          text: uts,
                        ),
                        const TextSpan(
                          text: "\ntrans",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.transparent,
                          ),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
