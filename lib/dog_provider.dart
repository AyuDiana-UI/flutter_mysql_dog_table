import 'package:flutter/material.dart';
import 'dog.dart';
import 'api_service.dart';

// Kelas antara main.dart dan api_service.dart.
// 
// Setiap perubahan dari main.dart, akan dijalin ke api_service.dart
// lalu akan memperoleh daftar data Dog terbaru dan 
// memberi notifikasi untuk klien terhadap perubahan tersebut.
class DogProvider with ChangeNotifier {
  List<Dog> _dogs = []; // Properti privat daftar Dog untuk main.dart
  bool _isLoading = false; // Properti private yang memicu penampilan icon loading di main.dart
  final ApiService _apiService = ApiService();

  List<Dog> get dogs => _dogs; 
  bool get isLoading => _isLoading;

  // Memperoleh data-data Dog dari api_service.dart
  // Lalu memberi sinyal pembaruan ke main.dart
  Future<void> fetchDogs() async {
    _isLoading = true;
    notifyListeners();
    try {
      _dogs = await _apiService.getDogs();
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Memicu penambahan Dog baru di api_service.dart sekaligus memanggil fetchDogs.
  Future<void> insertDog(String name, int age) async {
    await _apiService.addDog(Dog(name: name, age: age));
    await fetchDogs(); // WAJIB: Ambil data terbaru setelah input
  }

  // Memicu penghapusan Dog di api_service.dart sekaligus memanggil fetchDogs.
  Future<void> removeDog(int id) async {
    await _apiService.deleteDog(id);
    await fetchDogs(); // WAJIB: Ambil data terbaru setelah hapus
  }
}
