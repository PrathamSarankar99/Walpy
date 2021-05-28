import 'package:flutter/material.dart';

class AnimatedPage extends StatefulWidget {
  final Widget child;

  const AnimatedPage({Key key, @required this.child}) : super(key: key);
  @override
  _AnimatedPageState createState() => _AnimatedPageState();
}

class _AnimatedPageState extends State<AnimatedPage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> fadeanimation;
  Animation<double> translateanimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    fadeanimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.decelerate));
    translateanimation = Tween<double>(begin: 80, end: 0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.decelerate));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, translateanimation.value),
          child: FadeTransition(
            opacity: fadeanimation,
            child: child,
          ),
        );
      },
    );
  }
}
