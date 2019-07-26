import 'package:flutter/material.dart';
import 'dart:math' as Math;

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  AnimationController _userNameUnderLineAnimationController;
  Animation<double> _userNameUnderLineAnimation;

  AnimationController _userNameRightCurveAnimationController;
  Animation<double> _userNameRightCurveAnimation;

  double underLineWidth = 0;
  double curveAngle = 0;
  bool drawCheckMark = false;
  double checkMarkOpacity = 0.0;

  Focus userNameTextFieldFocusNode;

  final TextEditingController _userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userNameUnderLineAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _userNameRightCurveAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _userNameController.addListener(() {
      if (_userNameController.text.contains('@')) {
        if (!_userNameRightCurveAnimationController.isAnimating &&
            _userNameRightCurveAnimationController.isDismissed) {
          _userNameRightCurveAnimationController.forward();
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback(_initAnimations);
  }

  void _initAnimations(_) {
    final RenderBox userNameFocusRenderBox =
        _userNameFocusKey.currentContext.findRenderObject();
    _userNameUnderLineAnimation =
        Tween<double>(begin: 0, end: userNameFocusRenderBox.size.width).animate(
      CurvedAnimation(
          parent: _userNameUnderLineAnimationController, curve: Curves.easeIn),
    )..addListener(
            () {
              setState(() {
                underLineWidth = _userNameUnderLineAnimation.value;
              });
            },
          );

    _userNameRightCurveAnimation =
        Tween<double>(begin: 0.00, end: 0.75).animate(
      CurvedAnimation(
          parent: _userNameRightCurveAnimationController, curve: Curves.ease),
    )
          ..addListener(() {
            setState(() {
              curveAngle = _userNameRightCurveAnimation.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                //drawCheckMark = true;
                _userNameRightCurveAnimationController.reset();
                checkMarkOpacity = 1;
              });
            }
          });
  }

  final _userNameFocusKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: EdgeInsets.all(45),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  _buildUserName(),
                  Stack(
                    overflow: Overflow.visible,
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Container(
                        width: 0,
                        height: 43,
                        color: Colors.green,
                        child: CustomPaint(
                          painter: CurvePainter(angel: curveAngle),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: checkMarkOpacity,
                        duration: Duration(milliseconds: 200),
                        child: Container(
                          width: 25,
                          height: 25,
                          margin: EdgeInsets.only(left: 10),
                          child: CustomPaint(
                            painter: CheckMarkPainter(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextFormField(),
              RaisedButton(
                child: Text('Animate'),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget build1(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        padding: EdgeInsets.all(45),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: _buildUserName(),
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      Container(
                        width: 0,
                        height: 43,
                        color: Colors.green,
                        child: CustomPaint(
                          painter: CurvePainter(angel: curveAngle),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: checkMarkOpacity,
                        duration: Duration(milliseconds: 2),
                        child: CustomPaint(
                          size: Size(25, 25),
                          painter: CheckMarkPainter(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TextFormField(),
              RaisedButton(
                child: Text('Animate'),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return Container(
      key: _userNameFocusKey,
      child: Focus(
        onFocusChange: (focus) {
          if (focus) {
            Future.delayed(Duration(milliseconds: 200)).then((v) {
              _userNameUnderLineAnimationController.forward();
            });
          } else {
            _userNameUnderLineAnimationController.reset();
          }
        },
        child: CustomPaint(
          painter: LinePainter(underLineWidth: underLineWidth),
          child: TextFormField(
            controller: _userNameController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "User name",
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
            // decoration:
            //     InputDecoration.collapsed(hintText: "User name"),
          ),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final double underLineWidth;
  final bool drawArk;

  LinePainter({this.underLineWidth, this.drawArk = false});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(underLineWidth, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CurvePainter extends CustomPainter {
  final double angel;
  CurvePainter({this.angel});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;

    Offset center = Offset(size.width, size.height / 2);
    double radius = size.height / 2;

    double arcAngle = 2 * Math.pi * angel;

    Path path = Path();
    path.moveTo(size.width, size.height);

    //path.close();
    //canvas.drawPath(path, paint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), Math.pi / 2,
        -arcAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CheckMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;

    Path path = Path();
    print(size.width);
    print(size.height);
    path.moveTo(size.width / 4, size.height / 4);
    path.lineTo(size.width / 2, size.height / 2);
    path.close();

    path.moveTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
