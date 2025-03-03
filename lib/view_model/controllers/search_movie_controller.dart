import 'package:get/get.dart';

import '../../data/models/movies_model_class.dart';
import '../../services/api_services.dart';

class SearchMovieController extends GetxController {
  var searchResults = <MoviesModelClass>[].obs;
  var isLoading = false.obs;

  void searchMovies(String query) async {
    try {
      isLoading.value = true;
      var results = await ApiServices.searchMovies(query);
      searchResults.assignAll(results);
    } catch (e) {
      print("Error searching movies: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchResults.clear(); // ✅ Clear the search results
  }
}
