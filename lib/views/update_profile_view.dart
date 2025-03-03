import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/update_profile_controller.dart';
import 'package:tv_and_movie_explorer/views/widgets/reusable_container.dart';
import 'package:tv_and_movie_explorer/views/widgets/reusable_text_field_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String address;
  final String phone;
  final String id;
  const UpdateProfileScreen(
      {super.key,
      required this.address,
      required this.email,
      required this.name,
      required this.id,
      required this.phone});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  void initState() {
    super.initState();
    updateProfileController.textEditingControllerName.text = widget.name;
    updateProfileController.textEditingControllerEmail.text = widget.email;
    updateProfileController.textEditingControllerPhone.text = widget.phone;
    updateProfileController.textEditingControllerAddress.text = widget.address;
  }

  UpdateProfileController updateProfileController =
      Get.put(UpdateProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit Profile",
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 35),
            ),
            const SizedBox(
              height: 20,
            ),
            ReusableTextFieldWidget(
                controller: updateProfileController.textEditingControllerName,
                hintText: "Name",
                title: "Name"),
            const SizedBox(
              height: 20,
            ),
            ReusableTextFieldWidget(
                controller: updateProfileController.textEditingControllerEmail,
                hintText: "Email",
                title: "Email"),
            const SizedBox(
              height: 20,
            ),
            ReusableTextFieldWidget(
                controller:
                    updateProfileController.textEditingControllerAddress,
                hintText: "Adress",
                title: "Address"),
            const SizedBox(
              height: 20,
            ),
            ReusableTextFieldWidget(
                controller: updateProfileController.textEditingControllerPhone,
                hintText: "Phone",
                title: "Phone"),
            const SizedBox(
              height: 30,
            ),
           Obx((){
            return  GestureDetector(
              onTap: () {
                updateProfileController.updateProfile(widget.id);
              },
              child: updateProfileController.isLoading.value?Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ):ReusableContainer(
                  borderRadius: BorderRadius.circular(16),
  
                  title: "Update"),
            );
           })
          ],
        ),
      )),
    );
  }
}
