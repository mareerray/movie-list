import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie List',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        // 🎨 YOUR COLORS
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF890707),  // Red
          brightness: Brightness.dark,
        ),
        
        // 📝 GLOBAL POPPINS FONT
        textTheme: TextTheme(
          titleMedium: GoogleFonts.lato(     // Movie titles
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: GoogleFonts.lato(      // Genre (smaller/paler)
            fontSize: 12,
            color: Colors.white70,
          ),
          headlineSmall: GoogleFonts.poppins(   // AppBar
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        
        // 🎬 APPBAR (your red)
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF890707),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
        ),
        
        // 🃏 CARDS (dark semi-transparent)
        cardTheme: CardThemeData(
          color: Colors.black87.withValues(alpha: 0.4), 
          elevation: 12,
          shadowColor: Colors.black45,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        
        // 📱 LISTTILES
        listTileTheme: ListTileThemeData(
          contentPadding: EdgeInsets.fromLTRB(30, 14, 30, 14),
          dense: false,
          textColor: Colors.white,
          iconColor: Colors.white70,
        ),
        
        // ⭐ RATINGS (red pill style)
        chipTheme: ChipThemeData(
          backgroundColor: Color(0xFF890707),
          labelStyle: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        
        // 🎥 ICONS
        iconTheme: IconThemeData(color: Colors.white, size: 28),
        
        // 🖤 SCAFFOLD
        scaffoldBackgroundColor: Colors.transparent,
        
        useMaterial3: true,
      ),
      
      home: HomeScreen(),
    );
  }
}

