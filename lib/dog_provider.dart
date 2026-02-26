import 'package:flutter/material.dart';
import 'dog.dart';
import 'api_service.dart';

class DogProvider with ChangeNotifier {
  List<Dog> _dogs = [];
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  List<Dog> get dogs => _dogs;
  bool get isLoading => _isLoading;

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

  Future<void> insertDog(String name, int age) async {
    await _apiService.addDog(Dog(name: name, age: age));
    await fetchDogs(); // WAJIB: Ambil data terbaru setelah input
  }

  Future<void> removeDog(int id) async {
    await _apiService.deleteDog(id);
    await fetchDogs(); // WAJIB: Ambil data terbaru setelah hapus
  }
}