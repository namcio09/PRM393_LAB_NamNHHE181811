import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_work_4_2/pages/ProductListPage.dart';

/// QUAN TRỌNG: ProviderScope phải bọc toàn bộ app
///
/// ProviderScope là nơi lưu trữ state của tất cả các Provider.
/// Không có ProviderScope, các Provider sẽ không hoạt động.
void main() {
  runApp(
    const ProviderScope(  // <-- Bọc app với ProviderScope
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const ProductListPage(),
    );
  }
}
