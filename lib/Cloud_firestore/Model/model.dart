class User {
  String id;
  String name;
  int age;

  User({required this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
    };
  }

  factory User.fromMap(String id, Map<String, dynamic> map) {
    return User(
      id: id,
      name: map['name'],
      age: map['age'],
    );
  }
}
