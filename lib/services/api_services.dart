import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_and_movie_explorer/data/models/movies_model_class.dart';
import 'package:tv_and_movie_explorer/views/watchlist_screen.dart';

String baseUrl = "https://api.themoviedb.org/3";
String apiKey = "62cc69b34f5e5e04bbcd5222e8dea1a1";
String accessRequestToken =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MmNjNjliMzRmNWU1ZTA0YmJjZDUyMjJlOGRlYTFhMSIsIm5iZiI6MTc0MDM2OTMxMi43OTYsInN1YiI6IjY3YmJlZGEwMjg2YmRlM2EwOTBhNzU3MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CGbM4zXc4dzbFNnaIlUKx_4c_qWM3_f8ZA52VBRyHGg';

const String username =
    "Raja_Hamad_Kayani"; // 🔴 Replace with your TMDB username
const String password = "newpass12A@"; // 🔴 Replace with your TMDB password

class ApiServices {
  static Future<List<MoviesModelClass>> fetchPopularMovies() async {
    try {
      var response =
          await http.get(Uri.parse("$baseUrl/movie/popular?api_key=$apiKey"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List<MoviesModelClass> popularMoviesList = (data['results'] as List)
            .map((json) => MoviesModelClass.fromMap(json))
            .toList();
        return popularMoviesList;
      } else {
        throw Exception(
            "Something went wrong fetching the popular Movies ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while fetching movies $e");
      }
      return [];
    }
  }

  static Future<List<MoviesModelClass>> fetchTendingMovies() async {
    var response = await http.get(
        Uri.parse("$baseUrl/trending/movie/day?api_key=$apiKey"),
        headers: {"Authorization": "Bearer $accessRequestToken"});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<MoviesModelClass> tendingMoviesList = (data['results'] as List)
          .map((json) => MoviesModelClass.fromMap(json))
          .toList();

      return tendingMoviesList;
    } else {
      throw Exception(
          "Something wrong fetching the tending Movies ${response.statusCode.toString()}");
    }
  }

  static Future<MoviesModelClass> fetchSingleMovieDetail(int movieId) async {
    var response = await http.get(
        Uri.parse("$baseUrl/movie/$movieId?api_key=$apiKey"),
        headers: {"Authorization": "Bearer $accessRequestToken"});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      MoviesModelClass singleMovieData = MoviesModelClass(
          id: data['id'],
          title: data["title"],
          description: data["overview"],
          popularity: data["popularity"],
          posterImage: data["poster_path"],
          releaseDate: data["release_date"]);

      return singleMovieData;
    } else {
      throw Exception("Somethimg Went wrong while fetching single movie Data");
    }
  }

  static Future<List<MoviesModelClass>> getSimilarMoviesList(
      int movieId) async {
    var response = await http.get(
        Uri.parse("$baseUrl/movie/$movieId/similar?api_key=$apiKey"),
        headers: {"Authorization": "Bearer $accessRequestToken"});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<MoviesModelClass> singleMovieData = (data['results'] as List)
          .map((json) => MoviesModelClass.fromMap(json))
          .toList();
      return singleMovieData;
    } else {
      throw Exception("Error while Fetching similar movies Data");
    }
  }

  static Future<MoviesModelClass> fetchSingleSimilarMovieDetail(int id) async {
    var response = await http.get(
        Uri.parse("$baseUrl/movie/$id?api_key=$apiKey"),
        headers: {"Authorization": "Bearer $accessRequestToken"});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      MoviesModelClass singleMovieData = MoviesModelClass(
          id: data['id'],
          title: data["title"],
          description: data["overview"],
          popularity: data["popularity"],
          posterImage: data["poster_path"],
          releaseDate: data["release_date"]);
      if (kDebugMode) {
        print("Similar single movie title is ${singleMovieData.title}");
      }

      return singleMovieData;
    } else {
      throw Exception("Error while fetchin the single similar movies Details");
    }
  }

  static Future<List<MoviesModelClass>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse("$baseUrl/search/movie?query=$query&api_key=$apiKey"),
      headers: {"Authorization": "Bearer $accessRequestToken"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<MoviesModelClass> searchResults = (data['results'] as List)
          .map((movie) => MoviesModelClass.fromMap(movie))
          .toList();
      return searchResults;
    } else {
      throw Exception("Something went wrong while searching movies");
    }
  }

