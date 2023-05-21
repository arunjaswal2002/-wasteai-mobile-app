// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/landingPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor kPrimaryColor = const MaterialColor(
      0xFF84D2C5,
      <int, Color>{
        50: Color(0xFF0E7AC7),
        100: Color(0xFF0E7AC7),
        200: Color(0xFF0E7AC7),
        300: Color(0xFF0E7AC7),
        400: Color(0xFF0E7AC7),
        500: Color(0xFF0E7AC7),
        600: Color(0xFF0E7AC7),
        700: Color(0xFF0E7AC7),
        800: Color(0xFF0E7AC7),
        900: Color(0xFF0E7AC7),
      },
    );
    return MaterialApp(
      title: 'Minor Project App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: kPrimaryColor,
          textTheme:
              GoogleFonts.josefinSansTextTheme((Theme.of(context).textTheme))),
      home: LandingPage(),
    );
  }
}
