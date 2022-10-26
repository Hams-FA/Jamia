import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? Email;
  final String? NID;
  final String? fname;
  final String? Password;
  final String? PhoneNO;
  final String? birthDate;
  final String? photo;
  final String? rate;
  final int? status;
  final String? lname;

  UserModel(
      {this.Email,
      this.NID,
      this.fname,
      this.Password,
      this.PhoneNO,
      this.birthDate,
      this.photo,
      this.rate,
      this.status,
      this.lname});

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      Email: snapshot['Email'],
      NID: snapshot['NID'],
      fname: snapshot['fname'],
      Password: snapshot['Password'],
      PhoneNO: snapshot['PhoneNO'],
      birthDate: snapshot['birthDate'],
      photo: snapshot['photo'],
      rate: snapshot['rate'],
      status: snapshot['status'],
      lname: snapshot['lname'],
    );
  }

  Map<String, dynamic> toJson() => {
        "Email": Email,
        "NID": NID,
        "fname": fname,
        "Password": Password,
        "PhoneNO": PhoneNO,
        "birthDate": birthDate,
        "photo": photo,
        "rate": rate,
        "status": status,
        "lname": lname,
      };
}
