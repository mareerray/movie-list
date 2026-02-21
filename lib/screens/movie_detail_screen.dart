import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ======== AppBar ========
      appBar: AppBar(
        backgroundColor: const Color(0xFF890707),
        title: Text('${widget.movie.title} (${widget.movie.year})'),
        titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
      ),
      
      // ======== Body with background image ========
      body: PopScope(
        canPop: true,
        child:Container(
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

          // Scrollable content
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🎨 IMAGE SLIDER
                _buildImageSlider(),
                
                SizedBox(height: 30),
                
                // 📊 INFO CARDS
                _buildInfoCard('Genre', widget.movie.genre),
                _buildInfoCard('Type', widget.movie.type.toUpperCase()),
                _buildInfoCard('IMDb Rating', widget.movie.imdbRating),
                _buildInfoCard('Director', widget.movie.director),
                _buildInfoCard('Actors', widget.movie.actors),
                _buildInfoCard('Runtime', widget.movie.runtime),
                _buildInfoCard('Awards', widget.movie.awards),
                SizedBox(height: 20),

                // 📝 PLOT CARD
                _buildPlotCard(widget.movie.plot),
                
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
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

  // ======== HELPER WIDGETS ========

  // Builds either the image slider (if multiple images) or a single poster
  Widget _buildImageSlider() {
    if (widget.movie.images.isEmpty) {
      return _buildPoster(widget.movie.poster);
    }
    
    return Column(
      children: [
        // Main slider
        SizedBox(
          height: 380,
          child:Padding(
            padding: EdgeInsets.only(left: 15),
            child: PageView.builder(
              onPageChanged: (index) => setState(() => _currentImageIndex = index),
              itemCount: widget.movie.images.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, 10)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.movie.images[index],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => _buildPoster(widget.movie.poster),
                  ),
                ),
              ),
            ),
          ),
        ),
        
        SizedBox(height: 12),
        
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.movie.images.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentImageIndex == entry.key 
                  ? Color(0xFF890707) 
                  : Colors.white38,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Builds a single poster image with error handling
  Widget _buildPoster(String posterUrl) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          posterUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => Icon(Icons.movie, size: 80, color: Colors.white70),
        ),
      ),
    );
  }

  // Builds a labeled info card for displaying movie details
  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      decoration: BoxDecoration(
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Chip(
            label: Text(label, style: GoogleFonts.poppins(color: Color(0xFF890707), fontWeight: FontWeight.bold)),
            backgroundColor: Colors.black87.withValues(alpha:0.8),
            // elevation: 2,
            shadowColor: Colors.black26,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),  
          SizedBox(width: 12),        
          Expanded(child: Text(value, style: GoogleFonts.lato(fontSize: 14, color: Colors.white))),
        ],
      ),
    );
  }

  // Builds a card specifically for the movie plot, slightly a different style
  Widget _buildPlotCard(String plot) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black87.withValues(alpha:0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha:0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plot:', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF890707))),
          SizedBox(height: 12),
          Text(plot, style: GoogleFonts.lato(fontSize: 14, color: Colors.white, height: 1.6)),
        ],
      ),
    );
  }
}
