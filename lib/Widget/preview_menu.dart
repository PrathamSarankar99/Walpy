import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PreviewMenu extends StatelessWidget {
  final String asset;
  final String text;
  final Color color;
  final bool isActive;
  final Function onPressed;
  const PreviewMenu(
      {Key key,
      @required this.asset,
      this.text = "",
      this.color,
      @required this.onPressed,
      this.isActive = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(color),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ))),
            onPressed: isActive
                ? () {
                    onPressed();
                  }
                : null,
            child: Container(
              padding: EdgeInsets.all(10),
              height: width * 0.12,
              width: width * 0.12,
              child: SvgPicture.asset(
                asset,
                color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
              ),
            )),
        const SizedBox(height: 5),
        Text(
          text,
          style: GoogleFonts.poppins(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
            shadows: [
              Shadow(
                color: isActive ? Colors.black : Colors.transparent,
                offset: const Offset(0, 0),
                blurRadius: 20,
              )
            ],
          ),
        ),
      ],
    );
  }
}
