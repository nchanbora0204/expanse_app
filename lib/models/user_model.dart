import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String uid;
  String name;
  String email;
  int age; // Đổi thành int
  String gender;
  String profileImageUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    this.profileImageUrl = '',
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      age: (data['age'] is int) ? data['age'] : int.tryParse(data['age'].toString()) ?? 0, // Chuyển đổi kiểu dữ liệu
      gender: data['gender'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'profileImageUrl': profileImageUrl,
    };
  }
}
