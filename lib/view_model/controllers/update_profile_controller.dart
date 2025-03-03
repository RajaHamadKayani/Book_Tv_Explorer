import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tv_and_movie_explorer/services/auth_survices.dart';
import 'package:tv_and_movie_explorer/utils/toast_util.dart';

class UpdateProfileController extends GetxController {
  var isLoading = false.obs;
  var textEditingControllerName = TextEditingController();
  var textEditingControllerEmail = TextEditingController();
  var textEditingControllerAddress = TextEditingController();
  var textEditingControllerPhone = TextEditingController();

  AuthService _firebaseAuth = AuthService();
  updateProfile(String id) async {
    isLoading.value = true;
    try {
      await _firebaseAuth.updateCurrentUserData(
          textEditingControllerName.value.text,
          textEditingControllerEmail.value.text,
          textEditingControllerAddress.value.text,
          textEditingControllerPhone.value.text,
          id);
      ToastUtil.showToast(message: "Data Updated Successfully");
    } catch (e) {
      ToastUtil.showToast(message: "Error while Updating Data");
    } finally {
      isLoading.value = false;
    }
  }
}
