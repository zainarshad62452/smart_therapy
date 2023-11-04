import 'package:cloud_firestore/cloud_firestore.dart';


class DoctorModel {
  String? uid;
  String? name;
  String? email;
  Timestamp? registeredOn;
  String? profileImageUrl;
  String? contactNo;
  String? type;
  String? userType;
  String? address;
  String? token;
  String? openHour;
  String? closeHour;
  double? rating;

  DoctorModel(
      {this.name,
        this.email,
        this.registeredOn,
        this.profileImageUrl,
        this.contactNo,
        this.type,
        this.uid,
        this.address,
        this.token,
        this.openHour,
        this.closeHour,
        this.rating,
        this.userType
      });

  DoctorModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    registeredOn = json['registeredOn'];
    profileImageUrl = json['image'];
    contactNo = json['phoneNumber'];
    userType = json['userType'];
    uid = json['uid'];
    address =json['address'];
    token = json['token'];
    openHour = json['openHour'];
    closeHour = json['closeHour'];
    rating = json['rating'];
    type = json['specification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['registeredOn'] = this.registeredOn;
    data['image'] = this.profileImageUrl;
    data['phoneNumber'] = this.contactNo;
    data['specification'] = this.type;
    data['uid'] = this.uid;
    data['token'] = this.token;
    data['rating'] = this.rating;
    data['closeHour'] = this.closeHour;
    data['address'] = this.address;
    data['openHour'] = this.openHour;
    data['userType'] = this.userType;
    return data;
  }
}
