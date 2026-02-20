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
      appBar: AppBar(
        backgroundColor: const Color(0xFF890707),
        title: Text('${widget.movie.title} (${widget.movie.year})'),
      ),
      
      body: Container(
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
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 180),
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
              _buildPlotCard(widget.movie.plot),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    if (widget.movie.images.isEmpty) {
      return _buildPoster(widget.movie.poster);
    }

    return Column(
      children: [
        // Main slider
        SizedBox(
          height: 300,
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

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: BoxDecoration(
        // color: Colors.black87.withValues(alpha:0.8),
        // borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: Colors.white.withValues(alpha:0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF890707),
              ),
            ),
          ),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white))),
        ],
      ),
    );
  }

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
          Text(plot, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white, height: 1.6)),
        ],
      ),
    );
  }
}
