import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tv_and_movie_explorer/data/models/movies_model_class.dart';
import 'package:tv_and_movie_explorer/services/api_services.dart';
import 'package:tv_and_movie_explorer/views/similar_movie_details_view.dart';

class SingleSimilarMovieController extends GetxController {
  var isLoading = false.obs;
  var singleMovieData = Rxn<MoviesModelClass>();
  void fetchSingleSimilarMovieDetail(int movieId) async {
    try {
      var data = await ApiServices.fetchSingleSimilarMovieDetail(movieId);
      singleMovieData.value = data;
      Get.to(SimilarMovieDetailsView(), arguments: singleMovieData.value);
    } catch (e) {
      if (kDebugMode) {
        print("The error while fetchin single similar moview detail $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
