import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:walpy/Services/auth_service.dart';
import 'package:walpy/main.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController albumnameC;
  static const adUnitID = "ca-app-pub-9284439859413446/3004544819";
  final nativeAdController = NativeAdmobController();
  @override
  void initState() {
    albumnameC = TextEditingController(
      text: Hive.box("SETTINGS").get("ALBUM_NAME"),
    );
    nativeAdController.setTestDeviceIds(['04CADE3D72680064A6B7D04F46E32928']);
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
            padding: const EdgeInsets.only(left: 18.0, top: 40),
            child: SafeArea(
              child: Text(
                "Settings",
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
                ListTile(
                  title: Text(
                    "Safe Search",
                    style: GoogleFonts.varelaRound(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      //rgb(38, 39, 43)
                    ),
                  ),
                  trailing: SizedBox(
                      width: 60,
                      height: 30,
                      child: FlutterSwitch(
                          value: Hive.box("SETTINGS").get("SAFE_SEARCH"),
                          onToggle: (value) {
                            setState(() {
                              Hive.box("SETTINGS").put("SAFE_SEARCH",
                                  !Hive.box("SETTINGS").get("SAFE_SEARCH"));
                            });
                          })),
                  minVerticalPadding: 20,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  title: Text(
                    "Save to gallery",
                    style: GoogleFonts.varelaRound(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      //rgb(38, 39, 43)
                    ),
                  ),
                  trailing: SizedBox(
                      width: 60,
                      height: 30,
                      child: FlutterSwitch(
                          value: Hive.box("SETTINGS").get("SAVE_TO_GALLERY"),
                          onToggle: (value) {
                            setState(() {
                              Hive.box("SETTINGS").put("SAVE_TO_GALLERY",
                                  !Hive.box("SETTINGS").get("SAVE_TO_GALLERY"));
                            });
                          })),
                  minVerticalPadding: 20,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Album name"),
                            content: TextField(
                              controller: albumnameC,
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Save"),
                                onPressed: () {
                                  Navigator.pop(context);
                                  String newName = albumnameC.text;
                                  Hive.box("SETTINGS")
                                      .put("ALBUM_NAME", newName);
                                  albumnameC =
                                      TextEditingController(text: newName);
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
                        }).then((value) {
                      setState(() {});
                    });
                  },
                  title: Text(
                    "Album name",
                    style: GoogleFonts.varelaRound(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      //rgb(38, 39, 43)
                    ),
                  ),
                  trailing: Text(
                    Hive.box("SETTINGS").get("ALBUM_NAME"),
                    style: GoogleFonts.varelaRound(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      //rgb(38, 39, 43)
                    ),
                  ),
                  minVerticalPadding: 20,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text("Are you sure?"),
                            actions: [
                              TextButton(
                                child: const Text("Yes"),
                                onPressed: () {
                                  Hive.box("SAVED_PHOTOS").put("PATH_LIST", []);
                                  Navigator.pop(context);
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
                        }).then((value) {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: const Walpy(
                                initialindex: 2,
                              ),
                              type: PageTransitionType.fade));
                    });
                  },
                  leading: const Icon(
                    Icons.clear_all_rounded,
                    color: Colors.blue,
                    size: 35,
                  ),
                  title: Text(
                    "Clear saved",
                    style: GoogleFonts.varelaRound(
                      color: Colors.black.withOpacity(0.4),
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      //rgb(38, 39, 43)
                    ),
                  ),
                  minVerticalPadding: 20,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                ),
                if (FirebaseAuth.instance.currentUser != null)
                  ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text("Are you sure?"),
                              actions: [
                                TextButton(
                                  child: const Text("Yes"),
                                  onPressed: () {
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
                          }).then((value) {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: const Walpy(
                                  initialindex: 2,
                                ),
                                type: PageTransitionType.fade));
                      });
                    },
                    leading: const Icon(
                      Icons.power_settings_new,
                      color: Colors.blue,
                      size: 35,
                    ),
                    title: Text(
                      "log out",
                      style: GoogleFonts.varelaRound(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        //rgb(38, 39, 43)
                      ),
                    ),
                    minVerticalPadding: 20,
                  ),
                if (FirebaseAuth.instance.currentUser != null)
                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),
                if (FirebaseAuth.instance.currentUser != null)
                  ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "This operation will delete all the information about your profile and you will never be able to get it back. Are you sure?"),
                              actions: [
                                TextButton(
                                  child: const Text("Yes"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    FirebaseAuth.instance.currentUser
                                        .delete()
                                        .then((value) {
                                      AuthService.signOut();
                                    });
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
                          }).then((value) {
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                child: const Walpy(
                                  initialindex: 2,
                                ),
                                type: PageTransitionType.fade));
                      });
                    },
                    leading: const Icon(
                      Icons.delete_rounded,
                      color: Colors.blue,
                      size: 35,
                    ),
                    title: Text(
                      "Delete my account",
                      style: GoogleFonts.varelaRound(
                        color: Colors.black.withOpacity(0.4),
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        //rgb(38, 39, 43)
                      ),
                    ),
                    minVerticalPadding: 20,
                  ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 20.0),
                  height: 330,
                  child: NativeAdmob(
                    adUnitID: adUnitID,
                    controller: nativeAdController,
                    type: NativeAdmobType.full,
                    loading: Container(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
