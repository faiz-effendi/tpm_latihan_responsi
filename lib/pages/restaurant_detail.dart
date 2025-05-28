import 'package:flutter/material.dart';
import 'package:responsi_123220139/models/restaurant.dart';
import 'package:hive/hive.dart';

class RestaurantDetailPage extends StatefulWidget {
  final RestaurantList restaurant; // Menerima objek Restaurant lengkap
  const RestaurantDetailPage({super.key, required this.restaurant});

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  // State untuk melacak apakah restoran favorit atau tidak
  bool _isFavorite = false;
  // Deklarasikan Box untuk Hive
  late Box<RestaurantList> _favoriteRestaurantsBox; // <<<--- DEKLARASI BOX

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk membuka Box dan memeriksa status favorit saat widget dibuat
    _initHiveBoxAndCheckFavoriteStatus();
  }

  Future<void> _initHiveBoxAndCheckFavoriteStatus() async {
    // Buka Box. 'favoriteRestaurants' adalah nama Box Anda.
    // Pastikan nama ini konsisten di seluruh aplikasi.
    _favoriteRestaurantsBox = await Hive.openBox<RestaurantList>('favoriteRestaurants');

    // Periksa apakah restoran saat ini sudah ada di dalam Box favorit
    // Kita menggunakan 'id' restoran sebagai kunci unik di Hive
    setState(() {
      _isFavorite = _favoriteRestaurantsBox.containsKey(widget.restaurant.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Akses properti 'restaurant' melalui 'widget.restaurant'
        title: Text(widget.restaurant.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar utama
            Image.network(
              // Akses properti 'imageLink' melalui 'widget.restaurant'
              widget.restaurant.imageLink,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              // Tambahkan loadingBuilder untuk indikator loading gambar
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              // Tambahkan errorBuilder untuk penanganan error gambar
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row( // Menggunakan Row untuk menata nama dan ikon hati
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Agar nama di kiri, ikon di kanan
                    children: [
                      Expanded( // Menggunakan Expanded agar nama tidak overflow jika terlalu panjang
                        child: Text(
                          // Akses properti 'name' melalui 'widget.restaurant'
                          widget.restaurant.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis, // Jika nama terlalu panjang, tampilkan ...
                          maxLines: 2, // Batasi hingga 2 baris
                        ),
                      ),
                      IconButton(
                        // Mengganti ikon berdasarkan state _isFavorite
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : Colors.grey, // Mengganti warna berdasarkan state
                          size: 30, // Ukuran ikon
                        ),
                        onPressed: () async { // <<<--- JADIKAN onPressed ASYNC
                          if (_isFavorite) {
                            // Jika sudah favorit, hapus dari Hive
                            await _favoriteRestaurantsBox.delete(widget.restaurant.id); // <<<--- OPERASI HIVE DELETE
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${widget.restaurant.name} dihapus dari favorit.'),
                                duration: const Duration(seconds: 1), // Durasi SnackBar
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            // Jika belum favorit, tambahkan ke Hive
                            await _favoriteRestaurantsBox.put(widget.restaurant.id, widget.restaurant); // <<<--- OPERASI HIVE PUT
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${widget.restaurant.name} ditambahkan ke favorit!'),
                                duration: const Duration(seconds: 1), // Durasi SnackBar
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                          // Perbarui state UI setelah operasi Hive selesai
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // Akses properti 'city' melalui 'widget.restaurant'
                    widget.restaurant.city,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8), // Tambahkan SizedBox untuk jarak ke rating
                  Row( // Tambahkan Row untuk menampilkan rating dengan ikon bintang
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        // Asumsi ada properti 'rating' di RestaurantList Anda
                        '${widget.restaurant.rating}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // Akses properti 'description' melalui 'widget.restaurant'
                    widget.restaurant.description,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
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