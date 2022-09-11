import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? NID;
  final String? Name;
  final String? Password;
  final String? PhoneNO;
  final String? birthDate;
  final String? photo;
  final String? rate;
  final int? status;
  final String userName;

  UserModel(
      {this.NID,
      this.Name,
      this.Password,
      this.PhoneNO,
      this.birthDate,
      this.photo,
      this.rate,
      this.status,
      required this.userName});

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      NID: snapshot['NID'],
      Name: snapshot['Name'],
      Password: snapshot['Password'],
      PhoneNO: snapshot['PhoneNO'],
      birthDate: snapshot['birthDate'],
      photo: snapshot['photo'],
      rate: snapshot['rate'],
      status: snapshot['status'],
      userName: snapshot['userName'],
    );
  }

  Map<String, dynamic> toJson() => {
        "NID": NID,
        "Name": Name,
        "Password": Password,
        "PhoneNO": PhoneNO,
        "birthDate": birthDate,
        "photo": photo,
        "rate": rate,
        "status": status,
        "userName": userName
      };
}
