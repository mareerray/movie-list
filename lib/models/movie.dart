class Movie {
  final String genre;
  final String imdbRating;
  final String title;
  final String poster;

  final String year, runtime;
  final String director, writer, actors;
  final String plot, awards;
  final String type;
  final List<String> images;


  // Standard constructor
  // Movie(this.genre, this.imdbRating, this.title, this.poster);
  Movie({
    required this.title, required this.year,
    required this.runtime, required this.genre,
    required this.director, required this.writer,
    required this.plot, required this.actors,
    required this.awards, required this.poster,
    required this.imdbRating, 
    required this.type, required this.images,
  });

  // Factory constructor for JSON serialization
  // takes a Map<String, dynamic> (the result of decoding a JSON string) 
  // key = String, value = any type (dynamic)
  // and returns an instance of Movie object
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      genre: json['Genre'] ?? 'Unknown',
      imdbRating: json['imdbRating'] ?? '0.0',
      title: json['Title'] ?? 'Untitled',
      poster: json['Poster'] ?? '',
      actors: json['Actors'] ?? 'N/A',
      plot: json['Plot'] ?? 'No plot available',
      runtime: json['Runtime'] ?? 'N/A',
      awards: json['Awards'] ?? 'N/A',
      director: json['Director'] ?? 'N/A',
      writer: json['Writer'] ?? 'N/A',
      type: json['Type'] ?? 'movie',
      images: List<String>.from(json['Images'] ?? []),  // Convert dynamic list

      year: (json['Year']?.toString() ?? 'N/A').replaceAll(('–'), '').trim(),
    );
  }
}