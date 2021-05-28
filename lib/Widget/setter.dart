import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walpy/Modals/Wallpaper.dart';

class Setter extends StatefulWidget {
  @override
  _SetterState createState() => _SetterState();
}

class _SetterState extends State<Setter> {
  bool lockscreen = false;
  bool homescreen = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                )),
                backgroundColor: MaterialStateProperty.all(lockscreen
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.transparent),
                minimumSize: MaterialStateProperty.all(Size(width * 0.5, 50)),
              ),
              onPressed: () {
                setState(() {
                  lockscreen = !lockscreen;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.lock,
                    color: !lockscreen ? Colors.blue : Colors.white,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Lock Screen",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: !lockscreen ? Colors.blue : Colors.white,
                    ),
                  )
                ],
              ),
            ),
            TextButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                )),
                backgroundColor: MaterialStateProperty.all(homescreen
                    ? Colors.blue.withOpacity(0.5)
                    : Colors.transparent),
                minimumSize: MaterialStateProperty.all(Size(width * 0.5, 50)),
              ),
              onPressed: () {
                setState(() {
                  homescreen = !homescreen;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.home,
                    color: !homescreen ? Colors.blue : Colors.white,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Home Screen",
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: !homescreen ? Colors.blue : Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            List<WallpaperLocation> wallpaper = [
              if (homescreen) WallpaperLocation.homescreen,
              if (lockscreen) WallpaperLocation.lockscreen,
            ];
            Navigator.pop(context, wallpaper);
          },
          child: Container(
            height: 30,
            width: 30,
            alignment: Alignment.centerLeft,
            child: RotatedBox(
                quarterTurns: 2,
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ),
      ],
    );
  }
}
