import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:tv_and_movie_explorer/data/models/user_model.dart';
import 'package:tv_and_movie_explorer/utils/toast_util.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register a new user
  // Register user and return UserCredential
  Future<UserCredential> registerUser(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception("Error registering user: $e");
    }
  }

  // Upload image to Cloudinary
  Future<String> uploadImageToCloudinary(File imageFile) async {
    final cloudName = 'dqs1y6urv'; // Replace with your Cloudinary Cloud Name
    // final apiKey = '463369248646777'; // Replace with your Cloudinary API Key
    final preset =
        'ecommerce_preset'; // Replace with your Cloudinary Upload Preset

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = preset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      ToastUtil.showToast(message: "Image uploaded to Cloudinary successfully");
      final res = await http.Response.fromStream(response);
      final data = jsonDecode(res.body);
      return data['secure_url']; // Image URL from Cloudinary
    } else {
      ToastUtil.showToast(message: "Failed to upload image to Cloudinary");
      throw Exception('Failed to upload image to Cloudinary');
    }
  }

  // Save user details to Firestore
  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      throw Exception("Error saving user data: $e");
    }
  }

  // Login user
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception("Error logging in user: $e");
    }
  }

  // Fetch current user data
  Future<UserModel?> fetchCurrentUser() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }
      }
    } catch (e) {
      throw Exception("Error fetching current user data: $e");
    }
    return null;
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Error sending password reset email: $e");
    }
  }

  // Fetch user details by user ID
  // Fetch user details from Firestore by userId
  Future<UserModel> fetchUserById(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  Future<void> updateCurrentUserData(String name, String email, String address,
      String phone, String id) async {
    try {
      await _firestore.collection("users").doc(id).update({
        "name": name.toString(),
        "email": email.toString(),
        "address": address.toString(),
        "phone": phone.toString()
      });
    } catch (e) {
      throw Exception("Error while updating User Data");
    }
  }
}
