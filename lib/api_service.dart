import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dog.dart';

class ApiService {
  // Gunakan localhost jika running di Edge/Browser
  static const String baseUrl = 'http://localhost/flutter_api/dogs.php';

  Future<List<Dog>> getDogs() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Dog.fromJson(json)).toList();
      }
      throw Exception('Gagal memuat data');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> addDog(Dog dog) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dog.toJson()),
    );
    if (response.statusCode != 200) throw Exception('Gagal menambah data');
  }

  Future<void> deleteDog(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl?id=$id'));
    if (response.statusCode != 200) throw Exception('Gagal menghapus');
  }
}