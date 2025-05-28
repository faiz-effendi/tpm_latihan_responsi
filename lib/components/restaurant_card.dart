import 'package:flutter/material.dart';

import 'package:responsi_123220139/models/restaurant.dart';
import '../pages/restaurant_detail.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantList restaurant; // Menerima objek Restaurant

  const RestaurantCard({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Margin agar ada jarak antar card
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Sudut membulat
      ),
      elevation: 4.0, // Efek bayangan
      child: InkWell( // Tambahkan InkWell agar card bisa diklik dan ada efek ripple
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantDetailPage(restaurant: restaurant),
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.network(
                restaurant.imageLink, // Gunakan imageUrl dari objek Restaurant
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[400],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name, // Gunakan nama dari objek Restaurant
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    restaurant.city, // Gunakan nama dari objek Restaurant
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
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
                  const SizedBox(height: 8.0),
                  Row( // Gunakan Row untuk menempatkan ikon di ujung kiri bawah
                    mainAxisAlignment: MainAxisAlignment.end, // Posisikan di paling kanan
                    children: [
                      Icon(Icons.arrow_forward), // Ikon panah ke kanan
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}