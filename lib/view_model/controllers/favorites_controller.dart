import 'package:get/get.dart';
import 'package:tv_and_movie_explorer/data/models/movies_model_class.dart';
import 'package:tv_and_movie_explorer/services/api_services.dart';
import 'package:tv_and_movie_explorer/views/favorite_movies_view.dart';

class FavoritesController extends GetxController {
  var isLoading = false.obs;
  var favoriteList = <MoviesModelClass>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFavoritesMovies();
  }

   addToFavorites(int movieId, String movieTitle) async {
    try {
      isLoading.value = true;
      await ApiServices.addToFavorites(movieId);
      Get.snackbar(
          "Add To Favorites", "$movieTitle is add to favorites successfully");
          Get.to(FavoriteMoviesView());
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void fetchFavoritesMovies() async {
    try {
      isLoading.value = true;
      var movies = await ApiServices.fetchFavoritesMovies();
      favoriteList.assignAll(movies);
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void deleteMovieFromFavorite(int movieId, String movieTitle) async {
    try {
      isLoading.value = true;
      await ApiServices.removeFromFavorites(movieId);
      favoriteList.removeWhere((movie)=> movie.id==movieId);
      Get.snackbar("Remove from Favorites",
          "$movieTitle is removed from favorites List");
    } catch (e) {
      throw Exception("Something went wrong deleting the movie from favorites");
    } finally {
      isLoading.value = false;
    }
  }
}
