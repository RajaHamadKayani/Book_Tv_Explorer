import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tv_and_movie_explorer/services/api_services.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/favorites_controller.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/rating_controller.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/similar_movies_controller.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/single_similar_movie_controller.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/watchlist_controller.dart';

// ignore: must_be_immutable
class MovieDetailsView extends StatefulWidget {
  var movieDetails;
  MovieDetailsView({super.key, required this.movieDetails});

  @override
  State<MovieDetailsView> createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<MovieDetailsView> {
    final RatingController ratingController = Get.put(RatingController());

  FavoritesController favoritesController = Get.put(FavoritesController());
  bool isInWatchlist = false;
  bool isMovieInFavoriteList = false;

  @override
  void initState() {
    super.initState();
    ApiServices.authenticateUser();
    checkWatchListStatus();
    checkFavoriteListStatus();
  }

  Future<void> checkWatchListStatus() async {
    bool exists = await ApiServices.isMovieInWatchlist(widget.movieDetails.id);
    setState(() {
      isInWatchlist = exists;
    });
  }

  Future<void> checkFavoriteListStatus() async {
    bool exists =
        await ApiServices.isMovieInFavoriteList(widget.movieDetails.id);
    setState(() {
      isMovieInFavoriteList = exists;
    });
  }

  void handleWatchlistPress() async {
    if (isInWatchlist) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialogWidget(
                widget.movieDetails.title,
                widget.movieDetails.id,
                "WatchList",
                () => watchlistController.removeMovie(widget.movieDetails.id));
          });
    } else {
      bool added = await ApiServices.addToWatchlist(widget.movieDetails.id);
      if (added) {
        setState(() {
          isInWatchlist = true;
        });
      }
    }
  }

  handleFavoriteListPress() async {
    if (isMovieInFavoriteList) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialogWidget(
                widget.movieDetails.title,
                widget.movieDetails.id,
                "FavoriteList",
                () => favoritesController.deleteMovieFromFavorite(
                    widget.movieDetails.id, widget.movieDetails.title));
          });
    } else {
      bool added = favoritesController.addToFavorites(
          widget.movieDetails.id, widget.movieDetails.title);
      if (added) {
        setState(() {
          isMovieInFavoriteList = true;
        });
      }
    }
  }

  final SimilarMoviesController similarMoviesController =
      Get.put(SimilarMoviesController());
  final SingleSimilarMovieController singleSimilarMovieController =
      Get.put(SingleSimilarMovieController());

  WatchlistController watchlistController = Get.put(WatchlistController());
  @override
  Widget build(BuildContext context) {
        ratingController.fetchMovieDetails(widget.movieDetails.id);

    return Scaffold(
      appBar: AppBar(title: Text(widget.movieDetails.title)),
      body: Obx((){
        if(ratingController.isLoading.value){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else{
          return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500${widget.movieDetails.posterImage}", // ✅ Display poster
                  height: 300,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movieDetails.title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: isMovieInFavoriteList
                        ? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Colors.black,
                          ),
                    onPressed: () async {
                      handleFavoriteListPress();
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Release Date: ${widget.movieDetails.releaseDate}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
                // Display current average rating and vote count
              Text(
                "Current Average Rating: ${ratingController.averageRating.value.toStringAsFixed(1)}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Based on ${ratingController.voteCount.value} votes",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              // RatingBar for interactive rating
              RatingBar.builder(
                initialRating: ratingController.userRating.value,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 10, // For scale 1.0 to 10.0
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                updateOnDrag: true,
                onRatingUpdate: (rating) {
                  ratingController.userRating.value = rating;
                },
              ),
              SizedBox(height: 20),
              // Submit button
              ElevatedButton(
                onPressed: () async {
                  double rating = ratingController.userRating.value;
                  await ratingController.submitRating(widget.movieDetails.id, rating);
                  Get.snackbar("Success", "Your rating has been submitted!",
                      snackPosition: SnackPosition.BOTTOM);
                },
                child: ratingController.isLoading.value?Center(
                  child: CircularProgressIndicator(),
                ):Text("Submit Rating"),
              ),
          
        
              SizedBox(height: 10),
              Text(
                widget.movieDetails.description,
                style: TextStyle(fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  handleWatchlistPress();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: isInWatchlist ? Colors.red : Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Center(
                      child: Text(
                        isInWatchlist
                            ? "Added To watchlist"
                            : "Add To WatchList",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Similar Movies",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Obx(() {
                if (similarMoviesController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ListView.builder(
                        itemCount:
                            similarMoviesController.singleMovieDataList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final movie = similarMoviesController
                              .singleMovieDataList[index];
                          return GestureDetector(
                            onTap: () {
                              singleSimilarMovieController
                                  .fetchSingleSimilarMovieDetail(movie.id);
                            },
                            child: SizedBox(
                              height: double.infinity,
                              width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(movie.posterImage,
                                        height: 120, fit: BoxFit.cover),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    movie.title,
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }
              })
            ],
          ),
        ),
      );
        }

      }),
    );
  }

  Widget alertDialogWidget(
      String movieTItle, int movieId, String title, VoidCallback delete) {
    return AlertDialog(
      title: Text(
        "Remove from $title",
        style: GoogleFonts.poppins(color: Colors.black),
      ),
      content: Text(
        "Are you sure want to remove $movieTItle from $title?",
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
            delete();
            Navigator.pop(context);
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
