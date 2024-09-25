import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:money_lover/models/user_model.dart';


class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Check email uniqueness
  Future<bool> isEmailUnique(String email) async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1) // Add a limit for efficiency
          .get();

      return result.docs.isEmpty;
    } catch (e) {
      print("Error checking email uniqueness: $e");
      return false;
    }
  }

  // Check name uniqueness
  Future<bool> isNameUnique(String name) async {
    try {
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      return result.docs.isEmpty;
    } catch (e) {
      print('Error checking name uniqueness: $e');
      return false;
    }
  }

  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      print('Login failed: $e');
      return false;
    }
  }

  // Register a new user
  Future<UserModel?> registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // Save user details to Firestore
        UserModel newUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          age: 0,
          // Placeholder, add proper validation later
          gender: '',
        );
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

        return newUser;
      }
      return null;
    } catch (e) {
      print("Registration failed: $e");
      return null;
    }
  }

  // Fetch user details
  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc =
      await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        print("User data found: ${doc.data()}");
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        print("No user data: $uid");
        return null;
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  // Update email
  Future<bool> updateEmail(String email) async {
    try {
      await _auth.currentUser!.updateEmail(email);
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'email': email});
      return true;
    } catch (e) {
      print("Error updating email: $e");
      return false;
    }
  }

  // Update password
  Future<bool> updatePassword(String password) async {
    try {
      await _auth.currentUser!.updatePassword(password);
      return true;
    } catch (e) {
      print("Error updating password: $e");
      return false;
    }
  }

  // Upload profile picture
  Future<String?> uploadProfilePicture(File imageFile, String uid) async {
    String userId = uid;
    //lay dinh dang file
    String fileExtension = imageFile.path.split('.').last.toLowerCase();
    //Tao tham chieu luu tru nhieu dinh dang
    Reference storageRef =
    _storage.ref().child('profile_image/$userId.${fileExtension}');

    try {
      //tai len file
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      //lay url tai xuong
      String downloadUrl = await snapshot.ref.getDownloadURL();

      //Cap nhat url vao firestore
      await _firestore.collection('users').doc(userId).update({
        'profileImageUrl': downloadUrl,
      });

      return downloadUrl;
    } catch (e) {
      print("Lỗi khi tải ảnh lên: $e");
      return null;
    }
  }

//Kiem tra dinh dang truoc khi tai len
  bool isValidImageFormat(String filePath) {
    final validFormats = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
    ];
    final extension = filePath.split('.').last.toLowerCase();
    return validFormats.contains(extension);
  }

}
