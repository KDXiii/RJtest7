import 'package:flutter/material.dart';

import '../data/products.dart';
import 'product_list_page.dart';

/// 商品分类首页
///
/// 列表页返回时会把“详情页回传的结果”继续带回本页，显示在副标题里。
class ProductHomePage extends StatefulWidget {
  const ProductHomePage({super.key});

  static const String routeName = '/product_home';

  @override
  State<ProductHomePage> createState() => _ProductHomePageState();
}

class _ProductHomePageState extends State<ProductHomePage> {
  /// 列表页带回的结果
  String? _lastResult;

  static const Map<String, IconData> _categoryIcons = {
    '数码配件': Icons.headphones,
    '家居日用': Icons.chair,
    '图书文具': Icons.menu_book,
  };

  Future<void> _openCategory(String category) async {
    final result = await Navigator.pushNamed(
      context,
      ProductListPage.routeName,
      arguments: category,
    );
    if (result is String && mounted) {
      setState(() => _lastResult = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('商品分类'),
            Text(
              _lastResult ?? '请选择商品分类',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
        ),
        itemCount: MockApi.categories.length,
        itemBuilder: (context, index) {
          final category = MockApi.categories[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _openCategory(category),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _categoryIcons[category] ?? Icons.category,
                    size: 28,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(category, style: theme.textTheme.titleMedium),
                  Text('查看商品列表', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
