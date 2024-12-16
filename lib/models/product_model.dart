class Product {
  final int id;
  final String name;
  final String brand;
  final String imageUrl;
  final String price;
  final int year;
  final int categoryId;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.year,
    required this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      imageUrl: json['image_url'],
      price: json['price'],
      year: json['year'],
      categoryId: json['category_id'],
    );
  }
}
