import 'package:flutter/material.dart';
import 'package:ui_samples/src/pages/login/index.dart';

void main() {
  ErrorWidget.builder = (FlutterErrorDetails details) => Container(
        child: Center(
          child: Text('Error occured. Please try again later.'),
        ),
      );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => MyHomePage(
                title: 'Flutter UI Samples',
              ),
          LoginPage.routeName: (context) => LoginPage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Login page1'),
              onPressed: () {
                Navigator.of(context).pushNamed(LoginPage.routeName);
              },
            )
          ],
        ),
      ),
    );
  }
}
