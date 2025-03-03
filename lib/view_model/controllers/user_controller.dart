import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tv_and_movie_explorer/data/models/user_model.dart';
import 'package:tv_and_movie_explorer/services/auth_survices.dart';

class UserController extends GetxController {
    var isLoading = false.obs;

  var currentUser = UserModel(id: '', email: '', phone: '', imageUrl: '',name: '',address: '').obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
AuthService _authService=AuthService();
  // Fetch current logged-in user data
   Future<void> fetchCurrentUser() async {
    isLoading.value=true;
    try {
      User? user = _auth.currentUser; // Get the currently authenticated user
      if (user != null) {
        // Fetch user data from Firestore
        currentUser.value = await _authService. fetchUserById(user.uid); // Fetch user by ID
      }
    } catch (e) {
      print("Error fetching user: $e");
    }
    finally{
      isLoading.value=false;
    }
  }
}
