import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:walpy/Modals/AvailableColors.dart';
import 'package:walpy/Modals/Categories.dart';
import 'package:walpy/Modals/pixabay_image.dart';
import 'package:walpy/Screens/HomeScreens/category_home.dart';
import 'package:walpy/Services/pixabay_api.dart';
import 'package:walpy/Widget/animated_list_for_bom.dart';
import 'package:walpy/Widget/animated_list_item.dart';
import 'package:walpy/Widget/animated_page.dart';
import 'package:walpy/Widget/BOM.dart';
import 'package:walpy/Widget/Category.dart';
import 'package:walpy/Widget/color_tone.dart';

import 'preview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  List<PixabayImage> images;
  FocusNode focusClear;
  TextEditingController controller;
  @override
  void initState() {
    focusClear = FocusNode();
    controller = TextEditingController();
    PixabayApi.getBestOfMonthList().then((value) {
      setState(() {
        images = value;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var width = MediaQuery.of(context).size.width;
    return AnimatedPage(
      child: Column(
        children: [
          Expanded(
            flex: 12,
            child: Container(
              child: Column(
                children: [
                  Expanded(
                      flex: 55,
                      child: Container(
                        margin: const EdgeInsets.only(right: 18, left: 18),
                        alignment: Alignment.bottomCenter,
                        child: TextField(
                          onSubmitted: (value) {
                            focusClear.requestFocus();
                            if (controller.text.isNotEmpty) {
                              showDialog(
                                context: context,
                                useRootNavigator: false,
                                useSafeArea: false,
                                builder: (context) {
                                  return CategoryHome(
                                    title: '',
                                    query: controller.text,
                                    color: [],
                                  );
                                },
                                barrierDismissible: true,
                                barrierColor: Colors.black,
                                barrierLabel: '',
                              );
                            }
                          },
                          controller: controller,
                          style: GoogleFonts.montserrat(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            suffixIcon: TextButton(
                              focusNode: focusClear,
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    const CircleBorder()),
                              ),
                              onPressed: () {
                                controller.clear();
                              },
                              child: const Icon(
                                Icons.clear,
                              ),
                            ),
                            hintText: 'Find Wallpaper...',
                            hintStyle: GoogleFonts.montserrat(
                              color: Colors.black26,
                              fontSize: 15,
                            ),
                            fillColor: Colors.white.withOpacity(0.35),
                            filled: true,
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0,
                                )),
                            focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0,
                                )),
                            disabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0,
                                )),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 0,
                                )),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 100,
                      child: Container(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 20,
                              child: Container(
                                padding: const EdgeInsets.only(left: 18),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Best of the month",
                                  style: GoogleFonts.varelaRound(
                                    color: const Color.fromRGBO(38, 39, 43, 1),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    //rgb(38, 39, 43)
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 100,
                              child: images == null
                                  ? Container(
                                      alignment: Alignment.center,
                                      height: double.maxFinite,
                                      child: Text(
                                        "Loading...",
                                        style: GoogleFonts.montserrat(
                                          color: Colors.black26,
                                          fontSize: 15,
                                        ),
                                      ))
                                  : ListView.builder(
                                      itemCount: images.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return AnimatedListItemForBom(
                                          key: ValueKey<String>(
                                              images[index].imageURL),
                                          scrollDirection: Axis.horizontal,
                                          index: index,
                                          child: BOM(
                                            image: images[index],
                                            onTap: clickonbom,
                                          ),
                                        );
                                      }),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    width: width,
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 18,
                            top: 18,
                          ),
                          child: Text(
                            "The color tone",
                            style: GoogleFonts.varelaRound(
                              color: Color.fromRGBO(38, 39, 43, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              //rgb(38, 39, 43)
                            ),
                          ),
                        ),
                        Container(
                          height: 75,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            children: colorTones(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: EdgeInsets.only(top: 10, left: 18),
                    width: width,
                    child: Text(
                      "Categories",
                      style: GoogleFonts.varelaRound(
                        color: Color.fromRGBO(38, 39, 43, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        //rgb(38, 39, 43)
                      ),
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.spaceEvenly,
                    children: categories(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  clickonbom(PixabayImage image) {
    showDialog(
      context: context,
      useRootNavigator: false,
      useSafeArea: false,
      builder: (context) {
        return Preview(
          image: image,
          savedPath: '',
        );
      },
      barrierDismissible: true,
      barrierColor: Colors.black,
      barrierLabel: '',
    );
  }

  clickoncategory(String title) {
    showDialog(
      context: context,
      useRootNavigator: false,
      useSafeArea: false,
      builder: (context) {
        return CategoryHome(
          title: title,
          query: '',
          color: [],
        );
      },
      barrierDismissible: true,
      barrierColor: Colors.black,
      barrierLabel: '',
    );
  }

  List<Widget> categories() {
    return CategoryName.map((e) => AnimatedListItem(
          scrollDirection: Axis.vertical,
          index: CategoryName.indexOf(e),
          key: ValueKey<String>(e),
          child: Category(
            categoryName: e,
            onTap: clickoncategory,
          ),
        )).toList();
  }

  onColorTonePress(String color) {
    showDialog(
      context: context,
      useRootNavigator: false,
      useSafeArea: false,
      builder: (context) {
        return CategoryHome(
          title: "",
          query: '',
          color: [color],
        );
      },
      barrierDismissible: true,
      barrierColor: Colors.black,
      barrierLabel: '',
    );
  }

  List<Widget> colorTones() {
    return AvailableColors.list
        .map((e) => AnimatedListItem(
              scrollDirection: Axis.horizontal,
              index: AvailableColors.list.indexOf(e),
              key: ValueKey<String>(e),
              child: ColorTone(
                color: e,
                onPressed: onColorTonePress,
              ),
            ))
        .toList();
  }
}
