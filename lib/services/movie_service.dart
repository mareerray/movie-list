import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/movie.dart';

// This function loads JSON -> Movie objects -> sorts by rating
Future<List<Movie>> loadMovies() async {
  // step 1: Load the raw JSON file from assets
  final String jsonString = await rootBundle.loadString('assets/movies.json');

  // step 2: Convert the JSON string -> List of dynamic objects (maps)
  final List<dynamic> jsonList = json.decode(jsonString);

  // step 3: Convert each dynamic object (map) -> Movie object
  final List<Movie> movies = jsonList.map((json) => Movie.fromJson(json)).toList();

  // step 4: Sort the movies by imdbRating (highest first)
  movies.sort((a, b) {
    // Convert the imdbRating from String to double for comparison
    final double ratingA = double.tryParse(a.imdbRating) ?? 0.0;
    final double ratingB = double.tryParse(b.imdbRating) ?? 0.0;

    // Sort in descending order (highest rating first)
    return ratingB.compareTo(ratingA);
  });
  return movies;
}