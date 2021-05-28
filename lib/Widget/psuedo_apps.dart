import 'package:flutter/material.dart';

class PsuedoApps extends StatelessWidget {
  const PsuedoApps({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: 100,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.lightGreen,
            ),
            width: width * 0.15,
            height: width * 0.15,
            child: const Icon(
              Icons.phone,
              color: Colors.white,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            width: width * 0.15,
            height: width * 0.15,
            child: Image.asset(
              "assets/gallery_app.png",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            width: width * 0.16,
            height: width * 0.16,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: Image.asset(
                "assets/music_app.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(7.5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            width: width * 0.16,
            height: width * 0.16,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              child: Image.asset(
                "assets/settings_app.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
