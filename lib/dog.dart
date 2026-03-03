// Kelas yang menyimpan data suatu dog / anjing, yaitu ID, nama, dan umurnya.
class Dog {
  // Properti-properti
  final int? id; // Properti ini tidak wajib karena akan diassign secara otomatis di database.
  final String name; // Properti wajib nama Dog
  final int age; // Properti wajib umur Dog

  // Parameter instansi ketika membuat Dog baru
  // Contoh: Dog(2, "Horse", 20);
  Dog({this.id, required this.name, required this.age});

  // Mengoutput sebuah Map data Dog 
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
    return Dog(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'] ?? '', // Seandainya juga name berupa Null, ia akan digantikan oleh String kosong. 
      age: json['age'] is String ? int.parse(json['age']) : json['age'],
    );
  }
}
