import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:page_transition/page_transition.dart';
import 'package:walpy/Modals/pixabay_image.dart';
import 'package:walpy/Screens/HomeScreens/preview.dart';

class BOM extends StatelessWidget {
  final PixabayImage image;
  final Function(PixabayImage) onTap;
  const BOM({Key key, @required this.onTap, @required this.image})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Hero(
      tag: image.imageURL,
      child: Container(
        width: width / 2.5,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        margin: const EdgeInsets.only(
          left: 8,
          top: 10,
          bottom: 10,
          right: 8,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: width / 2.5,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image.network(
                  image.imageURL,
                  fit: BoxFit.cover,
                  height: double.maxFinite,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null ||
                        (loadingProgress.expectedTotalBytes != null &&
                            loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes ==
                                1)) {
                      return child;
                    }
                    return Center(
                      child: Container(
                        height: width * 0.17,
                        width: width * 0.17,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      ),
                    );
                  },
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    }
                    return AnimatedOpacity(
                      child: child,
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeOut,
                    );
                  },
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                onTap(image);
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                )),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
              ),
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}

//BOM stands for Best of month.
