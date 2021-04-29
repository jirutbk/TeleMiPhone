import 'package:flutter/material.dart';
import 'package:telemiphone/main.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 5,
        navigateAfterSeconds: MainScreen(),
        title: Text("TeleMiPhone"),
        image: Image.asset("assets/myLogo.png"),
        photoSize: 80.0,
        gradientBackground: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.pink[100], Colors.pink[50]]),
        loaderColor: Colors.pinkAccent);
  }
}
