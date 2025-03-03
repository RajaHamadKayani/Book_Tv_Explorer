import 'dart:io';


import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/signup_controller.dart';
import 'package:tv_and_movie_explorer/views/login_view.dart';
import 'package:tv_and_movie_explorer/views/widgets/reusable_container.dart';

import 'package:tv_and_movie_explorer/views/widgets/reusable_text_field_widget.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  SignupController signupController = Get.put(SignupController());
  String selectedDate = "Select Date"; // Initial text
  XFile? _image; // Holds the picked image

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2100),
  //     builder: (context, child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           primaryColor: const Color(0xFF3CBBB1), // Header background color
  //           // accentColor: const Color(0xFF3CBBB1), // Selection color
  //           colorScheme: ColorScheme.light(primary: const Color(0xFF3CBBB1)),
  //           buttonTheme: const ButtonThemeData(
  //             textTheme: ButtonTextTheme.primary, // Text button theme
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );

  //   if (picked != null && picked != DateTime.now()) {
  //     setState(() {
  //       selectedDate = DateFormat('dd-MM-yyyy').format(picked); // Format date
  //       signupController.dobController.text = selectedDate;
  //     });
  //   }
  // }

  final _formKey = GlobalKey<FormState>();

  // Focus nodes for the text fields
  final emailController = FocusNode();
  final passwordController = FocusNode();
  final nameController = FocusNode();
  final addressController = FocusNode();
  final phoneController = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
        resizeToAvoidBottomInset:
            true, // Allow the screen to resize when the keyboard is open
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Create",
                      style: GoogleFonts.raleway(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "Account",
                      style: GoogleFonts.raleway(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 54,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showImageSourceBottomSheet(context);
                      },
                      child: _image == null
                          ? DottedBorder(
                              borderType: BorderType
                                  .Circle, // Use Circle for circular borders
                              dashPattern: const [15, 3],
                              color: const Color(0xffffffff),
                              strokeWidth: 1.5,
                              child: Container(
                                height:
                                    90, // Ensure height and width are the same for a perfect circle
                                width: 90,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle, // Circle shape
                                ),
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 26),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: SizedBox(
                                          height: 28,
                                          width: 34,
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.color ==
                                              Colors.white
                                          ? const Color(0xff575075)
                                          : Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 65,
                                    backgroundImage:
                                        FileImage(File(_image!.path)),
                                    onBackgroundImageError:
                                        (error, stackTrace) {
                                      print("Failed to load image: $error");
                                    },
                                    child: null,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showImageSourceBottomSheet(context);
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                      ReusableTextFieldWidget(
                      controller: signupController.nameController,
                      hintText: "Enter your Name",
                      title: 'Name',
                      focusNode: nameController, // Assign focus node
                      textInputAction: TextInputAction
                          .next, // Set the action to move to the next field
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(emailController);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ReusableTextFieldWidget(
                      controller: signupController.emailController,
                      hintText: "Enter your Email",
                      title: 'Email',
                      focusNode: emailController, // Assign focus node
                      textInputAction: TextInputAction
                          .next, // Set the action to move to the next field
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(passwordController);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ReusableTextFieldWidget(
                      controller: signupController.passwordController,
                      hintText: "Enter your Password",
                      title: 'Password',
                      focusNode: passwordController, // Assign focus node
                      textInputAction: TextInputAction
                          .next, // Set the action to move to the next field
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(nameController);
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ReusableTextFieldWidget(
                      controller: signupController.phoneController,
                      hintText: "Enter your Phone",
                      title: 'Phone',
                      focusNode: phoneController, // Assign focus node
                      textInputAction: TextInputAction
                          .next, // Set the action to move to the next field
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(phoneController);
                      },
                    ),
                     const SizedBox(
                      height: 8,
                    ),
                    ReusableTextFieldWidget(
                      controller: signupController.addressController,
                      hintText: "Enter your Address",
                      title: 'Address',
                      focusNode: addressController, // Assign focus node
                      textInputAction: TextInputAction
                          .next, // Set the action to move to the next field
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(addressController);
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Obx(
                        () => signupController.isLoading.value
                            ? const CircularProgressIndicator()
                            : GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await signupController.registerUser(
                                      _image != null
                                          ? File(_image!.path)
                                          : null,
                                    );
        
                                    // Clear the text fields after successful upload
                                    signupController.nameController.clear();
                                    signupController.emailController.clear();
                                    signupController.passwordController
                                        .clear();
                                    signupController.phoneController.clear();
                                    signupController.addressController
                                        .clear();
                                    signupController.dobController.clear();
                                    Get.off(() => const LoginView());
                                  }
                                },
                                child: ReusableContainer(
                                    borderRadius: BorderRadius.circular(16),
                 
                                    title: "Done"),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.nunitoSans(
                            color: Color(0xffffffff),
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent, // Make the background transparent
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to be full screen
      builder: (context) {
        return Stack(
          children: [
            // Semi-transparent background overlay
            GestureDetector(
              onTap: () => Navigator.pop(
                  context), // Close the sheet when background is tapped
              child: Container(
                color: Colors.black
                    .withOpacity(0.5), // Semi-transparent background
              ),
            ),
            Align(
              alignment:
                  Alignment.bottomCenter, // Align the content at the bottom
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:Colors.green,
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(
                        color: Colors.transparent), // Transparent side borders
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize
                            .min, // Adjust the height based on content
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: SizedBox(
                              height: 72,
                              width: 72,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Color(0xffffffff),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Choose from gallery or",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Pulp",
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "click with camera",
                            style: TextStyle(
                              color:Colors.white,
                              fontFamily: "Pulp",
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Choose a photo that represents you.",
                            style: TextStyle(
                              color: const Color(0xffffffff),
                              fontFamily: "Pulp",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "Upload from gallery or take a picture",
                            style: TextStyle(
                              color:Colors.white,
                              fontFamily: "Pulp",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "instantly!",
                            style: TextStyle(
                              color: const Color(0xffffffff),
                              fontFamily: "Pulp",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(
                                          context); // Close the bottom sheet
                                      try {
                                        final XFile? image =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.gallery,
                                        );
                                        if (image != null) {
                                          setState(() {
                                            _image = image;
                                          });
                                        }
                                      } catch (e) {
                                        print(
                                            "Error picking image from gallery: $e");
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 19),
                                        child: Center(
                                          child: Text(
                                            "Choose from gallery",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Pulp",
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(
                                          context); // Close the bottom sheet
                                      try {
                                        final XFile? image =
                                            await ImagePicker().pickImage(
                                          source: ImageSource.camera,
                                        );
                                        if (image != null) {
                                          setState(() {
                                            _image = image;
                                          });
                                        }
                                      } catch (e) {
                                        print(
                                            "Error picking image from camera: $e");
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: const Color(0xffffffff),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 19),
                                        child: Center(
                                          child: Text(
                                            "Click From Camera",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Pulp",
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
