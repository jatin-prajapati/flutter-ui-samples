import 'package:flutter/material.dart';
import 'dart:math' as math;

//https://medium.com/@belchii/transition-fab-to-bottomnavigation-bb552f7088e6
class FABToBottomNavigationBar extends StatefulWidget {
  FABToBottomNavigationBar({Key key}) : super(key: key);

  _FABToBottomNavigationBarState createState() =>
      _FABToBottomNavigationBarState();
}

final double ALPHA_OFF = 0;
final double ALPHA_ON = 1;

class _FABToBottomNavigationBarState extends State<FABToBottomNavigationBar>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<BorderRadius> _borderRadius;
  AlignmentTween alignment;
  Animation<double> height;
  Animation<double> margin;
  Animation<double> opacity;
  Animation<double> width;
  Animation<Offset> alignmentOffset;

  double iconAlpha = ALPHA_ON;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addStatusListener((status) {
            _setIconAlpha();
          });
    _borderRadius = BorderRadiusTween(
            begin: BorderRadius.circular(50), end: BorderRadius.circular(0))
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.100, curve: Curves.linear),
      ),
    );
    alignment = AlignmentTween(
        begin: Alignment.bottomRight, end: Alignment.bottomCenter);
    height = Tween<double>(begin: 50, end: 60).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.100, 0.250, curve: Curves.linear),
      ),
    );
    margin = Tween<double>(begin: 15, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.700, curve: Curves.linear),
      ),
    );
    opacity = Tween<double>(begin: 1, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.100, curve: Curves.linear),
      ),
    );
  }

  _setIconAlpha() {
    setState(() {
      iconAlpha = _animationController.isDismissed ? ALPHA_OFF : ALPHA_ON;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    //screenSize.width.roundToDouble() / 5.4
    alignmentOffset = Tween<Offset>(begin: Offset(1, 1), end: Offset(0, 1.05))
        .animate(CurvedAnimation(
            parent: _animationController,
            curve: Interval(0, 0.100, curve: Curves.linear)));
    width =
        Tween<double>(begin: 50, end: screenSize.width.roundToDouble()).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.700, 0.900, curve: Curves.linear),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('FAB to Bottombar'),
      ),
      body: Container(
        child: Center(
          child: Text('FAB to Bottombar'),
        ),
      ),
      floatingActionButton: getFab(),
      // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget getFab() {
    print(MediaQuery.of(context).size.width.roundToDouble());
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        // return Align(
        //   child: Container(
        //     width: MediaQuery.of(context).size.width.roundToDouble(),
        //     height: 50,
        //     decoration: BoxDecoration(
        //       borderRadius: _borderRadius.value,
        //       color: Colors.blue,
        //     ),
        //   ),
        //   alignment: Alignment(
        //       MediaQuery.of(context).size.width.roundToDouble() / 5.3, 1.05),
        // );
        return Align(
          child: Stack(
            children: <Widget>[
              Container(
                height: 50,
                width: width.value,
                //margin: EdgeInsets.only(left: 25),
                decoration: BoxDecoration(
                  borderRadius: _borderRadius.value,
                  color: Colors.blue,
                ),
                child: GestureDetector(
                  child: Icon(Icons.arrow_back),
                  onTap: () {
                    if (_animationController.isDismissed) {
                      _animationController.forward();
                    } else {
                      _animationController.reverse();
                    }
                  },
                ),
              ),
            ],
          ),
          alignment:
              Alignment(alignmentOffset.value.dx, alignmentOffset.value.dy),
        );
      },
    );
  }

  Widget getFab1() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        return AlignTransition(
          alignment: alignment.animate(CurvedAnimation(
              parent: _animationController, curve: Curves.linear)),
          child: Container(
            height: height.value,
            width: width.value,
            margin: EdgeInsets.only(
              bottom: margin.value,
            ),
            decoration: BoxDecoration(
              borderRadius: _borderRadius.value,
              color: Colors.blue,
            ),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeIn,
              opacity: opacity.value,
              child: GestureDetector(
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  if (_animationController.isDismissed) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class FABAnimator extends FloatingActionButtonAnimator {
  @override
  Offset getOffset({Offset begin, Offset end, double progress}) {
    // TODO: implement getOffset
    return null;
  }

  @override
  Animation<double> getRotationAnimation({Animation<double> parent}) {
    // TODO: implement getRotationAnimation
    return null;
  }

  @override
  Animation<double> getScaleAnimation({Animation<double> parent}) {
    // TODO: implement getScaleAnimation
    return null;
  }
}
