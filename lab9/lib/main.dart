import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Lab9App());
}

class Lab9App extends StatelessWidget {
  const Lab9App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 – Local JSON',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F8A70)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F6),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _pages = const [
    AssetCatalogView(),
    ScratchpadStorageView(),
    MiniDatabaseView(),
  ];

  final _titles = const [
    'Lab 9.1 • Asset Catalog',
    'Lab 9.2 • Scratchpad Storage',
    'Lab 9.3 • Local Mini Database',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_index]),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: KeyedSubtree(
          key: ValueKey('page-$_index'),
          child: _pages[_index],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Assets',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloud_sync_outlined),
            selectedIcon: Icon(Icons.cloud_sync),
            label: 'Storage',
          ),
          NavigationDestination(
            icon: Icon(Icons.storage_outlined),
            selectedIcon: Icon(Icons.storage),
            label: 'Mini DB',
          ),
        ],
        onDestinationSelected: (value) => setState(() => _index = value),
      ),
    );
  }
}

class AssetCatalogView extends StatefulWidget {
  const AssetCatalogView({super.key});

  @override
  State<AssetCatalogView> createState() => _AssetCatalogViewState();
}

class _AssetCatalogViewState extends State<AssetCatalogView> {
  List<Map<String, dynamic>> _books = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final raw = await rootBundle.loadString('assets/data/books.json');
      final decoded = jsonDecode(raw) as List<dynamic>;
      _books = decoded
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    } catch (err) {
      _error = 'Không thể đọc assets: $err';
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _loadBooks, child: const Text('Thử lại')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadBooks,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _books.length,
        itemBuilder: (context, index) {
          final book = _books[index];
          final minutes = book['minutesToRead'] ?? 0;
          final author = book['author'] ?? 'Unknown';
          final category = book['category'] ?? 'General';
          return Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                child: Text('${minutes}m'),
              ),
              title: Text(book['title'] ?? 'Untitled'),
              subtitle: Text('$author • $category'),
            ),
          );
        },
      ),
    );
  }
}

class LocalJsonStore {
  LocalJsonStore(this.filename);

  final String filename;

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode([]));
    }
    return file;
  }

  Future<List<dynamic>> read() async {
    final file = await _file();
    final content = await file.readAsString();
    if (content.trim().isEmpty) {
      return [];
    }
    try {
      final decoded = jsonDecode(content);
      if (decoded is List) {
        return decoded;
      }
    } catch (_) {
      await file.writeAsString(jsonEncode([]));
    }
    return [];
  }

  Future<void> write(List<dynamic> data) async {
    final file = await _file();
    final encoded = jsonEncode(data);
    await file.writeAsString(encoded, flush: true);
  }
}

class ScratchpadStorageView extends StatefulWidget {
  const ScratchpadStorageView({super.key});

  @override
  State<ScratchpadStorageView> createState() => _ScratchpadStorageViewState();
}

class _ScratchpadStorageViewState extends State<ScratchpadStorageView> {
  final LocalJsonStore _store = LocalJsonStore('lab9_notes.json');
  final TextEditingController _controller = TextEditingController();

  List<String> _notes = [];
  bool _loading = true;
  bool _saving = false;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final data = await _store.read();
    setState(() {
      _notes = data.map((e) => e.toString()).toList();
      _loading = false;
      _dirty = false;
    });
  }

  void _addNote() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _notes.insert(0, text);
      _controller.clear();
      _dirty = true;
    });
  }

  Future<void> _save() async {
    if (_saving || !_dirty) return;
    setState(() => _saving = true);
    await _store.write(_notes);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _dirty = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Scratchpad saved locally.')));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'New idea',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _addNote,
              ),
            ),
            onSubmitted: (_) => _addNote(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              FilledButton.icon(
                onPressed: _dirty ? _save : null,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_alt),
                label: Text(_dirty ? 'Save notes' : 'Saved'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh),
                label: const Text('Reload file'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _notes.isEmpty
                ? const Center(child: Text('No notes yet. Add something above.'))
                : ListView.separated(
                    itemCount: _notes.length,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.push_pin_outlined),
                          title: Text(_notes[index]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class InventoryItem {
  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.notes,
  });

  final String id;
  final String name;
  final String category;
  final int quantity;
  final String notes;

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'quantity': quantity,
        'notes': notes,
      };
}

