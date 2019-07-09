import 'package:flutter/material.dart';

//https://medium.com/@belchii/transition-fab-to-bottomnavigation-bb552f7088e6
class FABToBottomNavigationBar extends StatefulWidget {
  FABToBottomNavigationBar({Key key}) : super(key: key);

  _FABToBottomNavigationBarState createState() =>
      _FABToBottomNavigationBarState();
}

class _FABToBottomNavigationBarState extends State<FABToBottomNavigationBar>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<BorderRadius> _borderRadius;
  AlignmentTween alignment;
  Animation<double> height;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addStatusListener((status) {
            //setState(() {});
          });
    _borderRadius = BorderRadiusTween(
            begin: BorderRadius.circular(50), end: BorderRadius.circular(4))
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.100, curve: Curves.linear),
      ),
    );
    alignment = AlignmentTween(
        begin: Alignment.bottomRight, end: Alignment.bottomCenter);
    height = Tween<double>(begin: 50, end: 70).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.100, 0.250, curve: Curves.linear),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget getFab() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        return AlignTransition(
          alignment: alignment.animate(CurvedAnimation(
              parent: _animationController, curve: Curves.linear)),
          child: Container(
            height: height.value,
            width: 50,
            margin: EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              borderRadius: _borderRadius.value,
              color: Colors.blue,
            ),
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
