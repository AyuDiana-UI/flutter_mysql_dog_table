import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dog.dart';

// Kelas yang menjembatani aplikasi dengan RESTful API di localhost.
// Ia memberi perintah kepada API menggunakan HTTP GET, POST, dan DELETE.
//
// Future merupakan hasil dari komputasi async / tidak sinkron.
// Suaut fungsi async memperoleh suatu output dari sumber luar, contohnya dari API.
// Daripada menunda komputasi hingga outputnya tersedia,
// Future akan langsung dibuat, lalu line yang menggunakan keyword await akan ditunggu sebelum lanjut.
class ApiService {
  // Alamat API localhost
  // Gunakan localhost jika running di Edge/Browser
  static const String baseUrl = 'http://localhost/flutter_api/dogs.php';

  // Memperoleh semua data-data Dog menggunakan HTTP GET.
  Future<List<Dog>> getDogs() async {
    try {
      // Menjalankan suatu operasi HTTP.
      // Setelah selesai, server akan merespon dengan suatu kode status.
      final response = await http.get(Uri.parse(baseUrl));

      // Melempar eror jika operasi API gagal.
      // Kode status 200 atau 'OK' merupakan kode umum untuk operasi API yang sukses.
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Dog.fromJson(json)).toList();
      }
      throw Exception('Gagal memuat data');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Menambahkan satu Dog baru menggunakan HTTP POST.
  Future<void> addDog(Dog dog) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dog.toJson()),
    );
    if (response.statusCode != 200) throw Exception('Gagal menambah data');
  }

  // Menghapus suatu Dog berdasarkan ID menggunakan HTTP DELETE.
  Future<void> deleteDog(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl?id=$id'));
    if (response.statusCode != 200) throw Exception('Gagal menghapus');
  }
}