// 1️⃣ **Step 1: Get Request Token**
  static Future<String> getRequestToken() async {
    final response = await http.get(
      Uri.parse("$baseUrl/authentication/token/new?api_key=$apiKey"),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String requestToken = data["request_token"];
      print("✅ Request Token: $requestToken");
      return requestToken;
    } else {
      throw Exception("❌ Failed to get request token");
    }
  }

  static Future<bool> validateWithLogin(String requestToken) async {
    final response = await http.post(
      Uri.parse(
          "$baseUrl/authentication/token/validate_with_login?api_key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "request_token": requestToken
      }),
    );

    if (response.statusCode == 200) {
      print("✅ Token validated successfully!");
      return true;
    } else {
      print("❌ Login failed: ${response.body}");
      return false;
    }
  }

// 3️⃣ **Step 3: Get Session ID (Using Request Token)**
  static Future<String> getSessionId(String requestToken) async {
    final response = await http.post(
      Uri.parse("$baseUrl/authentication/session/new?api_key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"request_token": requestToken}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String sessionId = data["session_id"];

      // Save session ID locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('session_id', sessionId);

      print("✅ Session ID: $sessionId");
      return sessionId;
    } else {
      throw Exception("❌ Failed to get session ID: ${response.body}");
    }
  }

// 4️⃣ **Step 4: Get Account ID**
  static Future<String> getAccountId(String sessionId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/account?api_key=$apiKey&session_id=$sessionId"),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String accountId = data["id"].toString();

      // Save account ID locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('account_id', accountId);

      print("✅ Account ID: $accountId");
      return accountId;
    } else {
      throw Exception("❌ Failed to get account ID");
    }
  }

