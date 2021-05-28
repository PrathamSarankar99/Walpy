import 'package:flutter/material.dart';

class AnimatedListItemForBom extends StatefulWidget {
  final int index;
  final Widget child;
  final Axis scrollDirection;
  const AnimatedListItemForBom({
    Key key,
    @required this.index,
    @required this.child,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  @override
  _AnimatedListItemForBomState createState() => _AnimatedListItemForBomState();
}

class _AnimatedListItemForBomState extends State<AnimatedListItemForBom> {
  bool _animate = false;

  static bool _isStart = true;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _isStart
        ? Future.delayed(Duration(milliseconds: widget.index * 20), () {
            setState(() {
              _animate = true;
              _isStart = false;
            });
          })
        : _animate = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1000),
      opacity: _animate ? 1 : 0,
      curve: Curves.easeInOutQuart,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        padding: widget.scrollDirection == Axis.horizontal
            ? _animate
                ? EdgeInsets.only(left: 0)
                : const EdgeInsets.only(left: 100)
            : EdgeInsets.zero,
        margin: widget.scrollDirection == Axis.vertical
            ? _animate
                ? EdgeInsets.zero
                : const EdgeInsets.only(top: 100)
            : EdgeInsets.zero,
        child: widget.child,
      ),
    );
  }
}
