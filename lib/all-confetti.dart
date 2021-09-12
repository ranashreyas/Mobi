import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class AllConfettiWidget extends StatefulWidget {
  // final Widget child;

  // const AllConfettiWidget() : super(key: key);
  @override
  _AllConfettiWidgetState createState() => _AllConfettiWidgetState();
}

class _AllConfettiWidgetState extends State<AllConfettiWidget> {
  ConfettiController controller;

  @override
  void initState() {
    super.initState();

    controller = ConfettiController(duration: Duration(seconds: 1));
    controller.play();
    Future.delayed(Duration(seconds: 1)).then((value) => controller.stop());

  }

  static final double right = 0;
  static final double down = pi / 2;
  static final double left = pi;
  static final double top = -pi / 2;

  final double blastDirection = top;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // widget.child,
        buildConfetti(),
      ],
    );
  }

  Widget buildConfetti() =>   Align(
    alignment: Alignment.topCenter,
    child: ConfettiWidget(
      confettiController: controller,
      colors: [
        Colors.red,
        Colors.blue,
        Colors.orange,
        Colors.purple,
        Colors.lightBlue,
      ],
      //blastDirection: blastDirection,
      blastDirectionality: BlastDirectionality.explosive,
      shouldLoop: true,
      emissionFrequency: 0.05,
      numberOfParticles: 5,
      gravity: 0.2,
      maxBlastForce: 2,
      minBlastForce: 1,
      particleDrag: 0.1,
    ),
  );
}