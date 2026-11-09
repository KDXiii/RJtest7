import 'package:flutter/material.dart';

import '../data/books.dart';
import 'book_list_page.dart';
import 'product_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// 最近一次从列表页回传的选择结果，显示在 AppBar 副标题。
  String? _lastChoice;

  static const Map<String, IconData> _categoryIcons = {
    '计算机技术': Icons.computer,
    '经济管理': Icons.trending_up,
    '科普百科': Icons.science,
    '文学小说': Icons.menu_book,
    '艺术设计': Icons.palette,
    '历史哲学': Icons.history_edu,
  };

  Future<void> _openCategory(String category) async {
    final result = await Navigator.pushNamed(
      context,
      BookListPage.routeName,
      arguments: category,
    );
    if (result is String && mounted) {
      setState(() => _lastChoice = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = <String, int>{};
    for (final book in books) {
      categories.update(book.category, (count) => count + 1, ifAbsent: () => 1);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            const Text('图书分类'),
            Text(
              _lastChoice ?? '请选择分类',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: '商品列表',
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, ProductHomePage.routeName),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final entry = categories.entries.elementAt(index);
          return _CategoryCard(
            category: entry.key,
            count: entry.value,
            icon: _categoryIcons[entry.key] ?? Icons.category,
            onTap: () => _openCategory(entry.key),
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.count,
    required this.icon,
    required this.onTap,
  });

  final String category;
  final int count;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(icon, size: 28, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(category, style: theme.textTheme.titleMedium),
              Text('$count 本', style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
