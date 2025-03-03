import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tv_and_movie_explorer/services/api_services.dart';

class WatchlistController extends GetxController {
  var watchlistMovies = [].obs;
  var isLoading = false.obs;
@override

void onInit(){
  super.onInit();
  fetchWatchlist();
}
  // Fetch Watchlist
  void fetchWatchlist() async {
    try {
      isLoading(true);
      var movies = await ApiServices.fetchWatchlistMovies();
      watchlistMovies.assignAll(movies);
       if(kDebugMode){
      print("length of the watchlist movies is ${watchlistMovies.length}");
    }
    } catch (e) {
      print("❌ Error fetching watchlist: $e");
    } finally {
      isLoading(false);
    }
  }
   // Remove Movie from Watchlist
  void removeMovie(int movieId) async {
    bool success = await ApiServices.removeFromWatchlist(movieId);
    if (success) {
      watchlistMovies.removeWhere((movie) => movie["id"] == movieId);
      Get.snackbar("Success", "Movie removed from watchlist!");
    } else {
      Get.snackbar("Error", "Failed to remove movie.");
    }
  }
}
