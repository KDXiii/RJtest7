import 'package:flutter/material.dart';

import '../data/products.dart';

/// 商品详情页
///
/// 通过命名路由进入，参数由路由 arguments 传入；
/// 返回时用 Navigator.pop 携带结果，回传给商品列表页。
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  static const String routeName = '/product_detail';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final product = arguments is Product ? arguments : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('商品详情'),
      ),
      body: product == null
          ? const Center(child: Text('缺少商品参数'))
          : _ProductDetailBody(product: product),
    );
  }
}

class _ProductDetailBody extends StatelessWidget {
  const _ProductDetailBody({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CircleAvatar(radius: 36, child: Text('${product.id}')),
        const SizedBox(height: 16),
        Text(
          product.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          '¥${product.price.toStringAsFixed(1)}',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(height: 40),
        _InfoRow(label: '商品编号', value: '${product.id}'),
        const SizedBox(height: 12),
        _InfoRow(label: '商品描述', value: '这是 ${product.name} 的描述信息'),
        const SizedBox(height: 32),
        FilledButton.icon(
          onPressed: () => Navigator.pop(context, '已收藏：${product.name}'),
          icon: const Icon(Icons.favorite_border),
          label: const Text('收藏并返回列表'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('直接返回'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}
