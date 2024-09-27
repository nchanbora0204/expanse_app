import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:money_lover/models/user_model.dart';


class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

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
      return true;
    } catch (e) {
      print('Đăng Nhập Thất Bại: $e');
      return false;
    }
  }


  //Login with facebook
  Future<bool> signInWithFacebook() async {
    try {
      //Thuc hien dang nhap qua fb
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        //Nhan token tu Facebook
        final AccessToken accessToken = result.accessToken!;

        //Dang nhap firebase voi credential tu facebook
        final OAuthCredential credential = FacebookAuthProvider.credential(
            accessToken.tokenString);
        final UserCredential userCredential = await _auth.signInWithCredential(
            credential);

        //Dang nhap thanh cong neu user kh null
        if (userCredential.user != null) {
          //Lay thong tin nguoi dung tu Facebook
          final userData = await FacebookAuth.instance.getUserData();

          //Tao hoac cap nhat thong tin nguoi dung trong fire store
          UserModel userModel = UserModel(
            uid: userCredential.user!.uid,
            name: userData['name'] ?? '',
            email: userData['email'] ?? '',
            age: 0,
            gender: userData['gender'] ?? '',
            profileImageUrl: userData['picture']['data']['url'] ?? '',
          );

          await _firestore.collection('user').doc(userCredential.user!.uid).set(
            userModel.toMap(), SetOptions(merge: true),);

          return true;
        }
      }
      return false;
    } catch (e) {
      print('Loi khi dang nhap facebook: $e');
      return false;
    }
  }

  Future<void> saveUserDetails(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(
        user.toMap(), SetOptions(merge: true));
  }

  // Register a new user
  Future<UserModel?> registerWithEmailAndPassword(String name, String email,
      String password) async {
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


  //Service luu tru Info
  // Future<bool> saveLoginInfo(String email, String token) async {
  //   try {
  //     await _secureStorage.write(key: 'email', value: email);
  //     await _secureStorage.write(key: 'token', value: token);
  //     return true;
  //   }catch (e) {
  //     print('Lỗi khi lưu thông tin đăng nhập: $e');
  //     return false;
  //   }
  // }
  //
  // //Service đọc thông tin người dùng
  // Future<Map<String, String?>> getLoginInfo() async {
  //   try {
  //     String? email = await _secureStorage.read(key: 'email');
  //     String? token = await _secureStorage.read(key: 'token');
  //     return {'email' : email, 'token': token};
  //   }catch (e) {
  //     print('Lỗi khi đọc thông tin đăng nhập');
  //     return {};
  //   }
  // }
  //
  // //Service Dang nhap bang sinh trac hoc
  // Future<bool> authenticateWithBiometrics() async {
  //   try {
  //     bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
  //     if (!canCheckBiometrics) {
  //       print('Thiết bị không hỗ trợ xác thực sinh trắc học');
  //       return false;
  //     }
  //
  //     List<BiometricType> availibleBiometrics = await _localAuth
  //         .getAvailableBiometrics();
  //
  //     String authMethod = 'Sinh Trắc Học';
  //     if (availibleBiometrics.contains(BiometricType.face)) {
  //       authMethod = 'Nhận Diện Khuôn Mặt';
  //     } else if (availibleBiometrics.contains(BiometricType.fingerprint)) {
  //       authMethod = 'Vân Tay';
  //     }
  //
  //     return await _localAuth.authenticate(
  //       localizedReason: 'Xác thực bằng $authMethod để đăng nhập',
  //       options: const AuthenticationOptions(
  //         stickyAuth: true,
  //         biometricOnly: true,
  //       ),);
  //   }catch (e) {
  //     print('Lỗi khi xác thực bằng sinh trắc học: $e');
  //     return false;
  //   }
  // }
  //
  // //Service cho trang QuickSignIn
  // Future<bool> quickSignIn() async {
  //   Map<String, String?> loginInfo = await getLoginInfo();
  //   String? email = loginInfo['email'];
  //   String? token = loginInfo['token'];
  //
  //   if (email != null && token != null) {
  //     bool authenticated = await authenticateWithBiometrics();
  //     if (authenticated){
  //       // Thực hiện đăng nhập với token
  //       // Ví dụ: await _auth.signInWithCustomToken(token);
  //       await _auth.signInWithCustomToken(token);
  //       return true;
  //     }
  //
  //   }
  //   return false;
  // }

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
    String fileExtension = imageFile.path
        .split('.')
        .last
        .toLowerCase();
    //Tao tham chieu luu tru nhieu dinh dang
    Reference storageRef =
    _storage.ref().child('profile_image/$userId.$fileExtension');

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
    final extension = filePath
        .split('.')
        .last
        .toLowerCase();
    return validFormats.contains(extension);
  }

}
