import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walpy/Modals/AvailableColors.dart';

class Filter extends StatefulWidget {
  final List<String> colors;
  const Filter({Key key, @required this.colors}) : super(key: key);
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  List<String> selectedColors;

  @override
  void initState() {
    selectedColors = widget.colors;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.fromLTRB(
            width * 0.1, height * 0.13, width * 0.1, height * 0.13),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 15),
                  child: Text("Available Colors",
                      style: GoogleFonts.varelaRound(
                        color: const Color.fromRGBO(38, 39, 43, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        //rgb(38, 39, 43)
                      )),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 0),
              child: Divider(
                height: 2,
                thickness: 2,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: AvailableColors.list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        if (selectedColors
                            .contains(AvailableColors.list[index])) {
                          selectedColors.removeWhere((element) =>
                              element == AvailableColors.list[index]);
                        } else {
                          selectedColors.add(AvailableColors.list[index]);
                        }
                      });
                    },
                    title: Text(AvailableColors.list[index]),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: AvailableColors
                              .colorForCode[AvailableColors.list[index]],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Checkbox(
                        checkColor: Colors.white.withRed(100),
                        fillColor:
                            MaterialStateProperty.all(Colors.transparent),
                        value: selectedColors
                            .contains(AvailableColors.list[index]),
                        onChanged: (val) {},
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 50,
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context, selectedColors);
                },
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(0, 50)),
                    shape: MaterialStateProperty.all(const CircleBorder())),
                child: const Icon(Icons.arrow_forward),
              ),
            )
          ],
        ),
      ),
    );
  }
}
