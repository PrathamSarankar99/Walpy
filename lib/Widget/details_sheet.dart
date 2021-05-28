import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walpy/Modals/pixabay_image.dart';

class DetailSheet extends StatefulWidget {
  final PixabayImage image;

  const DetailSheet({Key key, @required this.image}) : super(key: key);
  @override
  _DetailSheetState createState() => _DetailSheetState();
}

class _DetailSheetState extends State<DetailSheet> {
  Color bgColor = Colors.white;
  TextStyle textstyle = GoogleFonts.varelaRound(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w100,
    //rgb(38, 39, 43)
  );
  bool isBasic = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // shrinkWrap: true,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 18, bottom: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: 65,
          width: MediaQuery.of(context).size.width,
          child: Text(
            "Details",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          alignment: Alignment.bottomLeft,
        ),
        Visibility(
          visible: isBasic,
          child: Column(
            children: [
              ListTile(
                tileColor: bgColor,
                leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.tag_rounded)),
                title: Text(
                  widget.image.tags,
                  style: textstyle,
                ),
                // subtitle: Text(widget.image.uploaderName),
              ),
              ListTile(
                onLongPress: () {
                  Clipboard.setData(ClipboardData(
                    text: widget.image.imageURL,
                  ));
                  Fluttertoast.showToast(
                    msg: "Copied",
                  );
                },
                tileColor: bgColor,
                leading: CircleAvatar(
                    backgroundColor: Colors.white, child: Icon(Icons.link)),
                title: Text(
                  widget.image.imageURL,
                  style: textstyle,
                ),
                // subtitle: Text(widget.image.uploaderName),
              ),
            ],
          ),
        ),
        (!isBasic
            ? additional(widget.image)
            : ListTile(
                tileColor: bgColor,
                trailing: TextButton(
                  onPressed: () {
                    setState(() {
                      isBasic = !isBasic;
                    });
                  },
                  child: Text(isBasic ? "Advanced" : "Basic",
                      style: GoogleFonts.varelaRound(
                        color: Colors.blue,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        //rgb(38, 39, 43)
                      )),
                ),
              )),
      ],
    );
  }

  Column additional(PixabayImage image) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          tileColor: bgColor,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              image.uploaderImageURL,
            ),
          ),
          title: Text(
            image.uploaderName,
            style: GoogleFonts.varelaRound(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w100,
              //rgb(38, 39, 43)
            ),
          ),
          subtitle: Text(
            "Owner",
          ),
        ),
        ListTile(
          tileColor: bgColor,
          leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.remove_red_eye_outlined)),
          title: Text(
            "Views",
            style: GoogleFonts.varelaRound(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w100,
              //rgb(38, 39, 43)
            ),
          ),
          subtitle: Text(
            image.views.toString(),
          ),
          // subtitle: Text(widget.image.uploaderName),
        ),
        ListTile(
          tileColor: bgColor,
          leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.thumb_up_rounded)),
          title: Text(
            "Likes",
            style: GoogleFonts.varelaRound(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w100,
              //rgb(38, 39, 43)
            ),
          ),
          subtitle: Text(
            image.likes.toString(),
          ),
          // subtitle: Text(widget.image.uploaderName),
        ),
        ListTile(
          tileColor: bgColor,
          leading: CircleAvatar(
              backgroundColor: Colors.white, child: Icon(Icons.download)),
          title: Text(
            "Downloads",
            style: GoogleFonts.varelaRound(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w100,
              //rgb(38, 39, 43)
            ),
          ),
          subtitle: Text(
            image.downloads.toString(),
          ),
          // subtitle: Text(widget.image.uploaderName),
        ),
        ListTile(
          tileColor: bgColor,
          leading: CircleAvatar(
              backgroundColor: Colors.white, child: Icon(Icons.comment)),
          title: Text(
            "Comments",
            style: GoogleFonts.varelaRound(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w100,
              //rgb(38, 39, 43)
            ),
          ),
          subtitle: Text(
            image.comments.toString(),
          ),
          // subtitle: Text(widget.image.uploaderName),
        ),
        ListTile(
          tileColor: bgColor,
          trailing: TextButton(
            onPressed: () {
              setState(() {
                isBasic = !isBasic;
              });
            },
            child: Text(isBasic ? "Advanced" : "Basic",
                style: GoogleFonts.varelaRound(
                  color: Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  //rgb(38, 39, 43)
                )),
          ),
        ),
      ],
    );
  }
}
