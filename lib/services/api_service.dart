import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artwork_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.artic.edu/api/v1/artworks';

  Future<List<Artwork>> fetchArtworks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> artworks = data['data'];
        return artworks.map((json) => Artwork.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load artworks');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Artwork> fetchArtworkDetail(int id) async {
    final url = 'https://api.artic.edu/api/v1/artworks/$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return Artwork.fromJson(data);
    } else {
      throw Exception('Failed to load artwork detail');
    }
  }
}
