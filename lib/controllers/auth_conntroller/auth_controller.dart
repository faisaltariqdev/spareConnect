//
//
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:spare_connect/view/homepage/homepage.dart';
// import 'package:spare_connect/view/seller/seller_dashboard.dart';
// import 'package:spare_connect/widget/custom_toast.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../../utils/permission_photos.dart';
//
// class AuthController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   var nameController = TextEditingController();
//   var emailController = TextEditingController();
//   var passwordController = TextEditingController();
//   var phoneController = TextEditingController();
//   var countryController = TextEditingController();
//   var businessNameController = TextEditingController();
//   var businessAddressController = TextEditingController();
//   var DOBController = TextEditingController();
//
//   var userType = 'customer'.obs; // Default is customer
//   var galleryImg = Rx<File?>(null);
//   int pic = 1;
//   var galleryImgCompress = "".obs;
//   var selectedGalleryImg = ''.obs;
//
//   // Handle gallery image selection and compression
//   openGallery(int index, BuildContext context, {bool hitApi = false}) async {
//     PermissionOfPhotos().getFromGallery(context).then((value) async {
//       if (value) {
//         await getImage(ImageSource.gallery, index, hitApi: hitApi);
//         update();
//       } else {
//         print("Permission denied");
//       }
//     });
//   }
//
//   // Handle camera image selection and compression
//   openCamera(int index, BuildContext context, {bool hitApi = false}) async {
//     PermissionOfPhotos().getFromCamera(context).then((value) async {
//       if (value) {
//         await getImage(ImageSource.camera, index, hitApi: hitApi);
//       } else {
//         print("Permission denied");
//       }
//     });
//   }
//
//   // Pick an image from gallery or camera and compress it
//   Future getImage(ImageSource imageSource, int index, {bool hitApi = false}) async {
//     final pickedFile = await ImagePicker().pickImage(source: imageSource);
//
//     if (pickedFile != null) {
//       switch (index) {
//         case 0:
//           {
//             selectedGalleryImg.value = pickedFile.path;
//             final dir1 = Directory.systemTemp;
//             final targetPath1 = dir1.absolute.path + "/pic${pic++}.jpg";
//             var compressedFile1 = await FlutterImageCompress.compressAndGetFile(
//                 selectedGalleryImg.value, targetPath1,
//                 quality: 60);
//             galleryImgCompress.value = compressedFile1!.path;
//             galleryImg = File(galleryImgCompress.value) as Rx<File?>;
//           }
//           break;
//         default:
//           print("Nothing is selected");
//           break;
//       }
//     } else {
//       CustomToast.failToast("No image was selected");
//     }
//   }
//
//
//   var isLoading = false.obs; // To handle loading states
//
//   // Function to handle login
//   Future<void> login() async {
//     try {
//       isLoading.value = true; // Show loader
//       if (_validateLoginInputs()) {
//         // Sign in with Firebase Auth
//         UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//         );
//
//         User? user = userCredential.user;
//         if (user != null) {
//           // Fetch user data from Firestore
//           DocumentSnapshot userDoc = await FirebaseFirestore.instance
//               .collection('users')
//               .doc(user.uid)
//               .get();
//
//           if (userDoc.exists) {
//             String userType = userDoc.get('userType');
//
//             // Navigate based on userType
//             if (userType == 'seller') {
//               Get.off(() => SellerDashboardScreen());
//             } else {
//               Get.off(() => HomePage());
//             }
//           } else {
//             CustomToast.failToast("User data not found in Firestore");
//           }
//         }
//       }
//     } catch (e) {
//       CustomToast.failToast("Login failed: ${e.toString()}");
//       print("Login Failed: $e");
//     } finally {
//       isLoading.value = false; // Hide loader
//     }
//   }
//
//   // Input validation for login
//   bool _validateLoginInputs() {
//     if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
//       CustomToast.failToast("Invalid email");
//       return false;
//     }
//     if (passwordController.text.isEmpty || passwordController.text.length < 6) {
//       CustomToast.failToast("Password must be at least 6 characters");
//       return false;
//     }
//     return true;
//   }
//
//
//   // Function to create account
//   Future<void> createAccount() async {
//     try {
//       if (_validateInputs()) {
//         // Register user with Firebase Auth
//         UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//         );
//
//         // After successful registration, create a user document in Firestore
//         User? user = userCredential.user;
//         if (user != null) {
//           Get.back();
//           // Save user details to Firestore
//           await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//             'name': nameController.text,
//             'email': emailController.text,
//             'phone': phoneController.text,
//             'country': countryController.text,
//             'DOB': DOBController.text,
//             'userType': userType.value, // Save whether user is a customer or seller
//             'businessName': userType.value == 'seller' ? businessNameController.text : null,
//             'businessAddress': userType.value == 'seller' ? businessAddressController.text : null,
//           });
//
//           // Show success message
//           CustomToast.successToast("Account created successfully");
//           print("Account Created Successfully");
//
//           // Debugging: Print userType to ensure it's set correctly
//           print("UserType: ${userType.value}");
//
//           // Navigate to the appropriate page based on user type
//           if (userType.value == 'seller') {
//             Get.toNamed('/sellerDashboard');
//           } else {
//             Get.toNamed('/homePage');
//           }
//
//         }
//       }
//     } catch (e) {
//       CustomToast.failToast("Failed to create account: ${e.toString()}");
//       print("Create Account Failed: $e");
//     }
//   }
//
//
//
//
//   // Input validation
//   bool _validateInputs() {
//     if (nameController.text.isEmpty) {
//       CustomToast.failToast("Name is required");
//       return false;
//     }
//     if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
//       CustomToast.failToast("Invalid email");
//       return false;
//     }
//     if (passwordController.text.isEmpty || passwordController.text.length < 6) {
//       CustomToast.failToast("Password must be at least 6 characters");
//       return false;
//     }
//     if (phoneController.text.isEmpty || phoneController.text.length != 11) {
//       CustomToast.failToast("Invalid phone number");
//       return false;
//     }
//     return true;
//   }
//
//
//   // Function to reset password
//   Future<void> resetPassword() async {
//     try {
//       isLoading.value = true; // Show loading indicator
//       String email = emailController.text.trim();
//
//       if (email.isEmpty || !GetUtils.isEmail(email)) {
//         CustomToast.failToast("Please enter a valid email address");
//         return;
//       }
//
//       // Send password reset email using Firebase Auth
//       await _auth.sendPasswordResetEmail(email: email);
//
//       CustomToast.successToast("Password reset email sent successfully");
//
//       // Optionally, navigate back to the login screen
//       Get.back();
//     } catch (e) {
//       CustomToast.failToast("Failed to send password reset email: ${e.toString()}");
//       print("Password Reset Error: $e");
//     } finally {
//       isLoading.value = false; // Hide loading indicator
//     }
//   }
//
//
//
//   @override
//   void onClose() {
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     phoneController.dispose();
//     countryController.dispose();
//     businessNameController.dispose();
//     businessAddressController.dispose();
//     super.onClose();
//   }
// }


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/permission_photos.dart';
import '../../view/homepage/homepage.dart';
import '../../view/seller/seller_dashboard.dart';
import '../../widget/custom_toast.dart';


