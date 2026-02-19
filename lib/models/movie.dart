class Movie {
  final String genre;
  final String imdbRating;
  final String title;
  final String poster;

  Movie(this.genre, this.imdbRating, this.title, this.poster);

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      json['genre'] as String,
      json['imdbRating'] as String,
      json['title'] as String,
      json['poster'] as String,
    );
  }
}