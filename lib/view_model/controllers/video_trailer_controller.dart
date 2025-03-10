import 'package:get/get.dart';
import 'package:tv_and_movie_explorer/services/api_services.dart';
class VideoTrailerController extends GetxController {
  var isLoading = false.obs;
  RxString videoTrailerUrl = ''.obs;
  
  Future<String?> fetchMovieVideoUrl(int movieId) async {
    try {
      isLoading.value = true;
      String? url = await ApiServices.fetchTrailerKey(movieId);
      videoTrailerUrl.value = url ?? "";
      return videoTrailerUrl.value;
    } catch (e) {
      print("Error in fetching trailer URL: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
