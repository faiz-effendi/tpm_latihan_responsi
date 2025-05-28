import 'package:hive/hive.dart';

part 'restaurant.g.dart';

@HiveType(typeId: 0)
class RestaurantList {
  @HiveField(0) // FieldId harus unik dalam satu kelas
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String city;
  @HiveField(3)
  final String imageLink;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final double rating;

  RestaurantList({
    required this.id,
    required this.name,
    required this.city,
    required this.imageLink,
    required this.description,
    required this.rating,
  });

  factory RestaurantList.fromJson(Map<String, dynamic> json) {
    double convertedtRating;
    if (json['rating'] is num) {
      // Periksa apakah itu angka (int atau double)
      convertedtRating = (json['rating'] as num).toDouble();
    } else {
      // Berikan nilai default jika 'rating' tidak ada atau bukan angka
      // Sesuaikan nilai default ini sesuai kebutuhan Anda
      convertedtRating = 0.0;
    }

    return RestaurantList(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      city: json['city'] ?? "",
      imageLink: "https://restaurant-api.dicoding.dev/images/small/${json['pictureId']}",
      description: json['description'] ?? "",
      rating: convertedtRating,
    );
  }
}
