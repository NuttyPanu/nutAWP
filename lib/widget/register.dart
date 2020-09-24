import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuttypwa/model/usermodel.dart';
import 'package:nuttypwa/utility/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //get border => null;

  List<String> positions = [
    'Account Manager',
    'Administrative Officer',
    'Brand Manager',
    'Customer Service Executive',
    'Financial Analyst',
    'HR Generalist/ Specialist',
    'Logistic Manager',
    'GIS',
    'Developer'
  ];
  String choosePosition, name, user, password, uid, urlPath;
  double lat, lng;
  File file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
      print('lat = $lat,lng = $lng');
    });
  }

  Future<LocationData> findLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      print('e Findlocation ==> ${e.toString()}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.cloud_upload), onPressed: () => uploadImage()),
          ],
          backgroundColor: Colors.purple.shade700,
          title: Text('Register'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            buildAvatar(),
            buildName(),
            buildSizedBox(),
            buildPosition(),
            buildSizedBox(),
            buildUser(),
            buildSizedBox(),
            buildPassword(),
            buildSizedBox(),
            lat == null ? CircularProgressIndicator() : buildContainerMAP(),
          ]),
        ));
  }

  Set<Marker> mySet() {
    return <Marker>[
      Marker(
          markerId: MarkerId('myID'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: 'คุณอยู่ที่นี่',
            snippet: 'Lat : $lat, Long : $lng',
          ))
    ].toSet();
  }

  Container buildContainerMAP() {
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16,
    );

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.8,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: mySet(),
      ),
    );
  }

  SizedBox buildSizedBox() {
    return SizedBox(
      height: 16,
    );
  }

  Container buildPosition() => Container(
        width: 250,
        child: DropdownButton<String>(
          items: positions
              .map((e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                  ))
              .toList(),
          value: choosePosition,
          hint: Text('Position'),
          onChanged: (value) {
            setState(() {
              choosePosition = value;
            });
          },
        ),
      );

  Container buildName() {
    return Container(
        width: 250,
        child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: InputDecoration(
            hintText: 'Display Name',
            prefixIcon: Icon(Icons.face, color: Color(0xffe81ee8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ));
  }

  Container buildUser() {
    return Container(
        width: 250,
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            hintText: 'User',
            prefixIcon: Icon(Icons.account_box, color: Color(0xffe81ee8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ));
  }

  Container buildPassword() {
    return Container(
        width: 250,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: Icon(Icons.lock, color: Color(0xffe81ee8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ));
  }

  Future<Null> chooseAvatar(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      print('Path Image = ${result.path}');
      setState(() {
        file = File(result.path);
      });
    } catch (e) {}
  }

  Container buildAvatar() {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseAvatar(ImageSource.camera),
          ),
          Container(
            width: 180,
            height: 180,
            child: file == null
                ? Image.asset('images/avatar.png')
                : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: () => chooseAvatar(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Future<Null> uploadImage() async {
    print('name= $name usere =$user password=$password');
    if (file == null) {
      normalDialog(context, 'Pls choose Avatar');
    } else if (name == null ||
        name.isEmpty ||
        user == null ||
        user.isEmpty ||
        password == null ||
        password.isEmpty) {
      normalDialog(context, 'Pls กรอกข้อมูลให้ครบนะครับ ไม่เอาค่าว่าง');
    } else if (choosePosition == null) {
      normalDialog(context, 'Pls กรอกข้อมูลให้ครบนะครับ Position');
    } else {
      createAccount();
    }
  }

  Future<Null> createAccount() async {
    await Firebase.initializeApp().then((value) async {
      print('Success Connect');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user, password: password)
          .then((value) {
        uid = value.user.uid;
        print('Uid = $uid');
        uploadImageThread();
      }).catchError((value) {
        String string = value.message;
        normalDialog(context, string);
      });
    });
  }

  Future<Null> uploadImageThread() async {
    String nameImage = '$uid.jpg';
    StorageReference reference =
        FirebaseStorage.instance.ref().child('AvatarNutty/$nameImage');
    StorageUploadTask task = reference.putFile(file);
    urlPath = await (await task.onComplete).ref.getDownloadURL();
    print('Url Path=$urlPath');
    inserDataToFirebase();
  }

  Future<Null> inserDataToFirebase() async {
    UserModel model = UserModel(
        name: name,
        path: urlPath,
        position: choosePosition,
        lat: lat.toString(),
        lng: lng.toString());
    Map<String, dynamic> map = model.toJson();
    await FirebaseFirestore.instance
        .collection('UserNutty')
        .doc(uid)
        .set(map)
        .then((value) => Navigator.pop(context));
  }
}
