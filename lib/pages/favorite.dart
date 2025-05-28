import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; 
import 'package:responsi_123220139/models/restaurant.dart'; 

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Restaurants"),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<RestaurantList>>(
        valueListenable: Hive.box<RestaurantList>('favoriteRestaurants').listenable(),
        builder: (context, box, _) {
          final favoriteRestaurants = box.values.toList();

          if (favoriteRestaurants.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada restoran favorit. Tambahkan beberapa!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteRestaurants.length,
            itemBuilder: (context, index) {
              final restaurant = favoriteRestaurants[index];
              return FavoriteRestaurantCard(restaurant: restaurant); // Menggunakan widget baru
            },
          );
        },
      ),
    );
  }
}

// Widget baru untuk card favorit dengan gambar di kanan
class FavoriteRestaurantCard extends StatelessWidget {
  final RestaurantList restaurant;

  const FavoriteRestaurantCard({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
      child: InkWell(
        onTap: () {
          // Aksi ketika card ditekan, misalnya navigasi ke halaman detail
          // Anda perlu mengimpor RestaurantDetailPage di sini jika belum
          // import 'package:latihan_responsi/pages/restaurant_detail_page.dart';
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => RestaurantDetailPage(restaurant: restaurant),
          //   ),
          // );
          print('Tapped on favorite: ${restaurant.name}');
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Padding di dalam card
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center, // Menyelaraskan konten secara vertikal di tengah
            children: [
              // Kolom untuk Teks (Name, City, Rating) di kiri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center, // Menyelaraskan teks secara vertikal di tengah
                  children: [
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      restaurant.city,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${restaurant.rating}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12.0), // Jarak antara teks dan gambar
              // Gambar di kanan
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // Sudut membulat untuk gambar
                child: Image.network(
                  restaurant.imageLink, // Gunakan imageLink dari model
                  width: 90, // Lebar gambar
                  height: 90, // Tinggi gambar
                  fit: BoxFit.cover, // Gambar akan di-crop agar sesuai
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}