class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var countryController = TextEditingController();
  var businessNameController = TextEditingController();
  var cnicController = TextEditingController();
  var businessAddressController = TextEditingController();
  var DOBController = TextEditingController();

  var userType = 'customer'.obs; // Default is customer
  var galleryImg = Rx<File?>(null);
  int pic = 1;
  var galleryImgCompress = "".obs;
  var selectedGalleryImg = ''.obs;


  var isLoading = false.obs;

  final String cloudinaryUrl =
      "https://api.cloudinary.com/v1_1/dexb8rrkl/image/upload"; // Replace with your Cloudinary cloud name
  final String uploadPreset = "flutter_present"; // Replace with your upload preset



    // Handle gallery image selection and compression
  openGallery(int index, BuildContext context, {bool hitApi = false}) async {
    PermissionOfPhotos().getFromGallery(context).then((value) async {
      if (value) {
        await getImage(ImageSource.gallery, index, hitApi: hitApi);
        update();
      } else {
        print("Permission denied");
      }
    });
  }

  // Handle camera image selection and compression
  openCamera(int index, BuildContext context, {bool hitApi = false}) async {
    PermissionOfPhotos().getFromCamera(context).then((value) async {
      if (value) {
        await getImage(ImageSource.camera, index, hitApi: hitApi);
      } else {
        print("Permission denied");
      }
    });
  }

  // Pick an image from gallery or camera and compress it
  Future getImage(ImageSource imageSource, int index, {bool hitApi = false}) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);

    if (pickedFile != null) {
      switch (index) {
        case 0:
          selectedGalleryImg.value = pickedFile.path;
          final dir1 = Directory.systemTemp;
          final targetPath1 = dir1.absolute.path + "/pic${pic++}.jpg";
          var compressedFile1 = await FlutterImageCompress.compressAndGetFile(
              selectedGalleryImg.value, targetPath1,
              quality: 60);
          galleryImgCompress.value = compressedFile1!.path;
          galleryImg.value = File(galleryImgCompress.value); // Proper assignment
          break;
        default:
          print("Nothing is selected");
          break;
      }
    } else {
      CustomToast.failToast("No image was selected");
    }
  }




  // Upload image to Cloudinary
  Future<String> uploadImageToCloudinary(File imageFile) async {
    try {
      // Compress the image
      final compressedFile = await _compressImage(imageFile);

      // Prepare the request
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(
        await http.MultipartFile.fromPath('file', compressedFile.path),
      );

      // Send the request
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);
        return jsonResponse['secure_url']; // Return the Cloudinary URL
      } else {
        throw Exception("Failed to upload image: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Error uploading image: $e");
    }
  }

  // Compress image
  Future<XFile> _compressImage(File imageFile) async {
    final tempDir = Directory.systemTemp;
    final targetPath = '${tempDir.path}/compressed_${imageFile.path.split('/').last}';
    var result = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      targetPath,
      quality: 60,
    );
    return result!;
  }

  // Save profile image URL to Firestore
  Future<void> saveProfileImage(File imageFile) async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not logged in");
      }

      // Upload image to Cloudinary
      final imageUrl = await uploadImageToCloudinary(imageFile);

      // Save the URL in Firestore
      await _firestore.collection('users').doc(userId).update({
        'profileImage': imageUrl,
      });

      CustomToast.successToast("Profile image updated successfully");
    } catch (e) {
      print("Error saving profile image: $e");
      CustomToast.failToast("Failed to update profile image");
    } finally {
      isLoading.value = false;
    }
  }

  // Handle login
  Future<void> login() async {
    try {
      isLoading.value = true;
      if (_validateLoginInputs()) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

          if (userDoc.exists) {
            String userType = userDoc.get('userType');

            if (userType == 'seller') {
              Get.off(() => SellerDashboardScreen());
            } else {
              Get.off(() => HomePage());
            }
          } else {
            CustomToast.failToast("User data not found in Firestore");
          }
        }
      }
    } catch (e) {
      CustomToast.failToast("Login failed: ${e.toString()}");
      print("Login Failed: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> createAccount() async {
    try {
      if (validateInputs()) {
        isLoading.value = true;

        // Create account in Firebase Auth
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          String? imageUrl;
          if (galleryImg.value != null) {
            imageUrl = await uploadImageToCloudinary(galleryImg.value!);
          }

          // Save user data to Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
            'phone': phoneController.text.trim(),
            'country': countryController.text.trim(),
            'DOB': DOBController.text.trim(),
            'userType': userType.value,
            'CNIC' : cnicController.text.trim(),
            'businessName': userType.value == 'seller' ? businessNameController.text.trim() : null,
            'businessAddress': userType.value == 'seller' ? businessAddressController.text.trim() : null,
            'profileImage': imageUrl,
          });

          CustomToast.successToast("Account created successfully");

          // Delay for toast visibility
          await Future.delayed(Duration(seconds: 2));

          // Fetch user type from Firestore to ensure correct navigation
          DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

          if (userDoc.exists) {
            String userType = userDoc.get('userType');
            print("Navigating based on userType: $userType");

            // Clear form data after successful navigation
            clearForm();

            if (userType == 'seller') {
              print('Account created, navigating to the Seller Dashboard');
              Get.off(() => SellerDashboardScreen());
            } else {
              print('Account created, navigating to the Customer HomePage');
              Get.off(() => HomePage());
            }
          } else {
            CustomToast.failToast("Failed to fetch user data for navigation");
          }
        }
      }
    } catch (e) {
      CustomToast.failToast("Failed to create account: ${e.toString()}");
      print("Create Account Failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
  // Function to clear the form controllers and reset state
  void clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    countryController.clear();
    DOBController.clear();
    businessNameController.clear();
    businessAddressController.clear();
    galleryImg.value = null;
    userType.value = ''; // Reset userType
  }
  // Validate login inputs
  bool _validateLoginInputs() {
    if (emailController.text.isEmpty || !GetUtils.isEmail(emailController.text)) {
      CustomToast.failToast("Invalid email");
      return false;
    }
    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      CustomToast.failToast("Password must be at least 6 characters");
      return false;
    }
    return true;
  }

  // Validate account creation inputs
  bool validateInputs() {


    if (galleryImg.value == null) {
      CustomToast.failToast("Profile image is required");
      return false;
    }

    if (nameController.text.trim().isEmpty) {
      CustomToast.failToast("Name is required");
      return false;
    }
    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      CustomToast.failToast("Invalid email");
      return false;
    }
    if (passwordController.text.trim().isEmpty ||
        passwordController.text.trim().length < 6) {
      CustomToast.failToast("Password must be at least 6 characters");
      return false;
    }
    if (phoneController.text.trim().isEmpty ||
        phoneController.text.trim().length != 10) {
      CustomToast.failToast("Phone number must be 10 digits");
      return false;
    }
    if (countryController.text.trim().isEmpty) {
      CustomToast.failToast("Country is required");
      return false;
    }
    if (DOBController.text.trim().isEmpty) {
      CustomToast.failToast("Date of Birth is required");
      return false;
    }
    if (userType == 'seller') {
      if (businessNameController.text.trim().isEmpty) {
        CustomToast.failToast("Business name is required for sellers");
        return false;
      }
      if (businessAddressController.text.trim().isEmpty) {
        CustomToast.failToast("Business address is required for sellers");
        return false;
      }
    }
    return true;
  }


  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    countryController.dispose();
    businessNameController.dispose();
    businessAddressController.dispose();
    super.onClose();
  }
}
