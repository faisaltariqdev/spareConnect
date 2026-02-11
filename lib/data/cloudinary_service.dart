//
//
// import 'dart:io';
//
// import 'package:cloudinary_public/cloudinary_public.dart';
//
// class CloudinaryService {
//   // Cloudinary credentials - get these from your Cloudinary Dashboard
//   static const String cloudName = 'dexb8rrkl';
//   static const String uploadPreset = 'flutter_present'; // Create a preset on Cloudinary
//
//   final CloudinaryPublic cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: true);
//
//   // Function to upload image to Cloudinary
//   Future<String?> uploadImage(File imageFile) async {
//     try {
//       // Upload the image to Cloudinary
//       CloudinaryResponse response = await cloudinary.uploadFile(
//         CloudinaryFile.fromFile(imageFile.path, resourceType: CloudinaryResourceType.Image),
//       );
//
//       // Return the URL of the uploaded image
//       return response.secureUrl;
//     } catch (e) {
//       print("Error uploading image: $e");
//       return null;
//     }
//   }
// }
