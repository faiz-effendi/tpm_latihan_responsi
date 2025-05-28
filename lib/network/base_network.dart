import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class BaseNetwork {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev";
  static final _logger = Logger();

  // sebuah method future (async) dengan tipe data list/array. List berisi string dan tipe data selain string tetep ke handle
  static Future<List<Map<String, dynamic>>> getAll(String path) async {
    final uri = Uri.parse("$_baseUrl/$path");
    _logger.i("GET ALL : $uri");

    try {
      final response = await http.get(uri).timeout(Duration(seconds: 10));
      _logger.i("RESPONSE : ${response.statusCode}");
      _logger.i("BODY : ${response.body}");

      if (response.statusCode == 200) {
        // Dekode seluruh body respons menjadi Map<String, dynamic>
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Periksa apakah ada kunci 'restaurants' dan apakah nilainya adalah List
        if (jsonResponse.containsKey('restaurants') && jsonResponse['restaurants'] is List) {
          final List<dynamic> jsonList = jsonResponse['restaurants'];
          return jsonList.cast<Map<String, dynamic>>();
        } else {
          _logger.e("ERROR: 'restaurants' key not found or not a list in response body.");
          throw Exception("Invalid response format: 'restaurants' key not found or not a list.");
        }
      } else {
        _logger.e("ERROR : ${response.statusCode}");
        throw Exception("SERVER ERROR : ${response.statusCode}");
      }
    } on TimeoutException {
      _logger.e("Request timeout to $uri");
      throw Exception("Request timeout");
    } catch(e) {
      _logger.e("Error fetching data from $uri : $e");
      throw Exception("Error fetching data : $e"); // Perbaiki typo "feching" menjadi "fetching"
    }
  } 

  static Future<List<Map<String, dynamic>>> getDetails(String id) async {
    final uri = Uri.parse("$_baseUrl/detail/$id");
    _logger.i("GET DETAIL : $uri");

    try {
      final response = await http.get(uri).timeout(Duration(seconds: 10));
      _logger.i("RESPONSE : ${response.statusCode}");
      _logger.i("BODY : ${response.body}");

      if (response.statusCode == 200) {
        // Dekode seluruh body respons menjadi Map<String, dynamic>
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Periksa apakah ada kunci 'restaurants' dan apakah nilainya adalah List
        if (jsonResponse.containsKey('restaurant') && jsonResponse['restaurant'] is List) {
          final List<dynamic> jsonList = jsonResponse['restaurant'];
          return jsonList.cast<Map<String, dynamic>>();
        } else {
          _logger.e("ERROR: 'restaurants' key not found or not a list in response body.");
          throw Exception("Invalid response format: 'restaurants' key not found or not a list.");
        }
      } else {
        _logger.e("ERROR : ${response.statusCode}");
        throw Exception("SERVER ERROR : ${response.statusCode}");
      }
    } on TimeoutException {
      _logger.e("Request timeout to $uri");
      throw Exception("Request timeout");
    } catch(e) {
      _logger.e("Error fetching data from $uri : $e");
      throw Exception("Error fetching data : $e"); // Perbaiki typo "feching" menjadi "fetching"
    }
  } 
}