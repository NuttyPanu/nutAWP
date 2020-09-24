import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuttypwa/utility/normal_dialog.dart';
import 'package:nuttypwa/widget/myservice.dart';
import 'package:nuttypwa/widget/register.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool statusRedEye = true;
  String user = '', password = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
          center: Alignment(0, -0.5),
          radius: 1.0,
          colors: [Colors.white, Colors.blue],
        )),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildContainer(),
                buildText(),
                buildContainerUser(),
                buildContainerPassword(),
                buildLogin(),
                buildFlatButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FlatButton buildFlatButton() => FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Register(),
              ));
        },
        child: Text(
          'New Register',
          style: TextStyle(color: Colors.pink),
        ),
      );

  Container buildLogin() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: RaisedButton(
        color: Colors.blue.shade700,
        onPressed: () async {
          print('user = $user , passwprd=$password');
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: user, password: password)
              .then((value) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyService(),
                  ),
                  (route) => false))
              .catchError((value) {
            String string = value.message;
            normalDialog(context, string);
          });
        },
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Container buildContainerUser() => Container(
      margin: EdgeInsets.only(top: 26),
      width: 250,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => user = value.trim(),
        decoration:
            InputDecoration(labelText: 'User :', border: OutlineInputBorder()),
      ));

  Container buildContainerPassword() => Container(
      margin: EdgeInsets.only(top: 26),
      width: 250,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: statusRedEye,
        decoration: InputDecoration(
          labelText: 'Password :',
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  statusRedEye = !statusRedEye;
                });
              }),
        ),
        //suff
      ));

  Text buildText() => Text(
        'FeelFan',
        style: GoogleFonts.rubik(
            textStyle: TextStyle(
          //fontWeigh:FontWeight.bold,
          fontSize: 30,
          color: Colors.blue.shade700,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
        )),
      );

  Container buildContainer() {
    return Container(width: 180, child: Image.asset('images/logo_.png'));
  }

  Future<Null> checkStatus() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        if (event != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyService()),
            (route) => false,
          );
        }
      });
    });
  }
}
