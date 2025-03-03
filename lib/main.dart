import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tv_and_movie_explorer/data/models/favorites_model.dart';
import 'package:tv_and_movie_explorer/firebase_options.dart';
import 'package:tv_and_movie_explorer/views/dashboard_view.dart';
import 'package:tv_and_movie_explorer/views/login_view.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();
 // Ensure Firebase is initialized only once
await Firebase.initializeApp(
  name: 'Movie and Tv Show Explorer',
  options: DefaultFirebaseOptions.currentPlatform,
);
await Hive.initFlutter();
Hive.registerAdapter(FavoritesModelAdapter());
await Hive.openBox<FavoritesModel>("favorites");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginView(),
    );
  }
}

