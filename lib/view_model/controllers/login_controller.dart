
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tv_and_movie_explorer/services/auth_survices.dart';
import 'package:tv_and_movie_explorer/utils/toast_util.dart';
import 'package:tv_and_movie_explorer/views/dashboard_view.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService();

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> loginUser() async {
    isLoading.value = true;
    try {
      await _authService.loginUser(
        emailController.text,
        passwordController.text,
      );

    ToastUtil.showToast(message: "Login Successfully",
    );      // Navigate to the next screen
    Get.to(DashboardView());
    } catch (e) {
    ToastUtil.showToast(message: "Login failed. Something went wrong",
    );    } finally {
      isLoading.value = false;
    }
  }
}
