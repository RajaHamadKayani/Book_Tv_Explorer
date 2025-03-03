import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/movie_controller.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/movie_details_controller.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/search_movie_controller.dart';
import 'package:tv_and_movie_explorer/view_model/controllers/similar_movies_controller.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  final MovieController movieController = Get.put(MovieController());
  final MovieDetailsController movieDetailsController =
      Get.put(MovieDetailsController());
  final SearchMovieController searchController =
      Get.put(SearchMovieController());
  final TextEditingController searchTextController = TextEditingController();
  SimilarMoviesController similarMoviesController =
      Get.put(SimilarMoviesController());

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Movies Explorer")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchTextController, // ✅ Add the controller here
                onChanged: (query) {
                  if (query.isEmpty) {
                    searchController
                        .clearSearch(); // ✅ Clear search results when query is empty
                  } else {
                    searchController.searchMovies(query);
                  }
                },
                decoration: InputDecoration(
                  hintText: "Search for a movie...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(child: Obx(() {
              if (searchController.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              // If search results are available, show them
              if (searchController.searchResults.isNotEmpty) {
                return ListView.builder(
                  itemCount: searchController.searchResults.length,
                  itemBuilder: (context, index) {
                    var movie = searchController.searchResults[index];
                    return MovieCard(movie);
                  },
                );
              }
              // ✅ If the search is active but no   found, show message
              if (searchTextController.text.isNotEmpty &&
                  searchController.searchResults.isEmpty) {
                return Center(child: Text("No movies found"));
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Trending Movies",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movieController.tendingMoviesList.length,
                        itemBuilder: (context, index) {
                          var movie = movieController.tendingMoviesList[index];
                          return GestureDetector(
                              onTap: () {
                                movieDetailsController
                                    .fetchSingleMovieDetail(movie.id);
                                similarMoviesController
                                    .singleMovieData(movie.id);
                              },
                              child: MovieCard(movie));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text("Popular Movies",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: movieController.popularMoviesList.length,
                        itemBuilder: (context, index) {
                          var movie = movieController.popularMoviesList[index];
                          return GestureDetector(
                              onTap: () {
                                movieDetailsController
                                    .fetchSingleMovieDetail(movie.id);
                                similarMoviesController
                                    .singleMovieData(movie.id);
                              },
                              child: PopularMoviesCard(movie));
                        },
                      ),
                    ),
                  ],
                ),
              );
            }))
          ],
        ));
  }
}

// Movie Card Widget
class MovieCard extends StatelessWidget {
  final movie;
  MovieCard(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(movie.posterImage,
                height: 100, fit: BoxFit.cover),
          ),
          SizedBox(height: 5),
          Text(movie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class PopularMoviesCard extends StatelessWidget {
  final movie;
  PopularMoviesCard(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child:
              Image.network(movie.posterImage, height: 50, fit: BoxFit.cover),
        ),
        title: Text(movie.title),
        trailing: Text(movie.releaseDate),
      ),
    );
  }
}
