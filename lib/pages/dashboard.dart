import 'package:flutter/material.dart';
import 'package:responsi_123220139/components/restaurant_card.dart';

import 'package:shared_preferences/shared_preferences.dart'; // IMPORT PACKAGE SHARED PREFERENCES
import 'package:responsi_123220139/models/restaurant.dart';
import 'package:responsi_123220139/network/base_network.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late SharedPreferences loginData;
  late String username = '';
  String? snackbarMessage; // ⬅️ simpan message dari arguments

  Future<List<RestaurantList>> _getAllRestaurant() async {
    final rawList = await BaseNetwork.getAll("list");
    return rawList.map((e) => RestaurantList.fromJson(e)).toList();
  } 

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        snackbarMessage = args;
      }
      initial();
    });
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      username = loginData.getString('username') ?? '';
    });

    // Setelah state siap, tampilkan snackbar (sekali saja)
    if (snackbarMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarMessage!),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      snackbarMessage = null; // Kosongin supaya gak muncul lagi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hai, $username"),
        centerTitle: true,
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Hello, $username',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorite'),
              onTap: () {
                Navigator.pushNamed(context, '/favorite');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                await loginData.setBool('isLogin', false);
                // await loginData.clear();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: FutureBuilder(
        future: _getAllRestaurant(), 
        builder: (context, snapshot) {
          // loading
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // error
          if(snapshot.hasError) {
            return Center(child: Text("Error : ${snapshot.error}"));
          }  

          //data
          final RestaurantList = snapshot.data!;

          return ListView.builder(
            itemCount: RestaurantList.length, 
            itemBuilder: (context, i) {
              final restaurant = RestaurantList[i];
              return RestaurantCard(restaurant: restaurant);
            }
          );
        },
      )
    );
  }
}
