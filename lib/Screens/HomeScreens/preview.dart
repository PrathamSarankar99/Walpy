import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:images_picker/images_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:walpy/Modals/pixabay_image.dart';
import 'package:walpy/Modals/TimeConstants.dart';
import 'package:walpy/Modals/Wallpaper.dart';
import 'package:walpy/Widget/details_sheet.dart';
import 'package:walpy/Widget/GoogleSearch.dart';
import 'package:walpy/Widget/Setter.dart';
import 'package:walpy/Widget/preview_menu.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:walpy/Widget/psuedo_apps.dart';

class Preview extends StatefulWidget {
  final PixabayImage image;
  final String savedPath;
  const Preview({Key key, @required this.image, this.savedPath = ''})
      : super(key: key);
  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> with TickerProviderStateMixin {
  AnimationController animationControllerpreview;
  Animation<Offset> slideanimpreview;
  Animation<Offset> slideanimtime;
  Animation<Offset> slideswipeup;
  PageController pageController;
  AnimationController animationControllertime;
  double factor = 1 / 3;
  bool isOnce = true;
  static const adUnitID = "ca-app-pub-9284439859413446/3004544819";
  final nativeAdController = NativeAdmobController();
  @override
  void initState() {
    pageController = PageController(
      initialPage: 1,
      keepPage: true,
    )..addListener(() {
        const noOfPages = 3;
        setState(() {
          factor = pageController.offset / (360 * noOfPages);
        });
      });
    animationControllertime = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animationControllerpreview = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    slideanimpreview = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: const Offset(0.0, 0.85),
    ).animate(CurvedAnimation(
      parent: animationControllerpreview,
      curve: Curves.decelerate,
    ));
    slideanimtime = Tween<Offset>(
      begin: const Offset(0.0, -0.70),
      end: const Offset(0.0, -1.0),
    ).animate(CurvedAnimation(
      parent: animationControllertime,
      curve: Curves.decelerate,
    ));
    slideswipeup = Tween<Offset>(
      begin: const Offset(0.0, 0.9),
      end: const Offset(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: animationControllertime,
      curve: Curves.decelerate,
    ));
    nativeAdController.setTestDeviceIds(['04CADE3D72680064A6B7D04F46E32928']);
    super.initState();
  }

