import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:money_lover/firebaseService/user_services.dart';
import 'package:money_lover/models/user_model.dart';
import 'package:money_lover/view/setting_page/update_password_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  String gender = "man";
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
  }

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
        return const AlertDialog(
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
        const SnackBar(content: Text("Thông tin đã được cập nhật thành công")),
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không có ảnh nào được chọn.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(localizations.editProfile),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _updateProfile,
            child: Text(
              localizations.save,
              style: TextStyle(color: theme.brightness == Brightness.dark ? Colors.white : Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!) as ImageProvider
                          : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty
                          ? NetworkImage(_currentImageUrl!)
                          : AssetImage("assets/img/u1.png")) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: theme.primaryColor,
                        radius: 20,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              _buildTextField(localizations.name, _nameController, Icons.person),
              SizedBox(height: 16),
              _buildTextField(localizations.email, _emailController, Icons.email),
              SizedBox(height: 16),
              _buildTextField(localizations.age, _ageController, Icons.cake, isNumber: true),
              SizedBox(height: 24),
              Text(localizations.gender, style: theme.textTheme.titleMedium),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGenderButton("man", Icons.male, localizations.male),
                  SizedBox(width: 16),
                  _buildGenderButton("woman", Icons.female, localizations.female),
                ],
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.lock, color: Colors.white), // Đảm bảo màu sắc cho biểu tượng
                  label: Text(localizations.changePassword, style: TextStyle(color: Colors.white)), // Đảm bảo màu sắc cho nhãn
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePasswordScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).iconTheme.color), // Thay đổi màu sắc biểu tượng theo chủ đề
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildGenderButton(String value, IconData icon, String label) {
    final isSelected = gender == value;
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      icon: Icon(icon, color: isSelected ? Colors.white : theme.iconTheme.color),
      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color)),
      onPressed: () => setState(() => gender = value),
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
        backgroundColor: isSelected ? theme.primaryColor : theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}