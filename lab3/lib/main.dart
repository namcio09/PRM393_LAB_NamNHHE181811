import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  final future = runExercises();
  runApp(LabApp(future: future));
}

class LabApp extends StatelessWidget {
  const LabApp({super.key, required this.future});

  final Future<List<LabResult>> future;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 3 – Advanced Dart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lab 3 – Advanced Dart'),
        ),
        body: FutureBuilder<List<LabResult>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final results = snapshot.data ?? [];
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        for (final line in result.details)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(line),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class LabResult {
  LabResult(this.title, this.details);

  final String title;
  final List<String> details;
}

Future<List<LabResult>> runExercises() async {
  final outputs = <LabResult>[];
  outputs.add(await exerciseOne());
  outputs.add(await exerciseTwo());
  outputs.add(await exerciseThree());
  outputs.add(await exerciseFour());
  outputs.add(await exerciseFive());
  return outputs;
}

class Product {
  Product({required this.id, required this.name, required this.price});

  final int id;
  final String name;
  final double price;

  @override
  String toString() => 'Product($id, $name, ${price.toStringAsFixed(2)})';
}

class ProductRepository {
  ProductRepository()
      : _items = [
          Product(id: 1, name: 'Monitor', price: 250.0),
          Product(id: 2, name: 'Keyboard', price: 90.0),
        ];

  final List<Product> _items;
  final StreamController<Product> _controller =
      StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List<Product>.unmodifiable(_items);
  }

  Stream<Product> liveAdded() => _controller.stream;

  void addProduct(Product product) {
    _items.add(product);
    _controller.add(product);
  }

  Future<void> dispose() => _controller.close();
}

Future<LabResult> exerciseOne() async {
  final repo = ProductRepository();
  final lines = <String>['Exercise 1 – Product Repository'];

  final products = await repo.getAll();
  for (final product in products) {
    final text = 'Existing: ${product.toString()}';
    lines.add(text);
    debugPrint(text);
  }

  final liveFuture = repo.liveAdded().take(2).toList();
  repo.addProduct(Product(id: 3, name: 'Mouse', price: 35));
  repo.addProduct(Product(id: 4, name: 'Desk Lamp', price: 48));
  final liveItems = await liveFuture;
  for (final product in liveItems) {
    final text = 'Live insert: ${product.name} at ${product.price}';
    lines.add(text);
    debugPrint(text);
  }

  await repo.dispose();
  return LabResult('Exercise 1 – Product Repository', lines);
}

class User {
  User({required this.name, required this.email});

  final String name;
  final String email;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name'] as String, email: json['email'] as String);
  }

  @override
  String toString() => '$name <$email>';
}

class UserRepository {
  Future<List<User>> fetchUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final payload = [
      {'name': 'Minh Chau', 'email': 'chau@example.com'},
      {'name': 'Quang Huy', 'email': 'huy@example.com'},
      {'name': 'Bao Tran', 'email': 'tran@example.com'},
    ];
    return payload.map(User.fromJson).toList();
  }
}

Future<LabResult> exerciseTwo() async {
  final repo = UserRepository();
  final users = await repo.fetchUsers();
  final lines = <String>['Exercise 2 – User Repository'];
  for (final user in users) {
    final text = 'Fetched: ${user.toString()}';
    lines.add(text);
    debugPrint(text);
  }
  return LabResult('Exercise 2 – User Repository', lines);
}

Future<LabResult> exerciseThree() async {
  final order = <String>[];
  final lines = <String>['Exercise 3 – Async vs Microtask'];

  void log(String text) {
    order.add(text);
    debugPrint(text);
  }

  log('Synchronous start');
  scheduleMicrotask(() => log('Microtask 1'));
  Future(() => log('Event queue 1'));
  scheduleMicrotask(() => log('Microtask 2'));
  Future(() => log('Event queue 2'));
  log('Synchronous end');

  await Future<void>.delayed(const Duration(milliseconds: 10));
  lines.addAll(order);
  lines.add('Observation: microtasks fire before event queue futures.');
  return LabResult('Exercise 3 – Async vs Microtask', lines);
}

Future<LabResult> exerciseFour() async {
  final lines = <String>['Exercise 4 – Stream Transformation'];
  final base =
      Stream<int>.fromIterable(List<int>.generate(5, (index) => index + 1));
  final transformed =
      base.map((value) => value * value).where((value) => value.isEven);

  await for (final value in transformed) {
    final text = 'Emitted square: $value';
    lines.add(text);
    debugPrint(text);
  }

  lines.add('Stream completed');
  return LabResult('Exercise 4 – Stream Transformation', lines);
}

class Settings {
  Settings._internal();

  static final Settings _instance = Settings._internal();

  factory Settings() => _instance;

  String mode = 'light';
}

Future<LabResult> exerciseFive() async {
  final lines = <String>['Exercise 5 – Factory Singleton'];
  final first = Settings();
  final second = Settings();
  first.mode = 'dark';
  final identicalResult = identical(first, second);
  final sharedMode = second.mode;
  final identityText = 'Same instance: $identicalResult';
  final modeText = 'Second reflects mode: $sharedMode';
  debugPrint(identityText);
  debugPrint(modeText);
  lines.add(identityText);
  lines.add(modeText);
  return LabResult('Exercise 5 – Factory Singleton', lines);
}
