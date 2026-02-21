import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String query = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start loading movies as soon as the screen is created
    _moviesFuture = loadMovies();
  }

  // When user leaves HomeScreen (back button, new screen), 
  // Flutter calls -> dispose() = Clean up when screen closes
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            Expanded(  // Makes title shrink if needed
              child: Text(
                'Top Rated Movies / Series from IMDB',
                style: Theme.of(context).textTheme.headlineSmall,
                overflow: TextOverflow.ellipsis,  // Handles long text
              ),
            ),
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
          Column(
            children: [

              // Search bar at top of body, before movie list
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.lato(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    hintStyle: GoogleFonts.lato(color: Colors.white60),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.white60),
                    suffixIcon: query.isNotEmpty 
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.white60),
                          onPressed: () {
                            query = '';
                            _searchController.clear();  
                            setState(() {});
                          },
                        )
                      : null,
                  ),
                  onChanged: (value) => setState(() => query = value.toLowerCase()),
                ),
              ),

              // ListView (theme handles Card styling!)
              Expanded(
                child: FutureBuilder<List<Movie>>(
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
                    final filteredMovies = movies.where((movie) =>
                      movie.title.toLowerCase().contains(query)).toList();

                    return ListView.builder(
                      itemCount: filteredMovies.length,
                      itemBuilder: (context, index) {
                        final movie = filteredMovies[index];
                        return Card(  
                          child: ListTile(  
                            leading: _buildPoster(movie),
                            title: Text(movie.title, style: Theme.of(context).textTheme.titleMedium, maxLines: 1),        // Theme font!
                            subtitle: Text(movie.genre,style: Theme.of(context).textTheme.bodyMedium, maxLines: 2),     // Theme font!
                            trailing: Chip(                               
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
              ),
            ],
          ),
        ],
      ),

      // ======== Footer ========
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        color: const Color(0xFF890707),
        child: Text(
          '© 2026 Movie List App. Data source: IMDb • made by Mayuree Reunsati',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
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
