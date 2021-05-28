import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:walpy/Modals/AvailableColors.dart';
import 'package:walpy/Modals/Categories.dart';
import 'package:walpy/Screens/ProfileScreens/profile.dart';
import 'package:walpy/Widget/bottom_bar_item.dart';
import 'Screens/HomeScreens/home_page.dart';
import 'Screens/Saved/saved.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  runApp(const WalpyApp());
}

class WalpyApp extends StatelessWidget {
  const WalpyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Walpy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Walpy(
        initialindex: 0,
      ),
    );
  }
}

class Walpy extends StatefulWidget {
  final int initialindex;

  const Walpy({Key key, this.initialindex}) : super(key: key);
  @override
  _WalpyState createState() => _WalpyState();
}

class _WalpyState extends State<Walpy> with SingleTickerProviderStateMixin {
  int selectedIndex;
  PageController controller;
  @override
  void initState() {
    selectedIndex = widget.initialindex;
    controller = PageController(
      initialPage: widget.initialindex,
    );
    Hive.openBox("SAVED_PHOTOS").then((box) {
      if (box.get("PATH_LIST") == null) {
        box.put("PATH_LIST", []);
      }
    });
    Hive.openBox("SETTINGS").then((box) {
      if (box.get("SAFE_SEARCH") == null) {
        box.put("SAFE_SEARCH", true);
      }
      if (box.get("SAVE_TO_GALLERY") == null) {
        box.put("SAVE_TO_GALLERY", true);
      }
      if (box.get("ALBUM_NAME") == null) {
        box.put("ALBUM_NAME", "WalpyPhotos");
      }
    });
    Hive.openBox("PATH_MAPS");
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    AvailableColors.list.shuffle();
    CategoryName.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bodies = [const HomePage(), const Saved(), const Profile()];
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.blue.shade50,
        statusBarColor: Colors.blue.shade100,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.blue.shade100,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.blue.shade50, boxShadow: [
            const BoxShadow(
              blurRadius: 10,
              color: Colors.black45,
              spreadRadius: 3,
            )
          ]),
          height: height * 0.08,
          width: width,
          child: Row(
            children: [
              BottomBarItem(
                selectedIndex: selectedIndex,
                index: 0,
                onTap: bottomBarClick,
              ),
              BottomBarItem(
                selectedIndex: selectedIndex,
                index: 1,
                onTap: bottomBarClick,
              ),
              BottomBarItem(
                selectedIndex: selectedIndex,
                index: 2,
                onTap: bottomBarClick,
              ),
            ],
          ),
        ),
        body: PageView(
          onPageChanged: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          controller: controller,
          children: bodies,
        ),
      ),
    );
  }

  bottomBarClick(int index) {
    if (index != selectedIndex) {
      setState(() {
        selectedIndex = index;
        controller.jumpToPage(index);
      });
    }
  }
}
