/// Bước 1: Xây dựng lớp Product
/// Lớp này đại diện cho một sản phẩm với các thuộc tính cơ bản

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int quantity;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  /// Phương thức copyWith để tạo bản sao với một số thuộc tính thay đổi
  Product copyWith({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required int quantity,
  }) {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity,
    );
  }
}
