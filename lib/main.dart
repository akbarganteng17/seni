import 'package:flutter/material.dart';
import 'package:seni/pages/HomePage.dart';

void main() {
  runApp(ArtApp());
}

class ArtApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Art Institute of Chicago',
      theme: ThemeData.dark(),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