  @override
  void dispose() {
    animationControllerpreview.dispose();
    animationControllertime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.blue.shade50),
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, true);
          return false;
        },
        child: Scaffold(
          body: PageView(
            scrollDirection: Axis.vertical,
            children: [
              GestureDetector(
                onTap: () {
                  if (animationControllertime.isCompleted) {
                    animationControllerpreview.reverse().then((value) {
                      animationControllertime.reverse();
                    });
                  } else {
                    if (animationControllerpreview.isCompleted) {
                      animationControllertime.forward().then((value) {
                        animationControllerpreview.forward();
                      });
                    }
                    animationControllertime.forward().then((value) {
                      animationControllerpreview.forward();
                    });
                  }
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: widget.image.imageURL,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 2),
                        child: widget.savedPath.isNotEmpty
                            ? Image.file(
                                File(widget.savedPath),
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              )
                            : Image.network(
                                widget.image.imageURL,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                      ),
                    ),
                    SlideTransition(
                      position: slideanimtime,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Icon(
                                Icons.lock,
                                size: 20,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              DateTime.now().hour.toString().padLeft(2, "0") +
                                  ":" +
                                  DateTime.now()
                                      .minute
                                      .toString()
                                      .padLeft(2, "0"),
                              style: GoogleFonts.montserrat(
                                fontSize: 70,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 7,
                                shadows: [
                                  Shadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                                TimeConstants
                                        .weekdays[DateTime.now().weekday - 1] +
                                    ", " +
                                    DateTime.now().day.toString() +
                                    " " +
                                    TimeConstants
                                        .months[DateTime.now().month - 1],
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ))
                          ],
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: slideswipeup,
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Icon(
                              Icons.arrow_drop_up_rounded,
                              size: 25,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            Text(
                              "Swipe up or Click",
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SlideTransition(
                      position: slideanimpreview,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PreviewMenu(
                            isActive: true,
                            text: "Info",
                            asset: "assets/info.svg",
                            color: Colors.grey.withOpacity(0.3),
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                  barrierColor: Colors.grey.withOpacity(0.1),
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return DetailSheet(
                                      image: widget.image,
                                    );
                                  });
                            },
                          ),
                          (widget.savedPath.isEmpty
                              ? PreviewMenu(
                                  isActive: isOnce,
                                  text: "Save",
                                  asset: "assets/save.svg",
                                  color: Colors.grey.withOpacity(0.3),
                                  onPressed: () async {
                                    setState(() {
                                      isOnce = false;
                                    });
                                    var dir =
                                        await getExternalStorageDirectory();
                                    CancelToken cancelToken = CancelToken();
                                    String filepath = dir.path +
                                        DateTime.now()
                                            .microsecondsSinceEpoch
                                            .toString() +
                                        '.png';
                                    Dio()
                                        .download(
                                            widget.image.imageURL, filepath,
                                            cancelToken: cancelToken,
                                            deleteOnError: true,
                                            onReceiveProgress: (int1, int2) {})
                                        .then((value) {
                                      File file = File(filepath);
                                      if (file.existsSync()) {
                                        String msg = "Saved";
                                        //Save photos to Hive --start
                                        var list = Hive.box("SAVED_PHOTOS")
                                            .get("PATH_LIST");
                                        var map =
                                            PixabayImage.toMap(widget.image);
                                        if (list == null) {
                                          list = [file.path];
                                          Hive.box("SAVED_PHOTOS")
                                              .put("PATH_LIST", list);
                                          Hive.box("PATH_MAPS")
                                              .put(file.path, map);
                                        } else {
                                          list.add(file.path);
                                          Hive.box("PATH_MAPS")
                                              .put(file.path, map);
                                          Hive.box("SAVED_PHOTOS")
                                              .put("PATH_LIST", list);
                                        }
                                        //Save photos to Hive --finish
                                        if (Hive.isBoxOpen("SETTINGS") &&
                                            Hive.box("SETTINGS")
                                                .get("SAVE_TO_GALLERY")) {
                                          String albumName =
                                              Hive.box("SETTINGS")
                                                  .get("ALBUM_NAME");
                                          ImagesPicker.saveImageToAlbum(file,
                                                  albumName: albumName)
                                              .then((value) {
                                            if (!value) {
                                              msg = "Couldn't save to gallery";
                                            }
                                          });
                                        }
                                        Fluttertoast.showToast(msg: msg);
                                      }
                                    });
                                  },
                                )
                              : PreviewMenu(
                                  isActive: isOnce,
                                  text: "Delete",
                                  asset: "assets/delete.svg",
                                  color: Colors.grey.withOpacity(0.3),
                                  onPressed: () async {
                                    setState(() {
                                      isOnce = false;
                                    });
                                    List<String> existList = List<String>.from(
                                        Hive.box("SAVED_PHOTOS")
                                            .get("PATH_LIST"));
                                    existList.removeWhere((element) =>
                                        element == widget.savedPath);
                                    Hive.box("SAVED_PHOTOS")
                                        .put("PATH_LIST", existList);
                                  },
                                )),
                          PreviewMenu(
                            isActive: true,
                            text: "Apply",
                            asset: "assets/apply.svg",
                            color: Colors.blue.shade900,
                            onPressed: () {
                              animationControllerpreview
                                  .reverse()
                                  .then((value) {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    barrierColor: Colors.black.withOpacity(0.5),
                                    context: context,
                                    builder: (context) {
                                      return Setter();
                                    }).then((value) {
                                  animationControllerpreview.forward();
                                  if (value != null) {
                                    List<WallpaperLocation> list =
                                        List<WallpaperLocation>.from(value);
                                    if (list.isEmpty) {
                                      return;
                                    }
                                    if (list.contains(
                                        WallpaperLocation.homescreen)) {
                                      if (widget.savedPath.isNotEmpty) {
                                        WallpaperManager.setWallpaperFromFile(
                                            widget.savedPath,
                                            WallpaperManager.HOME_SCREEN);
                                      } else {
                                        downloadAndApply(
                                            WallpaperManager.HOME_SCREEN);
                                      }
                                    }
                                    if (list.contains(
                                        WallpaperLocation.lockscreen)) {
                                      if (widget.savedPath.isNotEmpty) {
                                        WallpaperManager.setWallpaperFromFile(
                                            widget.savedPath,
                                            WallpaperManager.LOCK_SCREEN);
                                      } else {
                                        downloadAndApply(
                                            WallpaperManager.LOCK_SCREEN);
                                      }
                                    }
                                    Fluttertoast.showToast(msg: 'Done!');
                                  }
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  double offset = details.delta.dx;
                  setState(() {
                    factor = factor - offset / 500;
                    if (factor.isNegative) {
                      factor = 0;
                    }
                    if (factor > 1) {
                      factor = 1;
                    }
                  });
                },
                onHorizontalDragEnd: (details) {},
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: widget.savedPath.isNotEmpty
                        ? FileImage(File(widget.savedPath)) as ImageProvider
                        : NetworkImage(
                            widget.image.imageURL,
                          ),
                    alignment: Alignment.lerp(
                            Alignment.centerLeft, Alignment.centerRight, factor)
                        as AlignmentGeometry,
                    fit: BoxFit.fitHeight,
                  )),
                  child: PageView(
                    controller: pageController,
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          height: 330,
                          child: NativeAdmob(
                            adUnitID: adUnitID,
                            controller: nativeAdController,
                            type: NativeAdmobType.full,
                            loading: Container(),
                          ),
                        ),
                      ),
                      Container(
                        height: height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const PsuedoApps(),
                            GoogleSearch(),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          height: 330,
                          child: NativeAdmob(
                            adUnitID: adUnitID,
                            controller: nativeAdController,
                            type: NativeAdmobType.full,
                            loading: Container(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  downloadAndApply(int wallpaper) async {
    Directory dir = await getTemporaryDirectory();
    String path = dir.path + "${DateTime.now().microsecondsSinceEpoch}.png";
    Dio().download(widget.image.imageURL, path).then((value) {
      File file = new File(path);
      if (file.existsSync()) {
        WallpaperManager.setWallpaperFromFile(path, wallpaper);
      }
    });
  }
}
