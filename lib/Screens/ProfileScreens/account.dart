import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart' as path;
import 'package:walpy/Services/auth_service.dart';
import 'package:walpy/Widget/account_tile.dart';
import 'package:walpy/main.dart';

class Account extends StatefulWidget {
  const Account({Key key}) : super(key: key);
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController usernameC;
  TextEditingController emailC;
  bool isSavePressed;
  FocusNode saveFocusNode;
  @override
  void initState() {
    super.initState();
    saveFocusNode = FocusNode();
    usernameC = TextEditingController(
        text: FirebaseAuth.instance.currentUser.displayName);
    emailC =
        TextEditingController(text: FirebaseAuth.instance.currentUser.email);
    isSavePressed = false;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 40),
            child: SafeArea(
              child: Text(
                "Account",
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
                if (FirebaseAuth.instance.currentUser.photoURL != null &&
                    FirebaseAuth.instance.currentUser.photoURL.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: Image.network(
                            FirebaseAuth.instance.currentUser.photoURL,
                            height: height * 0.40,
                            width: width,
                            fit: BoxFit.cover,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            String url =
                                await uploadProfilePhoto(ImageSource.gallery);
                            FirebaseAuth.instance.currentUser
                                .updateProfile(
                              photoURL: url,
                            )
                                .then((value) {
                              setState(() {
                                Fluttertoast.showToast(msg: "Uploading done!");
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        child: const Walpy(
                                          initialindex: 2,
                                        ),
                                        type: PageTransitionType.leftToRight));
                              });
                            });
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(10)),
                              shape: MaterialStateProperty.all(
                                  const CircleBorder())),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      ],
                    ),
                  ),
                AccountTile(
                  controller: usernameC,
                  labelText: "Username",
                ),
                AccountTile(
                  controller: emailC,
                  labelText: "Email",
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSavePressed = true;
                    });
                    if (emailC.text !=
                        FirebaseAuth.instance.currentUser.email) {
                      updateEmail(emailC.text);
                      saveFocusNode.requestFocus();
                    }
                    if (usernameC.text !=
                        FirebaseAuth.instance.currentUser.displayName) {
                      updateUsername(usernameC.text);
                      saveFocusNode.requestFocus();
                      Fluttertoast.showToast(msg: "Saved!");
                    }
                    Future.delayed(
                      const Duration(milliseconds: 300),
                    ).then((value) {
                      setState(() {
                        isSavePressed = false;
                      });
                    });
                  },
                  onTapDown: (details) {
                    setState(() {
                      isSavePressed = true;
                    });
                  },
                  onTapUp: (details) {
                    setState(() {
                      isSavePressed = false;
                    });
                  },
                  onTapCancel: () {
                    setState(() {
                      isSavePressed = false;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(18),
                    height: 65,
                    width: width,
                    child: Focus(
                      focusNode: saveFocusNode,
                      child: Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        type: MaterialType.button,
                        elevation: isSavePressed ? 0 : 10,
                        color: Colors.blue,
                        shadowColor: Colors.blue.withOpacity(0.5),
                        child: Center(
                          child: Text(
                            "Save",
                            style: GoogleFonts.montserrat(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> uploadProfilePhoto(ImageSource source) async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: source,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      Fluttertoast.showToast(msg: "Uploading Started!");
    }
    String storePath = FirebaseAuth.instance.currentUser.uid.toString() +
        "/" +
        "profile_picture" +
        path.basename(pickedFile.path);
    Reference ref = FirebaseStorage.instance.ref().child(storePath);
    UploadTask uploadTask = ref.putFile(File(pickedFile.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  updateUsername(String newDisplayname) {
    FirebaseAuth.instance.currentUser.updateProfile(
      displayName: newDisplayname,
    );
  }

  updateEmail(String newEmail) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Note"),
            content: const Text(
                "A verification link will be sent to this email. You will be logged out once you have verified your email. Log in again by same method (for eg: Facebook,Google)"),
            actions: [
              TextButton(
                child: const Text("Okay"),
                onPressed: () async {
                  try {
                    Navigator.pop(context);
                    await FirebaseAuth.instance.currentUser
                        .verifyBeforeUpdateEmail(newEmail);
                    Fluttertoast.showToast(
                        msg: "A verification link has been sent!");
                    await AuthService.signOut();
                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    handleException(e);
                  }
                },
              ),
              TextButton(
                child: const Text("Cancel"),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  handleException(FirebaseAuthException e) {
    {
      switch (e.code) {
        case 'requires-recent-login':
          {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Error"),
                    content: const Text(
                        "Oops! you don't seemed to have recently logged in. As this is sensitive operation, we want you to verify yourself again. Click okay to sign out!"),
                    actions: [
                      TextButton(
                        child: const Text("Okay"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          AuthService.signOut();
                        },
                      ),
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
          }
          break;
        case 'unknown':
          {
            Fluttertoast.showToast(msg: "Enter a valid email");
          }
          break;
        default:
          {
            Fluttertoast.showToast(msg: e.message);
          }
      }
    }
  }
}
