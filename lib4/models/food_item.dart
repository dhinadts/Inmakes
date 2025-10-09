class FoodItem {
  final String id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String subCategory;
  final String imageUrl;
  final String rating;
  final String discount;
  final bool isAvailable;

  FoodItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.subCategory,
    required this.imageUrl,
    required this.rating,
    required this.discount,
    required this.isAvailable,
  });

  factory FoodItem.fromMap(String id, Map<String, dynamic> map) => FoodItem(
    id: id,
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    price: (map['price'] ?? 0).toDouble(),
    category: map['category'] ?? '',
    subCategory: map['subCategory'] ?? '',
    imageUrl: map['imageUrl'] ?? '',
    rating: map['rating'] ?? '',
    discount: map['discount'] ?? '',
    isAvailable: map['isAvailable'] ?? true,
  );

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'price': price,
    'category': category,
    'subCategory': subCategory,
    'imageUrl': imageUrl,
    'rating': rating,
    'discount': discount,
    'isAvailable': isAvailable,
  };
}
