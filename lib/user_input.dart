import 'dart:async';

import 'package:flutter/material.dart';

enum Direction { vertical, horizontal }

class SlideFadeTransition extends StatefulWidget {
  final Widget child;
  final double offset;
  final Curve curve;
  final Direction direction;
  final Duration delayStart;
  final Duration animationDuration;

  // const SlideFadeTransition(
  //     {super.key,
  //     required this.child,
  //     required this.offset,
  //     required this.curve,
  //     required this.direction,
  //     required this.delayStart,
  //     required this.animationDuration});

  const SlideFadeTransition({
    super.key,
    required this.child,
    this.offset = 1.0,
    this.curve = Curves.easeIn,
    this.direction = Direction.vertical,
    this.delayStart = const Duration(seconds: 0),
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  _SlideFadeTransitionState createState() => _SlideFadeTransitionState();
}

class _SlideFadeTransitionState extends State<SlideFadeTransition>
    with SingleTickerProviderStateMixin {
  late final Animation<Offset> _animationSlide;
  late final Animation<double> _animationFade;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    if (widget.direction == Direction.vertical) {
      _animationSlide = Tween<Offset>(begin: Offset(0, widget.offset)).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: widget.curve,
        ),
      );
    } else {
      _animationSlide = Tween<Offset>(
        begin: Offset(widget.offset, 0),
        end: const Offset(0, 0),
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: widget.curve,
        ),
      );
      Timer(widget.delayStart, () {
        _animationController.forward();
      });
    }

    _animationFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.curve,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationFade,
      child: SlideTransition(
        position: _animationSlide,
        child: widget.child,
      ),
    );
  }
}