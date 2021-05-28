import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walpy/Modals/pixabay_image.dart';
import 'package:walpy/Services/pixabay_api.dart';

class Category extends StatefulWidget {
  final String categoryName;
  final Function(String) onTap;
  const Category({Key key, @required this.categoryName, @required this.onTap})
      : super(key: key);
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      width: width * 0.45,
      height: 80,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
              child: FutureBuilder<PixabayImage>(
                  future: PixabayApi.getUrl(widget.categoryName),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    return Image.network(
                      snapshot.data.imageURL,
                      alignment: Alignment.bottomCenter,
                      width: width * 0.45,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null ||
                            (loadingProgress.expectedTotalBytes != null &&
                                loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes ==
                                    1)) {
                          return child;
                        }
                        return Container(
                          height: 80,
                          width: width * 0.45,
                          alignment: Alignment.bottomCenter,
                          child: LinearProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                            color: Colors.white.withOpacity(0.8),
                            backgroundColor: Colors.transparent,
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
                    );
                  }),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onTap(widget.categoryName);
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            )),
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(),
              child: Text(
                widget.categoryName.substring(0, 1).toUpperCase() +
                    widget.categoryName
                        .substring(1, widget.categoryName.length),
                style: GoogleFonts.lexendDeca(
                    fontSize: 15,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                          color: Colors.black45,
                          blurRadius: 10,
                          offset: Offset(0, 0))
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
