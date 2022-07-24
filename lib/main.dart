import 'package:flutter/material.dart';
import 'package:practice_app/responsive.dart';
import 'landscapeUpPicScr.dart';
import 'portraitUpPicScr.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StorageApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Responsive(
        desktop: UploadPictureScreen(),
        tablet: UploadPictureScreen(),
        mobile: UploadPictureScreenPortrait(),
      ),
    );
  }
}