import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:cat_dog_classifier/home.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      // Splash screen load time
      seconds: 2,
      navigateAfterSeconds: Home(),
      title: Text(
        'Dog and Cat',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 32,
          color: Color(0xFFFFFFFF),
        ),
      ),
      image: Image.asset('assets/cat_dog.png'),
      photoSize: 100.0,
      backgroundColor: Color(0xFF22252B),
      loaderColor: Color(0xFF3DD6AA),
    );
  }
}
