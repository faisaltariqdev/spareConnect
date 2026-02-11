import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spare_connect/utils/size_config.dart';
import 'package:spare_connect/widget/my_colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = "";
  String _email = "";
  String _phone = "";
  String _country = "";
  String _profilePictureUrl = "https://www.w3schools.com/w3images/avatar2.png"; // Default image
  bool _isEditing = false;
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      setState(() {
        _email = currentUser.email ?? "No email";
      });

      var userProfile = await getUserProfile(currentUser.uid);
      setState(() {
        _name = userProfile['name'] ?? "Guest";
        _phone = userProfile['phone'] ?? "Not Available";
        _country = userProfile['country'] ?? "Not Available";
        _profilePictureUrl = userProfile['profileImage'] ?? _profilePictureUrl;
        _nameController.text = _name;
        _phoneController.text = _phone;
        _countryController.text = _country;
      });

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      return userDoc.data() as Map<String, dynamic>;
    } else {
      return {};
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        String userId = FirebaseAuth.instance.currentUser!.uid;

        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('$userId.jpg');
        await ref.putFile(imageFile);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'profileImage': url,
        });

        setState(() {
          _profilePictureUrl = url;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  Future<void> _saveChanges() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'country': _countryController.text,
      });

      setState(() {
        _name = _nameController.text;
        _phone = _phoneController.text;
        _country = _countryController.text;
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile Updated!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(_profilePictureUrl),
                      backgroundColor: Colors.grey[300],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickAndUploadImage,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: MyColors.primaryColor,
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Profile Fields
              Text(
                "Your Profile",
                style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildProfileField("Name", _nameController),
              SizedBox(height: 20),
              _buildProfileField("Email", TextEditingController(text: _email), isEditable: false),
              SizedBox(height: 20),
              _buildProfileField("Phone", _phoneController),
              SizedBox(height: 20),
              _buildProfileField("Country", _countryController),
              SizedBox(height: 30),

              // Save Changes Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primaryColor,
                  padding: EdgeInsets.symmetric( vertical: 14,horizontal: 130),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _isEditing ? _saveChanges : () => setState(() => _isEditing = true),
                child: Text(
                  _isEditing ? "Save Changes" : "Edit Profile",
                  style: TextStyle(color: Colors.white, fontSize: getFont(16)),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, {bool isEditable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: MyColors.primaryColor, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Container(
          height: getHeight(60),
          child: TextField(
            
            controller: controller,
            enabled: isEditable,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.deepOrange, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
