import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tv_and_movie_explorer/data/models/movies_model_class.dart';
import 'package:tv_and_movie_explorer/services/api_services.dart';

class SimilarMoviesController extends GetxController {
  var isLoading = false.obs;
  var singleMovieDataList = <MoviesModelClass>[].obs;
  void singleMovieData(int id) async {
    try {
      isLoading.value = true;
      var data = await ApiServices.getSimilarMoviesList(id);
      singleMovieDataList.assignAll(data);
    } catch (e) {
      if (kDebugMode) {
        print("Error while fetching the similar movies List $e");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
