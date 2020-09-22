import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //global variable
  //array
  List<String> positions = [
    'gis',
    'finance',
    'hr',
    'admin',
    'manager',
    'user',
    'branch',
    'other'
  ];

  String choosePosition;
  double lat, lng;
  File file;
  // for init
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
      print('lat = $lat, lng = $lng');
    });
  }

  //method background
  Future<LocationData> findLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      print('e findLocation ==> ${e.toString()}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildAvatar(),
            buildName(),
            buildSizedBox(),
            buildSizedBox(),
            buildPosition(),
            buildSizedBox(),
            buildUser(),
            buildSizedBox(),
            //SizedBox(
            //  height: 16,
            //);
            buildPassword(),
            lat == null ? CircularProgressIndicator() : buildMap(),
            buildSizedBox(),
          ],
        ),
      ),
    );
  }

  Set<Marker> mySet() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myID'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: 'คุณอยู่ที่นี่',
          snippet: 'lat = $lat, lng = $lng',
        ),
      ),
    ].toSet();
  }

  Container buildMap() {
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
      // color: Colors.grey,
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
              .map(
                (e) => DropdownMenuItem(
                  child: Row(
                    children: [
                      Text(e),
                    ],
                  ),
                  value: e,
                ),
              )
              .toList(),
          value: choosePosition,
          hint: Text('Position Choose'),
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
        decoration: InputDecoration(
            hintText: 'Display Name',
            prefixIcon: Icon(
              Icons.face,
              //color: Color.fromRGBO(r, g, b, opacity),
              color: Color(0xFFE81EE8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.black38),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.blue),
            )),
      ),
    );
  }

  Container buildUser() {
    return Container(
      width: 250,
      child: TextField(
        decoration: InputDecoration(
            hintText: 'User',
            prefixIcon: Icon(
              Icons.account_circle,
              //color: Color.fromRGBO(r, g, b, opacity),
              color: Color(0xFFE81EE8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.black38),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.blue),
            )),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      width: 250,
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Password',
            prefixIcon: Icon(
              Icons.lock,
              //color: Color.fromRGBO(r, g, b, opacity),
              color: Color(0xFFE81EE8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.black38),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.blue),
            )),
      ),
    );
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
      margin: EdgeInsets.only(top: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => chooseAvatar(ImageSource.camera),
          ),
          Container(
            width: 180,
            height: 180,
            child: file == null
                ? Image.asset('images/avatar_.png')
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
}
