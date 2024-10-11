class Item {
  String id;
  String name;

  Item({required this.id, required this.name});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  static Item fromJson(Map<String, dynamic> json, String id) {
    return Item(
      id: id,
      name: json['name'],
    );
  }
}
