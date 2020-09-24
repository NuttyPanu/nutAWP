import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nuttypwa/widget/authen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FeelFan',
      home: Authen(),
    );
  }
}
