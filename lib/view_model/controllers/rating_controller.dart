import 'package:get/get.dart';
import 'package:tv_and_movie_explorer/services/api_services.dart';

class RatingController extends GetxController{
    var isLoading = false.obs;
  var averageRating = 0.0.obs;
  var voteCount = 0.obs;
  var userRating = 0.0.obs; // The rating that the user selects

  // Submit the rating using the POST API
  Future<void> submitRating(int movieId, double rating) async {
    isLoading(true);
    bool success = await ApiServices.rateMovie(movieId, rating);
    if (success) {
      userRating.value = rating;
      // After rating, refresh the movie details to update average rating and vote count
      await fetchMovieDetails(movieId);
    }
    isLoading(false);
  }

  // Fetch updated movie details using the GET API
  Future<void> fetchMovieDetails(int movieId) async {
    isLoading(true);
    try {
      Map<String, dynamic> details = await ApiServices.getMovieDetails(movieId);
      averageRating.value = (details["vote_average"] as num).toDouble();
      voteCount.value = details["vote_count"] as int;
    } catch (e) {
      print("Error fetching movie details: $e");
    }
    isLoading(false);
  }
}