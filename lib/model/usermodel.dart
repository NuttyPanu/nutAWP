class UserModel {
  String name;
  String path;
  String lat;
  String lng;
  String position;

  UserModel({this.name, this.path, this.lat, this.lng, this.position});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    path = json['Path'];
    lat = json['Lat'];
    lng = json['Lng'];
    position = json['Position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Path'] = this.path;
    data['Lat'] = this.lat;
    data['Lng'] = this.lng;
    data['Position'] = this.position;
    return data;
  }
}
