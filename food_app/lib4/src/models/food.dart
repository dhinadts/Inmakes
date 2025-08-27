class Food {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  Food({required this.id, required this.name, required this.description, required this.price, required this.imageUrl, required this.category});

  factory Food.fromMap(String id, Map<String, dynamic> m) {
    return Food(
      id: id,
      name: m['name'] ?? '',
      description: m['description'] ?? '',
      price: (m['price'] ?? 0).toDouble(),
      imageUrl: m['imageUrl'] ?? '',
      category: m['category'] ?? 'General',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'category': category,
  };
}
