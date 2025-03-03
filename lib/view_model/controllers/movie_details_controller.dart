import 'package:get/get.dart';
import 'package:tv_and_movie_explorer/data/models/movies_model_class.dart';
import 'package:tv_and_movie_explorer/services/api_services.dart';
import 'package:tv_and_movie_explorer/views/movie_details_view.dart';

class MovieDetailsController extends GetxController {
  var isLoading = false.obs;
var singleMovieData = Rxn<MoviesModelClass>();

  void fetchSingleMovieDetail(int id) async {
    try {
      isLoading.value = true;
      var data = await ApiServices.fetchSingleMovieDetail(id);
singleMovieData.value = data;
      Get.to(() => MovieDetailsView(movieDetails: singleMovieData.value,)); // ✅ Pass data to the screen
    } catch (e) {
      throw Exception("Something Went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
