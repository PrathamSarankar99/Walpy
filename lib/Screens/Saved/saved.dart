import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:walpy/Modals/pixabay_image.dart';
import 'package:walpy/Screens/HomeScreens/preview.dart';
import 'package:walpy/Widget/animated_page.dart';

class Saved extends StatefulWidget {
  const Saved({Key key}) : super(key: key);
  @override
  _SavedState createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  List<String> images;
  int totalimages;

  @override
  void initState() {
    images = List<String>.from(Hive.box("SAVED_PHOTOS").get("PATH_LIST"));
    totalimages = images.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AnimatedPage(
      child: Scaffold(
          backgroundColor: Colors.blue.shade100,
          body: Container(
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 40),
                  child: SafeArea(
                    child: Text(
                      "Saved",
                      style: GoogleFonts.varelaRound(
                        color: Color.fromRGBO(38, 39, 43, 1),
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        //rgb(38, 39, 43)
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: totalimages != null,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0, top: 10),
                    child: Text(
                      "$totalimages photos available" +
                          (totalimages == 500 ? "\n(max at a time)" : ""),
                      style: GoogleFonts.montserrat(
                        color: Colors.black45,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: images == null
                      ? Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                // color: Colors.purple,
                                width: width * 0.8,
                                height: height * 0.25,
                                child: SvgPicture.asset("assets/loading1.svg"),
                              ),
                              Text("On the way...",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        )
                      : (images.length == 0
                          ? Container(
                              // color: Colors.brown,
                              width: width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      bottom: 20,
                                    ),
                                    width: width * 0.8,
                                    height: height * 0.25,
                                    child:
                                        SvgPicture.asset("assets/empty1.svg"),
                                  ),
                                  Text("Oops! nothing for that.",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 15,
                                      )),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.zero,
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
                                        errorBuilder: (context,
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
                            )),
                ))
              ],
            ),
          )),
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
