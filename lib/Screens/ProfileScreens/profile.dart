import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:hive/hive.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:walpy/Modals/pixabay_image.dart';
import 'package:walpy/Screens/HomeScreens/preview.dart';
import 'package:walpy/Screens/ProfileScreens/about_us.dart';
import 'package:walpy/Screens/ProfileScreens/account.dart';
import 'package:walpy/Screens/ProfileScreens/helpscreen.dart';
import 'package:walpy/Screens/ProfileScreens/login_option.dart';
import 'package:walpy/Screens/ProfileScreens/settings.dart';
import 'package:walpy/Services/auth_service.dart';
import 'package:walpy/Widget/animated_page.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<String> images;
  int totalimages;
  bool isInterstitialAdLoaded = false;
  Widget currentAd = const SizedBox(
    height: 0,
    width: 0,
  );
  static const adUnitID = "ca-app-pub-9284439859413446/3004544819";
  final nativeAdController = NativeAdmobController();
  @override
  void initState() {
    images = List<String>.from(Hive.box("SAVED_PHOTOS").get("PATH_LIST"));
    totalimages = images.length;
    // FacebookAudienceNetwork.init();
    // showBannerAd();
    // loadInterstitialAd();
    nativeAdController.setTestDeviceIds(['04CADE3D72680064A6B7D04F46E32928']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AnimatedPage(
      child: Scaffold(
          backgroundColor: Colors.blue.shade100,
          body: StreamBuilder<User>(
              stream: AuthService.authStream(),
              builder: (context, user) {
                return Container(
                  height: height,
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, right: 15, left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: width * 0.18,
                                height: width * 0.18,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: (user.hasData &&
                                        user.data.photoURL != null)
                                    ? ClipRRect(
                                        child: Image.network(
                                          user.data.photoURL,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                      )
                                    : ClipRRect(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, bottom: 5),
                                          child: SvgPicture.asset(
                                            "assets/default_user.svg",
                                            color: Colors.blue.shade200,
                                            alignment: Alignment.bottomCenter,
                                          ),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, right: 10),
                                    child: Container(
                                      width: width * 0.6,
                                      child: Text(
                                        (!user.hasData ||
                                                user.data.displayName == null ||
                                                user.data.displayName.isEmpty)
                                            ? "Username"
                                            : user.data.displayName,
                                        style: GoogleFonts.varelaRound(
                                          color: const Color.fromRGBO(
                                              38, 39, 43, 1),
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          //rgb(38, 39, 43)
                                        ),
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Container(
                                      width: width * 0.6,
                                      child: Text(
                                        (!user.hasData ||
                                                user.data.email == null ||
                                                user.data.email.isEmpty)
                                            ? "example@gmail.com"
                                            : user.data.email,
                                        style: GoogleFonts.varelaRound(
                                          color: Colors.black.withOpacity(0.4),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          //rgb(38, 39, 43)
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
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
                          if (images.isNotEmpty)
                            Container(
                              alignment: Alignment.lerp(
                                  Alignment.bottomLeft, Alignment.topLeft, 0.4),
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              height: height * 0.06,
                              width: width,
                              child: Text(
                                "You Saved",
                                style: GoogleFonts.varelaRound(
                                  color: const Color.fromRGBO(38, 39, 43, 1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  //rgb(38, 39, 43)
                                ),
                              ),
                            ),
                          if (images.isNotEmpty)
                            Container(
                              height: height * 0.3,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        useRootNavigator: false,
                                        useSafeArea: false,
                                        builder: (context) {
                                          PixabayImage image =
                                              PixabayImage.fromMap(
                                                  Map<String, dynamic>.from(
                                                      Hive.box("PATH_MAPS")
                                                          .get(images[index])));
                                          return Preview(
                                            image: image,
                                            savedPath: images[index],
                                          );
                                        },
                                        barrierDismissible: true,
                                        barrierColor: Colors.black,
                                        barrierLabel: '',
                                      ).then((value) {
                                        setState(() {
                                          images = List<String>.from(
                                              Hive.box("SAVED_PHOTOS")
                                                  .get("PATH_LIST"));
                                          totalimages = images.length;
                                        });
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      margin: EdgeInsets.only(
                                          right: width * 0.04,
                                          left: width * 0.04,
                                          top: 5,
                                          bottom: 5),
                                      width: width * 0.42,
                                      height: height * 0.3,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15)),
                                        child: Image.file(
                                          File(images[index]),
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace stackTrace) {
                                            delete(images[index]);
                                            return const Text('😢');
                                          },
                                          frameBuilder: (BuildContext context,
                                              Widget child,
                                              int frame,
                                              bool wasSynchronouslyLoaded) {
                                            if (wasSynchronouslyLoaded) {
                                              return child;
                                            }
                                            return AnimatedOpacity(
                                              child: child,
                                              opacity: frame == null ? 0 : 1,
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.easeOut,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (images.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Divider(
                                color: Colors.black.withOpacity(0.3),
                                height: 1,
                                thickness: 1,
                              ),
                            ),
                          ListTile(
                            minVerticalPadding: 20,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: (user.hasData &&
                                              user.data.displayName != null)
                                          ? const Account()
                                          : const LoginOptions(),
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.decelerate,
                                      type: PageTransitionType.rightToLeft));
                            },
                            leading: const Icon(
                              Icons.account_circle_sharp,
                              color: Colors.black,
                              size: 35,
                            ),
                            title: Text(
                              "Account",
                              style: GoogleFonts.varelaRound(
                                color: const Color.fromRGBO(38, 39, 43, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                                //rgb(38, 39, 43)
                              ),
                            ),
                            trailing: const RotatedBox(
                                quarterTurns: 2,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 15,
                                  color: Colors.black,
                                )),
                          ),
                          Divider(
                            color: Colors.black.withOpacity(0.3),
                            height: 1,
                            thickness: 1,
                          ),
                          ListTile(
                            minVerticalPadding: 20,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const AboutUs(),
                                      type: PageTransitionType.rightToLeft));
                            },
                            leading: const Icon(
                              Icons.info_outlined,
                              color: Colors.black,
                              size: 35,
                            ),
                            title: Text(
                              "About us",
                              style: GoogleFonts.varelaRound(
                                color: const Color.fromRGBO(38, 39, 43, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                                //rgb(38, 39, 43)
                              ),
                            ),
                            trailing: const RotatedBox(
                                quarterTurns: 2,
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 15,
                                  color: Colors.black,
                                )),
                          ),
                          Divider(
                            color: Colors.black.withOpacity(0.3),
                            height: 1,
                            thickness: 1,
                          ),
                          ListTile(
                            minVerticalPadding: 20,
                            onTap: () {
                              Navigator.push(
                                      context,
                                      PageTransition(
                                          child: const Settings(),
                                          type: PageTransitionType.rightToLeft))
                                  .then((value) {
                                // showInterstitialAd();
                              });
                            },
                            leading: const Icon(
                              Icons.settings,
                              color: Colors.black,
                              size: 35,
                            ),
                            title: Text(
                              "Settings",
                              style: GoogleFonts.varelaRound(
                                color: const Color.fromRGBO(38, 39, 43, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                                //rgb(38, 39, 43)
                              ),
                            ),
                            trailing: const RotatedBox(
                                quarterTurns: 2,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 15,
                                  color: Colors.black,
                                )),
                          ),
                          Divider(
                            color: Colors.black.withOpacity(0.3),
                            height: 1,
                            thickness: 1,
                          ),
                          ListTile(
                            minVerticalPadding: 20,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const HelpCenter(),
                                      type: PageTransitionType.rightToLeft));
                            },
                            leading: const Icon(
                              Icons.help_outline,
                              color: Colors.black,
                              size: 35,
                            ),
                            title: Text(
                              "Help Center",
                              style: GoogleFonts.varelaRound(
                                color: const Color.fromRGBO(38, 39, 43, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                                //rgb(38, 39, 43)
                              ),
                            ),
                            trailing: const RotatedBox(
                                quarterTurns: 2,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 15,
                                  color: Colors.black,
                                )),
                          ),
                          // Container(
                          //   width: MediaQuery.of(context).size.width,
                          //   child: currentAd,
                          // ),
                          Container(
                            height: 330,
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 20.0),
                            child: NativeAdmob(
                              adUnitID: adUnitID,
                              controller: nativeAdController,
                              type: NativeAdmobType.full,
                              loading: Container(),
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                );
              })),
    );
  }

  // showInterstitialAd() {
  //   if (isInterstitialAdLoaded) {
  //     FacebookInterstitialAd.showInterstitialAd();
  //   } else {
  //     print("Interstial Ad not yet loaded!");
  //   }
  // }

  // showBannerAd() {
  //   setState(() {
  //     currentAd = FacebookBannerAd(
  //       placementId: "238483071370931_238656288020276",
  //       // placementId: "IMG_16_9_APP_INSTALL#238483071370931_238656288020276",
  //       bannerSize: BannerSize.STANDARD,
  //       listener: (result, value) {
  //         print("Banner Ad: $result -->  $value");
  //       },
  //     );
  //   });
  // }

  void loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "238483071370931_238656288020276",
      // placementId: "IMG_16_9_APP_INSTALL#238483071370931_238656288020276",
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          setState(() {
            isInterstitialAdLoaded = true;
          });
        }

        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          setState(() {
            isInterstitialAdLoaded = false;
          });
          loadInterstitialAd();
        }
      },
    );
  }

  delete(String url) {
    var list = Hive.box("SAVED_PHOTOS").get("PATH_LIST");
    List<String> pathlist = List<String>.from(list);
    pathlist.removeWhere((element) => element == url);
    Hive.box("SAVED_PHOTOS").put("PATH_LIST", pathlist);
    images = Hive.box("SAVED_PHOTOS").get("PATH_LIST");
  }
}
