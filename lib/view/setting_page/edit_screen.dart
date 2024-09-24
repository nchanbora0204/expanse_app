import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:money_lover/view/login/user_model.dart';
import 'package:money_lover/view/setting_page/edit_item.dart';
import 'package:money_lover/view/login/user_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'update_password_screen.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  String gender = "man";
  UserModel? userDetails;
  File? _imageFile;
  String? _currentImageUrl;
  final UserService _userService = UserService();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    // _initializePermissions();
  }

  // Future<void> _initializePermissions() async {
  //   if (Platform.isAndroid) {
  //     if (await Permission.storage.status.isDenied) {
  //       await Permission.storage.request();
  //     }
  //     if (await Permission.photos.status.isDenied) {
  //       await Permission.photos.request();
  //     }
  //   } else {
  //     await Permission.photos.request();
  //   }
  // }

  Future<void> _initializeUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      UserModel? userDetails = await _userService.getUserDetails(user.uid);
      if (userDetails != null) {
        setState(() {
          _emailController.text = userDetails.email;
          _nameController.text = userDetails.name;
          gender = userDetails.gender.isNotEmpty ? userDetails.gender : 'man';
          _ageController.text = userDetails.age.toString();
          _currentImageUrl = userDetails.profileImageUrl ?? '';
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Đang cập nhật..."),
            ],
          ),
        );
      },
    );

    try {
      // Update email
      if (_emailController.text.isNotEmpty &&
          _emailController.text != user.email) {
        await _userService.updateEmail(_emailController.text);
      }

      // Update profile picture
      String? profileImageUrl;
      if (_imageFile != null) {
        profileImageUrl =
            await _userService.uploadProfilePicture(_imageFile!, user.uid);
        setState(() {
          _currentImageUrl = profileImageUrl;
          _imageFile = null;
        });
      }

      // Update other info in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': _nameController.text,
        'gender': gender,
        'age': int.tryParse(_ageController.text) ?? 0,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      });

      await _initializeUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Thông tin đã được cập nhật thành công")),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đã xảy ra lỗi: $e")),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  // Future<void> _pickImage() async {
  //   debugPrint('Pick image Called');
  //
  //   PermissionStatus status;
  //   if (Platform.isAndroid) {
  //     if (await Permission.storage.status.isDenied) {
  //       status = await Permission.storage.request();
  //     } else if (await Permission.photos.status.isDenied) {
  //       status = await Permission.photos.request();
  //     } else {
  //       status = PermissionStatus.granted;
  //     }
  //   } else {
  //     status = await Permission.photos.request();
  //   }
  //
  //   debugPrint('Permission status: $status');
  //
  //   if (status.isGranted) {
  //     final picker = ImagePicker();
  //     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //     if (pickedFile != null) {
  //       setState(() {
  //         _imageFile = File(pickedFile.path);
  //       });
  //     }
  //   } else if (status.isPermanentlyDenied) {
  //     _showPermissonDeniedDialog(context);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(AppLocalizations.of(context)!.permissionDenied),
  //         action: SnackBarAction(
  //           label: 'Thử lại',
  //           onPressed: () => _pickImage(),
  //         ),
  //       ),
  //     );
  //   }
  // }
  Future<void> _pickImage() async {
    debugPrint('Pick image Called');

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Không có ảnh nào được chọn."),
        ),
      );
    }
  }



  // void _showPermissonDeniedDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text("Quyền truy cập bị từ chối"),
  //           content: Text(
  //               "Ứng dụng cần quyền truy cập thư viện ảnh để thay đổi ảnh đại diện. "
  //               "Vui lòng vào Cài đặt và cấp quyền truy cập."),
  //           actions: [
  //             TextButton(
  //               child: Text("Hủy"),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //               child: Text("Mở cài đặt"),
  //               onPressed: () {
  //                 openAppSettings();
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editProfile),
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Ionicons.chevron_back_outline,
              color: theme.appBarTheme.foregroundColor),
        ),
        leadingWidth: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: _updateProfile,
              icon: Icon(Ionicons.checkmark,
                  color: theme.appBarTheme.foregroundColor),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(localizations.account,
                  style: textTheme.headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              EditItem(
                title: localizations.photo,
                widget: Column(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                              )
                            : (_currentImageUrl != null &&
                                    _currentImageUrl!.isNotEmpty
                                ? Image.network(
                                    _currentImageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stckTrace) {
                                      return Image.asset(
                                        "assets/img/u1.png",
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    "assets/img/u1.png",
                                    fit: BoxFit.cover,
                                  )),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.lightBlueAccent),
                      child: Text(localizations.changePhoto),
                    ),
                  ],
                ),
              ),
              EditItem(
                title: localizations.name,
                widget: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: localizations.name)),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: localizations.gender,
                widget: Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => gender = "man"),
                      style: IconButton.styleFrom(
                        backgroundColor: gender == "man"
                            ? Colors.deepPurple
                            : Colors.grey.shade200,
                        fixedSize: Size(50, 50),
                      ),
                      icon: Icon(Ionicons.male,
                          color: gender == "man" ? Colors.green : Colors.grey,
                          size: 18),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () => setState(() => gender = "woman"),
                      style: IconButton.styleFrom(
                        backgroundColor: gender == "woman"
                            ? Colors.purpleAccent
                            : Colors.grey.shade200,
                        fixedSize: Size(50, 50),
                      ),
                      icon: Icon(Ionicons.female,
                          color: gender == "woman" ? Colors.green : Colors.grey,
                          size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: localizations.age,
                widget: TextField(
                    controller: _ageController,
                    decoration: InputDecoration(hintText: localizations.age)),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: localizations.email,
                widget: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: localizations.email)),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: localizations.password,
                widget: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdatePasswordScreen()));
                  },
                  child: Text(
                    localizations.changePassword,
                    style:
                        TextStyle(color: Colors.lightBlueAccent, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
