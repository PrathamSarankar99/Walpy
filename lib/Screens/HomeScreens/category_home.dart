import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walpy/Modals/AvailableColors.dart';
import 'package:walpy/Modals/pixabay_image.dart';
import 'package:walpy/Screens/HomeScreens/Preview.dart';
import 'package:walpy/Services/pixabay_api.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:walpy/Widget/filter.dart';

class CategoryHome extends StatefulWidget {
  final String title;
  final String query;
  final List<String> color;
  const CategoryHome(
      {Key key, this.title = '', @required this.query, @required this.color})
      : super(key: key);

  @override
  _CategoryHomeState createState() => _CategoryHomeState();
}

class _CategoryHomeState extends State<CategoryHome> {
  int totalpage;
  int totalimages;
  double currentpage = 1;
  List<PixabayImage> images;
  AutoScrollController controller;
  List<String> selectedColors;
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    selectedColors = [];
    controller = AutoScrollController();
    String query = buildQuery(widget.query);
    String color = widget.color.join(',');
    PixabayApi.queryResult(widget.title, currentpage, query, color)
        .then((value) {
      setState(() {
        images = value["images"];
        totalimages = value["totalhits"];
        totalpage = (value["totalhits"] / 20).floor() +
            (value["totalhits"] % 20 == 0 ? 0 : 1);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        bottomNavigationBar: ((images != null && images.isEmpty)
            ? null
            : Container(
                color: Colors.blue.shade50,
                height: height * 0.08,
                width: width,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(
                          0,
                          height * 0.08,
                        ))),
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: Icon(Icons.chevron_right_rounded),
                        ),
                        onPressed: () {
                          moveTo((currentpage - 1).floor());
                        },
                      ),
                    ),
                    Expanded(
                      flex: 12,
                      child: Container(
                          child: ListView.builder(
                        controller: controller,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemCount: totalpage,
                        itemBuilder: (context, index) {
                          return AutoScrollTag(
                            controller: controller,
                            index: index,
                            key: ValueKey(index),
                            highlightColor: Colors.blue,
                            child: TextButton(
                              child: Text(
                                (index + 1).toString(),
                                style: GoogleFonts.varelaRound(
                                  color: (index + 1) == currentpage
                                      ? Color.fromRGBO(38, 39, 43, 1)
                                      : Color.fromRGBO(38, 39, 43, 0.7),
                                  fontSize:
                                      (index + 1) == currentpage ? 20 : 15,
                                  fontWeight: (index + 1) == currentpage
                                      ? FontWeight.w600
                                      : FontWeight.w300,
                                ),
                              ),
                              onPressed: () {
                                moveTo(index + 1);
                              },
                            ),
                          );
                        },
                      )),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(
                          0,
                          height * 0.08,
                        ))),
                        child: Icon(Icons.chevron_right_rounded),
                        onPressed: () {
                          moveTo((currentpage + 1).floor());
                        },
                      ),
                    ),
                  ],
                ),
              )),
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
                    widget.title.isEmpty
                        ? (widget.query.isEmpty ? "Color Search" : widget.query)
                        : widget.title.substring(0, 1).toUpperCase() +
                            widget.title.substring(1, widget.title.length),
                    style: GoogleFonts.varelaRound(
                      color: Color.fromRGBO(38, 39, 43, 1),
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      //rgb(38, 39, 43)
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 10, right: 18),
                child: Visibility(
                  visible: totalimages != null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$totalimages photos available" +
                            (totalimages == 500 ? "\n(max at a time)" : ""),
                        style: GoogleFonts.montserrat(
                          color: Colors.black45,
                          fontSize: 15,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showCupertinoDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Filter(
                                    colors: selectedColors,
                                  ),
                                );
                              }).then((value) {
                            if (value != null) {
                              setState(() {
                                images = null;
                              });
                              List<String> colors = List<String>.from(value);
                              currentpage = 1;
                              PixabayApi.queryResult(widget.title, 1,
                                      widget.query, colors.join(","))
                                  .then((value) {
                                setState(() {
                                  images = value["images"];
                                  totalimages = value["totalhits"];
                                  totalpage = (value["totalhits"] / 20)
                                          .floor() +
                                      (value["totalhits"] % 20 == 0 ? 0 : 1);
                                });
                              });
                            }
                          });
                        },
                        child: Icon(
                          Icons.filter_alt,
                          size: 30,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
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
                                  child: SvgPicture.asset("assets/empty1.svg"),
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
                                      return Preview(
                                        image: images[index],
                                        savedPath: '',
                                      );
                                    },
                                    barrierDismissible: true,
                                    barrierColor: Colors.black,
                                    barrierLabel: '',
                                  );
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
                                    child: Image.network(
                                      images[index].imageURL,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          // ignore: sized_box_for_whitespace
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(Colors.white),
                                              strokeWidth: 1.5,
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                            ),
                                          ),
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
        ));
  }

  moveTo(int page) {
    if (images == null) {
      return null;
    }
    if (page < 1 || page > totalpage) {
      controller.scrollToIndex(
        page - 1,
        preferPosition: AutoScrollPosition.middle,
      );
      return;
    }
    setState(() {
      currentpage = page.toDouble();
      images = null;
    });
    controller.scrollToIndex(
      page - 1,
      preferPosition: AutoScrollPosition.middle,
    );
    String query = buildQuery(widget.query);
    String color = widget.color.join(',');
    PixabayApi.queryResult(widget.title, currentpage, query, color)
        .then((value) {
      setState(() {
        images = value["images"];
        totalimages = value["totalhits"];
        totalpage = (value["totalhits"] / 20).floor() +
            (value["totalhits"] % 20 == 0 ? 0 : 1);
      });
    });
  }

  String buildQuery(String unbuild) {
    List<String> list = unbuild.split(" ");
    String result = list.join("+");
    return result;
  }
}
