import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tv_and_movie_explorer/data/models/movies_model_class.dart';
import 'package:tv_and_movie_explorer/services/api_services.dart';

class MovieController extends GetxController {
  var isLoading = false.obs;
  var popularMoviesList = <MoviesModelClass>[].obs;
  var tendingMoviesList = <MoviesModelClass>[].obs;
  ApiServices apiServices = ApiServices();
  @override
  void onInit() {
    fetchMoviews();
    super.onInit();
  }

  void fetchMoviews() async {
    try {
      isLoading.value = true;
      var popular = await ApiServices.fetchPopularMovies();
      var tending = await ApiServices.fetchTendingMovies();
      popularMoviesList.assignAll(popular);
      tendingMoviesList.assignAll(tending);
    } catch (e) {
      if (kDebugMode) {
        print("Error while fetching movies ${e.toString()}");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
