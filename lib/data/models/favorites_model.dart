import 'package:hive/hive.dart';

part 'favorites_model.g.dart';

@HiveType(typeId: 0)
class FavoritesModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double popularity;

  @HiveField(4)
  final String posterImage;

  @HiveField(5)
  final String releaseDate;

  FavoritesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.popularity,
    required this.posterImage,
    required this.releaseDate,
  });

  factory FavoritesModel.fromJson(Map<String, dynamic> json) {
    return FavoritesModel(
      id: json['id'],
      title: json['title'],
      description: json['overview'],
      popularity: json['popularity'].toDouble(),
      posterImage: json['poster_path'],
      releaseDate: json['release_date'],
    );
  }
}
