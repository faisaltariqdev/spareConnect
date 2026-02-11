
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON handling
import 'dart:io';      // For File handling
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize Cloudinary
  final Cloudinary cloudinary = Cloudinary.fromStringUrl(
    'cloudinary://344263214982139:wcSQweWUBBHxT0kS--mfNWRD9tc@dexb8rrkl',
  );

  final String cloudName = "dexb8rrkl"; // Your Cloudinary Cloud Name
  final String uploadPreset = "flutter_present"; // Your upload preset name

  // Upload image to Cloudinary
  Future<String> uploadImage(File image) async {
    try {
      // Cloudinary unsigned upload endpoint
      final String cloudinaryUrl =
          "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

      // Prepare the request
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = uploadPreset; // Use unsigned preset
      request.files.add(
        await http.MultipartFile.fromPath('file', image.path),
      );

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final jsonResponse = json.decode(respStr);

        String secureUrl = jsonResponse['secure_url'];
        print("Uploaded Image URL: $secureUrl");
        return secureUrl;
      } else {
        throw Exception(
            'Failed to upload image: ${response.statusCode}, ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Error uploading image: $e");
    }
  }


  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(userId).get();
    return snapshot.data() as Map<String, dynamic>;
  }

  // Add product details to Firestore
  Future<void> addProduct({
    required String productName,
    required String category,
    required double price,
    required int quantity,
    required String condition,
    required String description,
    required String deliveryDays,
    required String stock,
    required String warranty,
    required String sellerLocation,
    required String sellerContact,
    required String sellerName,
    required String sellerEmail,
    required String userId,
    required List<String> imageUrls,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('products').add({
        'product_name': productName,
        'category': category,
        'price': price,
        'quantity': quantity,
        'condition': condition,
        'description': description,
        'deliveryDays': deliveryDays,
        'stock': stock,
        'warranty': warranty,
        'sellerLocation': sellerLocation,
        'sellerContact': sellerContact,
        'seller_name': sellerName, // Add seller name
        'seller_email': sellerEmail, // Add seller email
        'userId': userId,
        'images': imageUrls,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }


  // Fetch all products from Firestore
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();

      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'product_name': doc['product_name'],
          'category': doc['category'],
          'price': doc['price'],
          'quantity': doc['quantity'],
          'condition': doc['condition'],
          'description': doc['description'],
          'images': List<String>.from(doc['images'] ?? []), // Fetch image URLs
          'created_at': doc['created_at'],
        };
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}

