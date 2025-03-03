import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tv_and_movie_explorer/views/favorite_movies_view.dart';
import 'package:tv_and_movie_explorer/views/main_view.dart';
import 'package:tv_and_movie_explorer/views/profile_view.dart';
import 'package:tv_and_movie_explorer/views/watchlist_screen.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int initialIndex = 0;
  List<Widget> allScreen = [
    HomeScreen(),
    WatchlistScreen(),
    FavoriteMoviesView(),
    ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allScreen[initialIndex],
    bottomNavigationBar: BottomNavigationBar(
      
  backgroundColor: Colors.blue,
  selectedItemColor: Colors.black,
  unselectedItemColor: Colors.black,
  selectedLabelStyle: TextStyle(color: Colors.black),
  unselectedLabelStyle: TextStyle(color: Colors.black),
  currentIndex: initialIndex,
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.watch_later),
      label: "WatchList",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: "Favorite",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Profile",
    ),
  ],
  onTap: (index) {
    setState(() {
      initialIndex = index;
    });
  },
),

    );
  }
}
