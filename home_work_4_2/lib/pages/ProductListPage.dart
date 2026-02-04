/// Bước 3: Tạo ProductListPage sử dụng ConsumerWidget
///
/// Thay vì dùng StatelessWidget/StatefulWidget, ta dùng:
/// - ConsumerWidget: Thay thế StatelessWidget
/// - ConsumerStatefulWidget: Thay thế StatefulWidget
///
/// ConsumerWidget cho phép truy cập ref để đọc dữ liệu từ Provider

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entity/Product.dart';
import '../repository/ProductRepository.dart';

/// ProductListPage - Sử dụng ConsumerWidget thay vì StatelessWidget
///
/// KHÁC BIỆT CHÍNH:
/// - StatelessWidget: Widget build(BuildContext context)
/// - ConsumerWidget: Widget build(BuildContext context, WidgetRef ref)
///                   ^^ ref cho phép đọc dữ liệu từ Provider
class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product List"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(ref),
    );
  }

  /// Method riêng để xây dựng phần body
  /// Xử lý 3 trạng thái: loading, error, data
  Widget _buildBody(WidgetRef ref) {
    // Đọc dữ liệu từ ProviderScope bằng ref.watch(productProvider)
    // ref.watch() tự động rebuild widget khi dữ liệu thay đổi
    final asyncProducts = ref.watch(productProvider);

    return asyncProducts.when(
      // Trạng thái đang tải dữ liệu
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Đang tải dữ liệu..."),
          ],
        ),
      ),

      // Trạng thái có lỗi
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text("Lỗi: $error"),
            ElevatedButton(
              onPressed: () {
                // Refresh lại dữ liệu
                ref.invalidate(productProvider);
              },
              child: const Text("Thử lại"),
            ),
          ],
        ),
      ),

      // Trạng thái có dữ liệu
      data: (products) => ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}

/// ProductCard - Widget hiển thị thông tin một sản phẩm
/// Sử dụng ConsumerStatefulWidget thay vì StatefulWidget
///
/// KHÁC BIỆT CHÍNH:
/// - StatefulWidget -> ConsumerStatefulWidget
/// - State<T> -> ConsumerState<T>
/// - ref có sẵn trong ConsumerState, không cần truyền qua build()
class ProductCard extends ConsumerStatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Trong ConsumerState, ref có sẵn để sử dụng
    // Ví dụ: final someData = ref.watch(someProvider);

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hình ảnh sản phẩm
          Container(
            height: 700,
            width: double.infinity,
            child: Image.asset(
              widget.product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên và nút favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // ID sản phẩm
                Text(
                  "Mã SP: ${widget.product.id}",
                  style: TextStyle(color: Colors.grey[600]),
                ),

                const SizedBox(height: 8),

                // Mô tả
                Text(
                  widget.product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Giá và số lượng
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_formatPrice(widget.product.price)} VNĐ",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "Còn ${widget.product.quantity} sản phẩm",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Format giá tiền với dấu phẩy ngăn cách hàng nghìn
  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},');
  }
}
