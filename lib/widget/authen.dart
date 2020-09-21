import 'package:flutter/material.dart';

class Authen extends StatefulWidget {
  Authen({Key key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildContainer(),
            buildText(),
          ],
        ),
      ),
    );
  }

  Text buildText() => Text(
        'Nut PWA',
        style: TextStyle(
          fontSize: 30,
        ),
      );

  Container buildContainer() {
    return Container(
      width: 180,
      child: Image.asset('images/logo.png'),
    );
  }
}
