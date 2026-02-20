import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    // Start loading movies as soon as the screen is created
    _moviesFuture = loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ======== AppBar ========
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.movie),
            SizedBox(width: 10),
            Text('Top Rated Movies/Series from IMDB', style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),

      // ======== Body with FutureBuilder and background image ========
      body: Stack(
        children: [
          // Background image with opacity
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cinema_bg.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha:0.7),
                  BlendMode.darken,
                ),
              ),
            ),
          ),


        // ListView (theme handles Card styling!)
        FutureBuilder<List<Movie>>(
          future: _moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.white));
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No movies found', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white)));
            }

            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Card(  // Theme handles styling!
                  child: ListTile(  // Theme handles padding!
                    leading: _buildPoster(movie),
                    title: Text(movie.title, style: Theme.of(context).textTheme.titleMedium, maxLines: 1),        // Theme font!
                    subtitle: Text(movie.genre,style: Theme.of(context).textTheme.bodyMedium, maxLines: 2),     // Theme font!
                    trailing: Chip(                               // Theme chip!
                      label: Text(movie.imdbRating,),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(movie: movie),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    ),
  );
}

Widget _buildPoster(Movie movie) {
  if (movie.poster.isEmpty) {
    return Container(
      width: 120,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.movie, size: 40, color: Colors.grey[600]),
    );
  }

  return Container(
    width: 60,
    height: double.infinity, 
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: Offset(2, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        movie.poster,
        fit: BoxFit.fitHeight,  // Better fit
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(Icons.movie, size: 40, color: Colors.grey[600]),
          );
        },
      ),
    ),
  );
}
}
