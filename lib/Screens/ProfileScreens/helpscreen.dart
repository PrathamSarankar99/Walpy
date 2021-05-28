import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({Key key}) : super(key: key);
  @override
  _HelpCenterState createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
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
                      "Help center",
                      style: GoogleFonts.varelaRound(
                        color: const Color.fromRGBO(38, 39, 43, 1),
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        //rgb(38, 39, 43)
                      ),
                    ),
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: controller,
                    style: GoogleFonts.montserrat(),
                    minLines: double.maxFinite.toInt() - 1,
                    maxLines: double.maxFinite.toInt(),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      hintText:
                          'Send us your query and we will contact you through email in a few working days.',
                      focusColor: Colors.white,
                      hintStyle: GoogleFonts.montserrat(
                        color: Colors.black.withOpacity(0.4),
                      ),
                      hintMaxLines: 5,
                      filled: true,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 70,
            margin: const EdgeInsets.only(right: 18),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                User user = FirebaseAuth.instance.currentUser;
                FirebaseFirestore.instance
                    .collection("Help")
                    .doc(user.uid)
                    .set({
                  "DisplayName": user.displayName,
                  "Email": user.email,
                  "PhotoURL": user.photoURL,
                  "Message": controller.text,
                });
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Query Sent! Thanks");
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
                  minimumSize: MaterialStateProperty.all(const Size(70, 50)),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blue.withOpacity(0.9))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10),
                    child: Text(
                      "Send",
                      style: GoogleFonts.montserrat(
                        fontSize: 17,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: -pi / 5,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 0, left: 5),
                      child: Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
