import 'package:flutter/material.dart';

import '../data/products.dart';

/// 复用组件一：商品卡片
///
/// 参数化组件，列表页用它渲染每一行；商品数据与点击回调由外部传入。
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(child: Text('${product.id}')),
        title: Text(product.name),
        subtitle: Text('这是 ${product.name} 的描述信息'),
        trailing: Text(
          '¥${product.price.toStringAsFixed(1)}',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
