import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/favorites_controller.dart';

class FavoriteMoviesView extends StatefulWidget {
  const FavoriteMoviesView({super.key});

  @override
  State<FavoriteMoviesView> createState() => _FavoriteMoviesViewState();
}

class _FavoriteMoviesViewState extends State<FavoriteMoviesView> {
  FavoritesController favoritesController = Get.put(FavoritesController());
  @override
  void initState() {
    super.initState();
    favoritesController.fetchFavoritesMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      if (favoritesController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (favoritesController.favoriteList.isEmpty) {
        return Center(
          child: Text(
            "No favorite movies found",
            style: GoogleFonts.poppins(color: Colors.black),
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: favoritesController.favoriteList.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final favoriteMovie = favoritesController.favoriteList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "https://image.tmdb.org/t/p/w500${favoriteMovie.posterImage}",
                            height: 100,
                            fit: BoxFit.cover,
                            width: 100,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                favoriteMovie.title,
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                favoriteMovie.description,
                                style: GoogleFonts.poppins(
                                    fontSize: 10, fontWeight: FontWeight.w300),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alertDialogWidget(
                                      favoriteMovie.title, favoriteMovie.id);
                                });
                               
                          },
                          child: Obx((){
                            return Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: EdgeInsets.all(1),
                              child: Center(
                                child: favoritesController.isLoading.value?CircularProgressIndicator():Text(
                                  "Remove",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 8),
                                ),
                              ),
                            ),
                          );
                          }),
                        )
                      ],
                    ),
                  ),
                );
              }),
        );
      }
    }));
  }

  Widget alertDialogWidget(String movieTItle, int movieId) {
    return AlertDialog(
      title: Text(
        "Remove from Favorites List",
        style: GoogleFonts.poppins(color: Colors.black),
      ),
      content: Text(
        "Are you sure want to remove $movieTItle from Favorite List?",
        style: GoogleFonts.poppins(),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            favoritesController.deleteMovieFromFavorite(movieId, movieTItle);
            Navigator.pop(context);
             setState(() {
                                  
                                });
          },
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
