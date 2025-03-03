import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tv_and_movie_explorer/data/models/movies_model_class.dart';

class SimilarMovieDetailsView extends StatefulWidget {
  const SimilarMovieDetailsView({super.key});

  @override
  State<SimilarMovieDetailsView> createState() => _SimilarMovieDetailsViewState();
}

class _SimilarMovieDetailsViewState extends State<SimilarMovieDetailsView> {
  @override
  Widget build(BuildContext context) {
    final MoviesModelClass movie=Get.arguments;
    return Scaffold(
       appBar: AppBar(title: Text(movie.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500${movie.posterImage}", // ✅ Display poster
                  height: 300,
                ),
              ),
              SizedBox(height: 20),
              Text(
                movie.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Release Date: ${movie.releaseDate}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                movie.description,
                style: TextStyle(fontSize: 16),
              ),
            
            ],
          ),
        ),
      ),
    );
  }
}