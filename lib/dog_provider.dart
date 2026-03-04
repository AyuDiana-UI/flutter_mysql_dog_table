import 'package:flutter/material.dart';
import 'dog.dart';
import 'api_service.dart';

// Kelas antara main.dart dan api_service.dart.
// 
// Setiap kali ada operasi penambahan, update, atau penghapusan Dog di main.dart.
// dog_provider akan memerintahkan operasi tersebut ke api_service.dart
// 
// Lalu setelah operasi selesai,
// Ia memperoleh data-data Dog terbaru dan
// mengirimnya ke main.dart untuk memperbarui tampilannya.
class DogProvider with ChangeNotifier {
  List<Dog> _dogs = []; // Properti privat daftar Dog untuk main.dart
  // Mode loading yang jika nyala, 
  // main.dart akan mengganti tampilan daftar dengan icon loading
  bool _isLoading = false;  
  final ApiService _apiService = ApiService();

  List<Dog> get dogs => _dogs; 
  bool get isLoading => _isLoading;

  // Memperoleh data-data Dog terbaru,
  // lalu mengirimkannya ke main.dart untuk pembaruan tampilan.
  Future<void> fetchDogs() async {
    // Menyalakan mode loading. 
    _isLoading = true;
    
    // Memberitahu semua listener (penerima input) terhadap potensi pembaruan.
    notifyListeners();
    try {
      // Memperoleh data-data Dog terbaru dari api_service.dart
      _dogs = await _apiService.getDogs();
    } catch (e) {
      // Mengoutput dan print eror
      debugPrint("Error: $e");
    } finally {
      // Mematikan mode loading
      _isLoading = false;
      // Memberitahu semua listener lagi
      notifyListeners();
    }
  }

  // Menambahkan sebuah Dog baru ke API sekaligus memanggil fetchDogs
  Future<void> insertDog(String name, int age) async {
    // Memerintahkan penambahan Dog baru di api_service.dart
    await _apiService.addDog(Dog(name: name, age: age));
    
    await fetchDogs(); // WAJIB: Ambil data terbaru setelah input
  }

  // Menghapus sebuah Dog di API sekaligus memanggil fetchDogs
  Future<void> removeDog(int id) async {
    // Memerintahkan penghapusan Dog di api_service.dart
    await _apiService.deleteDog(id);
    
    await fetchDogs(); // WAJIB: Ambil data terbaru setelah hapus
  }
}
