/// Bước 2: Xây dựng lớp ProductRepository và khai báo productProvider
///
/// ProductRepository: Chứa logic lấy dữ liệu (có thể từ API, database, hoặc mock data)
/// productProvider: FutureProvider để cung cấp dữ liệu cho UI

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entity/Product.dart';

/// Lớp ProductRepository chứa các phương thức lấy dữ liệu sản phẩm
class ProductRepository {

  /// Phương thức lấy danh sách sản phẩm (giả lập gọi API)
  /// Trong thực tế, đây sẽ là nơi gọi HTTP request đến server
  static Future<List<Product>> fetchProducts() async {
    // Giả lập delay như khi gọi API thực tế
    await Future.delayed(const Duration(seconds: 2));

    // Trả về danh sách sản phẩm mock
    return [
      const Product(
        id: "P01",
        name: "iPhone 15 Pro Max",
        description: "Điện thoại cao cấp của Apple với chip A17 Pro, camera 48MP.",
        price: 34990000,
        imageUrl: "assets/images/leo.jpg",
        quantity: 50,
      ),
      const Product(
        id: "P02",
        name: "Samsung Galaxy S24 Ultra",
        description: "Flagship Android với S Pen, camera 200MP và AI features.",
        price: 31990000,
        imageUrl: "assets/images/leo.jpg",
        quantity: 35,
      ),
      const Product(
        id: "P03",
        name: "MacBook Pro M3",
        description: "Laptop mạnh mẽ với chip M3 Pro, màn hình Liquid Retina XDR.",
        price: 49990000,
        imageUrl: "assets/images/leo.jpg",
        quantity: 20,
      ),
      const Product(
        id: "P04",
        name: "iPad Pro 12.9 inch",
        description: "Tablet cao cấp với chip M2, màn hình mini-LED.",
        price: 28990000,
        imageUrl: "assets/images/leo.jpg",
        quantity: 25,
      ),
      const Product(
        id: "P05",
        name: "AirPods Pro 2",
        description: "Tai nghe không dây với Active Noise Cancellation.",
        price: 6490000,
        imageUrl: "assets/images/leo.jpg",
        quantity: 100,
      ),
    ];
  }
}

/// Khai báo FutureProvider để cung cấp dữ liệu sản phẩm
///
/// FutureProvider tự động xử lý:
/// - Trạng thái loading khi đang fetch dữ liệu
/// - Trạng thái error nếu có lỗi xảy ra
/// - Trạng thái data khi fetch thành công
///
/// Cách sử dụng trong Widget:
///   final asyncProducts = ref.watch(productProvider);
///   asyncProducts.when(
///     loading: () => CircularProgressIndicator(),
///     error: (err, stack) => Text('Error: $err'),
///     data: (products) => ListView.builder(...),
///   );
final productProvider = FutureProvider<List<Product>>((ref) async {
  return ProductRepository.fetchProducts();
});
