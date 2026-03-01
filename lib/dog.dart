// Kelas yang menyimpan data suatu dog / anjing, yaitu ID, nama, dan umurnya.
class Dog {
  // Properti-properti
  final int? id; // Properti ini tidak wajib karena diberikan secara otomatis di database.
  final String name;
  final int age;

  // Inisialisasi instansi
  Dog({this.id, required this.name, required this.age});

  // Mengoutput data dog dalam format Map 
  // yang dapat diterima sebagai data JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Mengoutput instansi Dog baru dengan data JSON.
  factory Dog.fromJson(Map<String, dynamic> json) {
    // id dan age akan diperiksa tipe datanya masing-masing.
    // Seandainya berupa String, ia akan dikonversi menjadi int terlebih dahulu.
    //
    // Seandainya juga name berupa Null, ia akan digantikan oleh String kosong. 
    return Dog(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'] ?? '',
      age: json['age'] is String ? int.parse(json['age']) : json['age'],
    );
  }
}
