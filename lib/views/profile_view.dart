import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/user_controller.dart';
import 'package:tv_and_movie_explorer/views/update_profile_view.dart';
import 'package:tv_and_movie_explorer/views/widgets/reusable_container.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  UserController userController = Get.put(UserController());
  @override
  void initState() {
    super.initState();
    userController.fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Obx(() {
        if (userController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        } else if (userController.currentUser.value.id.isEmpty) {
          return Center(
            child: Text(
              "Something went Wrong",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Your Profile",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 35),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        userController.currentUser.value.imageUrl ??
                            'https://via.placeholder.com/150',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                     
                        border: Border.all(color: Colors.black,
                        width: 1)
                        ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 12),
                      child: Text(
                        userController.currentUser.value.name,
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                       
                        border: Border.all(color: Colors.black,
                        width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 12),
                      child: Text(
                        userController.currentUser.value.email,
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(color: Colors.black,
                        width: 1)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 12),
                      child: Text(
                        userController.currentUser.value.phone,
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        
                        border: Border.all(color: Colors.black,
                        width: 1)
                        ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 12),
                      child: Text(
                        userController.currentUser.value.address,
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateProfileScreen(
                                id: userController.currentUser.value.id,
                                  address:
                                      userController.currentUser.value.address,
                                  email: userController.currentUser.value.email,
                                  name: userController.currentUser.value.name,
                                  phone:
                                      userController.currentUser.value.phone)));
                    },
                    child: ReusableContainer(
                        borderRadius: BorderRadius.circular(16),
                      
                        title: "Update"),
                  )
                ],
              ),
            ),
          );
        }
      })),
    );
  }
}
