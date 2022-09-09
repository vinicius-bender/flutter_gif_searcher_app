import 'package:flutter/material.dart';
import 'package:gifapp/UI/home_page.dart';

void main (){
  runApp(const GifApp());
}

class GifApp extends StatelessWidget{
  const GifApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      textTheme: const TextTheme(subtitle1: TextStyle(color: Colors.white))),
      home: const GifAppHomePage(),
    );
  }
}