// 5️⃣ **Step 5: Add Movie to Watchlist**
  static Future<bool> addToWatchlist(int movieId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('session_id');
    String? accountId = prefs.getString('account_id');

    if (sessionId == null || accountId == null) {
      throw Exception("❌ Missing session ID or account ID.");
    }

    final response = await http.post(
      Uri.parse(
          "$baseUrl/account/$accountId/watchlist?api_key=$apiKey&session_id=$sessionId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"media_type": "movie", "media_id": movieId, "watchlist": true}),
    );

    if (response.statusCode == 201) {
      print("✅ Movie added to watchlist!");
      Get.to(const WatchlistScreen());
      return true;
    } else {
      print("❌ Failed to add movie: ${response.body}");
      return false;
    }
  }

  static Future<void> authenticateUser() async {
    try {
      String requestToken = await getRequestToken();
      bool isValidated = await validateWithLogin(requestToken);

      if (isValidated) {
        String sessionId = await getSessionId(requestToken);
        String accountId = await getAccountId(sessionId);

        print("🎉 Authentication Successful!");
        print("🆔 Session ID: $sessionId");
        print("👤 Account ID: $accountId");

        // ✅ Ensure SharedPreferences is properly used in an async function
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("session_id", sessionId);
        await prefs.setString("account_id", accountId);

        print("✅ Session ID saved successfully!");
      } else {
        print("❌ Token validation failed!");
      }
    } catch (e) {
      print("❌ Error: $e");
    }
  }

// 5️⃣ **Execute All Steps in Order**
  static void addMovieToWatchlist(int movieId) async {
    bool success = await addToWatchlist(movieId);

    if (success) {
      print("🎬 Movie added successfully!");
    } else {
      print("❌ Could not add movie.");
    }
  }

  // Fetch Watchlist Movies
  static Future<List<dynamic>> fetchWatchlistMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("session_id");
    String? accountId = prefs.getString("account_id");

    if (sessionId == null || accountId == null) {
      throw Exception("Session ID or Account ID not found. Please log in.");
    }

    final response = await http.get(
      Uri.parse(
          "$baseUrl/account/$accountId/watchlist/movies?api_key=$apiKey&session_id=$sessionId"),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (kDebugMode) {
        print("All watch list is ${data["results"]}");
      }
      return data["results"]; // Returns the list of movies
    } else {
      throw Exception("Failed to fetch watchlist: ${response.body}");
    }
  }

  // Remove Movie from Watchlist
  static Future<bool> removeFromWatchlist(int movieId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("session_id");
    String? accountId = prefs.getString("account_id");

    if (sessionId == null || accountId == null) {
      throw Exception("Session ID or Account ID not found. Please log in.");
    }

    final response = await http.post(
      Uri.parse(
          "$baseUrl/account/$accountId/watchlist?api_key=$apiKey&session_id=$sessionId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "media_type": "movie",
        "media_id": movieId,
        "watchlist": false // ❌ Set to false to remove from watchlist
      }),
    );

    if (response.statusCode == 200) {
      return true; // ✅ Successfully removed
    } else {
      print("❌ Failed to remove movie: ${response.body}");
      return false;
    }
  }

  static Future<bool> isMovieInWatchlist(int movieId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("session_id");
    String? accountId = prefs.getString("account_id");

    final response = await http.get(
      Uri.parse(
          "$baseUrl/account/$accountId/watchlist/movies?api_key=$apiKey&session_id=$sessionId"),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List movies = data["results"];

      // Check if movie is in watchlist
      return movies.any((movie) => movie["id"] == movieId);
    } else {
      throw Exception("❌ Failed to fetch watchlist movies");
    }
  }
   static Future<bool> isMovieInFavoriteList(int movieId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString("session_id");
    String? accountId = prefs.getString("account_id");

    final response = await http.get(
      Uri.parse(
          "https://api.themoviedb.org/3/account/$accountId/favorite/movies?api_key=$apiKey&session_id=$sessionId"),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List movies = data["results"];

      // Check if movie is in watchlist
      return movies.any((movie) => movie["id"] == movieId);
    } else {
      throw Exception("❌ Failed to fetch favoriteList movies");
    }
  }

  static Future<bool> addToFavorites(int movieId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sessionId = prefs.getString('session_id');
    String? accountId = prefs.getString('account_id');

    if (sessionId == null || accountId == null) {
      throw Exception("❌ Missing session ID or account ID.");
    }

    final response = await http.post(
      Uri.parse(
          "https://api.themoviedb.org/3/account/$accountId/favorite?api_key=$apiKey&session_id=$sessionId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"media_type": "movie", "media_id": movieId, "favorite": true}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("✅ Movie added to favorites!");
      return true;
    } else {
      print("❌ Failed to add movie to favorites: ${response.body}");
      return false;
    }
  }

  static Future<List<MoviesModelClass>> fetchFavoritesMovies() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? sessionId = sharedPreferences.getString("session_id");
    String? accountId = sharedPreferences.getString("account_id");

    if (sessionId == null || accountId == null) {
      throw Exception("Sessino and account ids can not be null");
    }

    var response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/account/$accountId/favorite/movies?api_key=$apiKey&session_id=$sessionId"));
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      if(kDebugMode){
        print("All favorite movies list is ${data['results']}");
        print("Length of the favorite movies list is ${data['results'].length}");
      }
      List<MoviesModelClass> list = (data['results'] as List)
          .map((json) => MoviesModelClass.fromMap(json))
          .toList();
      return list;
    } else {
      throw Exception("Error while Fetching the favorite movies List");
    }
  }
  static Future<bool> removeFromFavorites(int movieId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? sessionId = prefs.getString('session_id');
  String? accountId = prefs.getString('account_id');

  if (sessionId == null || accountId == null) {
    throw Exception("❌ Missing session ID or account ID.");
  }

  final response = await http.post(
    Uri.parse("https://api.themoviedb.org/3/account/$accountId/favorite?api_key=$apiKey&session_id=$sessionId"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "media_type": "movie",
      "media_id": movieId,
      "favorite": false // ✅ Set to false to remove from favorites
    }),
  );

  if (response.statusCode == 200) {
    print("✅ Movie removed from favorites!");
    return true;
  } else {
    print("❌ Failed to remove movie: ${response.body}");
    return false;
  }
}

}
