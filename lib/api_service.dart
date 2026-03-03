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
  // Tiap operasi API akan membuat sebuah objek URI (Uniform Resource Identifier) dengan base URL.
  // Objek URI digunakan untuk mengakses semua resource dari alamat URI tersebut
  static const String baseUrl = 'http://localhost/flutter_api/dogs.php';

  // Memperoleh semua data-data Dog.
  Future<List<Dog>> getDogs() async {
    try {
      // Menjalankan operasi HTTP GET.
      // Setelah selesai, server akan merespon dengan suatu kode status.
      final response = await http.get(Uri.parse(baseUrl));

      // Kode status 200 atau 'OK' merupakan kode umum untuk operasi API yang sukses.
      if (response.statusCode == 200) {
        // Mengubah String response menjadi sebuah List yang terdiri atas map-map Dog.
        List<dynamic> data = json.decode(response.body);

        // Membuat lalu mengoutput sebuah List baru yang terdiri atas instansi kelas Dog.
        return data.map((json) => Dog.fromJson(json)).toList();
      }
      
      // Jika operasi gagal, maka fungsi akan melempar eror.
      throw Exception('Gagal memuat data');
    } catch (e) {
      // Eror yang dilempar dari blok try.
      // Error: Gagal memuat data
      throw Exception('Error: $e');
    }
  }

  // Menambahkan satu Dog baru menggunakan HTTP POST.
  Future<void> addDog(Dog dog) async
    // Menjalankan operasi HTTP POST yang menambah suatu data kepada API.
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      // Mengstruktur lalu mengkonversi data Dog menjadi data JSON.
      body: json.encode(dog.toJson()),
    );

    // Jika operasi gagal, maka fungsi akan melempar eror.
    if (response.statusCode != 200) throw Exception('Gagal menambah data');
  }

  // Menghapus suatu Dog berdasarkan ID menggunakan HTTP DELETE.
  Future<void> deleteDog(int id) async {
    // baseUrl ditambah juga sebuah query parameter ID untuk melacak target Dog.
    final response = await http.delete(Uri.parse('$baseUrl?id=$id'));

    // Jika operasi gagal, maka fungsi akan melempar eror.
    if (response.statusCode != 200) throw Exception('Gagal menghapus');
  }
}
