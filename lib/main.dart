import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider; 
import 'package:responsi_123220139/models/restaurant.dart';

import './pages/login_page.dart';
import './pages/dashboard.dart';
import './pages/favorite.dart';
import './pages/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan Flutter binding terinisialisasi

  // Dapatkan path dokumen lokal untuk menyimpan database Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path); // Inisialisasi Hive

  // Daftarkan adapter yang dihasilkan oleh hive_generator
  Hive.registerAdapter(RestaurantListAdapter()); // Pastikan nama adapter sesuai dengan yang di-generate (biasanya nama_kelasAdapter)

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => Dashboard(),
        '/favorite': (context) => FavoritePage(),
        '/register': (context) => RegisterPage(),
      },

      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
        ),
        
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}