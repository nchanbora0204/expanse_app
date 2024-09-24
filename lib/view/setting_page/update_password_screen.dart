import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdatePasswordScreen extends StatefulWidget {
  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _updatePassword() async {
    final user = _auth.currentUser;
    if (user == null) {
      // Nếu user không đăng nhập, hãy xử lý thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:  Text('User is not signed in')),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content:  Row(
            children:  [
              CircularProgressIndicator(),
              SizedBox(
                width: 20,
              ),
               Text("Đang cập nhật mật khẩu"),
            ],
          ),
        );
      },
    );
    try {
      // Xác thực lại bằng mật khẩu cũ
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPasswordController.text,
      );
      await Future.delayed(
        const Duration(seconds: 3),
      );
      //Xac thuc lai voi thong tin tren
      await user.reauthenticateWithCredential(cred);

      // Sau khi xác thực thành công, cập nhật mật khẩu mới
      await user.updatePassword(_newPasswordController.text);

       ScaffoldMessenger.of(context).showSnackBar (
        const SnackBar(content:  Text('Password updated successfully')),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to update password';
      if (e.code == 'wrong-password') {
        message = 'Old password is incorrect';
      } else if (e.code == 'weak-password') {
        message = 'New password is too weak';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.changePassword), // Đổi ngôn ngữ tiêu đề
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: !_isOldPasswordVisible,
              decoration: InputDecoration(
                labelText: localizations.oldPassword,
                // Sử dụng chuỗi đa ngôn ngữ
                suffixIcon: IconButton(
                  icon: Icon(
                    _isOldPasswordVisible ? Ionicons.eye : Ionicons.eye_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isOldPasswordVisible = !_isOldPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _newPasswordController,
              obscureText: !_isNewPasswordVisible,
              decoration: InputDecoration(
                labelText: localizations.newPassword,
                // Sử dụng chuỗi đa ngôn ngữ
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordVisible ? Ionicons.eye : Ionicons.eye_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePassword,
              child: Text(
                  localizations.changePassword), // Sử dụng chuỗi đa ngôn ngữ
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}
