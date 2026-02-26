class Dog {
  final int? id;
  final String name;
  final int age;

  Dog({this.id, required this.name, required this.age});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      name: json['name'] ?? '',
      age: json['age'] is String ? int.parse(json['age']) : json['age'],
    );
  }
}