import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String? uid;
  String? displayName;
  String? email;
  String? role;
  String? status;
  String? base;
  String? phoneNumber;
  String? photoURL;
  String? workSchedule;
  Timestamp? createdAt;
  Timestamp? lastLogin;

  User({
    this.uid,
    this.displayName,
    this.email,
    this.role,
    this.status,
    this.base,
    this.phoneNumber,
    this.photoURL,
    this.workSchedule,
    this.createdAt,
    this.lastLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'role': role ?? 'user',
      'status': status ?? 'active',
      'base': base ?? '',
      'phoneNumber': phoneNumber ?? '',
      'photoURL': photoURL ?? '',
      'workSchedule': workSchedule ?? '',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'lastLogin': lastLogin ?? FieldValue.serverTimestamp(),
    };
  }
}