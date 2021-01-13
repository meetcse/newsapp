import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/screens/homepage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter News',
      theme: ThemeData(
        primaryColor: Color(0xff3500d3),
        buttonColor: Color(0xff3500d3),
        textTheme:
            GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).copyWith(
          headline1: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xff3500d3),
          ),
          headline2: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          headline3: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          headline4: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          bodyText1: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          bodyText2: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          button: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
          subtitle1: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
