class MoviesModelClass {
  final int id;
  final String title;
  final String description;
  final String posterImage; // New field for image URL
  final String releaseDate;
  final double popularity;

  MoviesModelClass({
    required this.id,
    required this.title,
    required this.description,
    required this.popularity,
    required this.posterImage,
    required this.releaseDate,
  });

  // Convert MoviesModelClass to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'release_date': releaseDate,
      'overview': description,
      "poster_path": posterImage,
      "popularity": popularity
    };
  }

  // Create MoviesModelClass from Firestore Map
  factory MoviesModelClass.fromMap(Map<String, dynamic> map) {
    return MoviesModelClass(
      title: map['title'],
      releaseDate: map['release_date'] ?? "",
      id: map['id'],
      description: map['overview'] ?? '',
      posterImage:
          "https://image.tmdb.org/t/p/w500${map['poster_path']}", // Append base URL
      popularity: map['popularity'],
    );
  }
}