class MiniDatabaseView extends StatefulWidget {
  const MiniDatabaseView({super.key});

  @override
  State<MiniDatabaseView> createState() => _MiniDatabaseViewState();
}

class _MiniDatabaseViewState extends State<MiniDatabaseView> {
  final LocalJsonStore _store = LocalJsonStore('lab9_inventory.json');
  final TextEditingController _searchCtrl = TextEditingController();

  List<InventoryItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final raw = await _store.read();
    setState(() {
      _items = raw
          .map((e) => InventoryItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      _loading = false;
    });
  }

  Future<void> _persist() async {
    await _store.write(_items.map((e) => e.toJson()).toList());
  }

  Future<void> _deleteItem(InventoryItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('Remove "${item.name}" from storage?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _items.removeWhere((element) => element.id == item.id));
    await _persist();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${item.name} deleted.')));
  }

  Future<void> _openEditor({InventoryItem? existing}) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final categoryCtrl = TextEditingController(text: existing?.category ?? 'General');
    final quantityCtrl = TextEditingController(
      text: existing != null ? existing.quantity.toString() : '1',
    );
    final notesCtrl = TextEditingController(text: existing?.notes ?? '');
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<InventoryItem>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existing == null ? 'Add item' : 'Edit item'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter a name'
                        : null,
                  ),
                  TextFormField(
                    controller: categoryCtrl,
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                  TextFormField(
                    controller: quantityCtrl,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter quantity';
                      return int.tryParse(value) == null ? 'Invalid number' : null;
                    },
                  ),
                  TextFormField(
                    controller: notesCtrl,
                    decoration: const InputDecoration(labelText: 'Notes'),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                final item = InventoryItem(
                  id: existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameCtrl.text.trim(),
                  category: categoryCtrl.text.trim().isEmpty ? 'General' : categoryCtrl.text.trim(),
                  quantity: int.parse(quantityCtrl.text.trim()),
                  notes: notesCtrl.text.trim(),
                );
                Navigator.pop(context, item);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    nameCtrl.dispose();
    categoryCtrl.dispose();
    quantityCtrl.dispose();
    notesCtrl.dispose();

    if (result == null) return;

    setState(() {
      final index = _items.indexWhere((item) => item.id == result.id);
      if (index == -1) {
        _items.insert(0, result);
      } else {
        _items[index] = result;
      }
    });
    await _persist();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(existing == null ? 'Item added.' : 'Item updated.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final query = _searchCtrl.text.toLowerCase();
    final filtered = query.isEmpty
        ? _items
        : _items
            .where((item) =>
                item.name.toLowerCase().contains(query) ||
                item.category.toLowerCase().contains(query) ||
                item.notes.toLowerCase().contains(query))
            .toList();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: Column(
            children: [
              TextField(
                controller: _searchCtrl,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Search inventory',
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('No items match. Add a new entry with the + button.'),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return Card(
                            child: ListTile(
                              title: Text(item.name),
                              subtitle: Text('${item.category} • Qty ${item.quantity}\n${item.notes}'),
                              isThreeLine: true,
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _openEditor(existing: item);
                                  } else if (value == 'delete') {
                                    _deleteItem(item);
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 24,
          bottom: 24,
          child: FloatingActionButton.extended(
            onPressed: () => _openEditor(),
            icon: const Icon(Icons.add),
            label: const Text('Add item'),
          ),
        ),
      ],
    );
  }
}
