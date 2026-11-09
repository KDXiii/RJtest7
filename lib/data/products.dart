/// 商品数据模型
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });

  final int id;
  final String name;
  final double price;
  final String category;
}

/// 模拟后端接口：按分类分页返回商品数据
class MockApi {
  static const int pageSize = 20;

  /// 商品分类入口
  static const List<String> categories = ['数码配件', '家居日用', '图书文具'];

  /// 每个分类的模拟数据量
  static const int totalCountPerCategory = 57;

  static Future<List<Product>> fetchProducts(int page, String category) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));

    final start = page * pageSize;
    if (start >= totalCountPerCategory) return <Product>[];

    final end = (start + pageSize).clamp(0, totalCountPerCategory);
    // 不同分类用不同的 id 段，方便肉眼区分
    final baseId = categories.indexOf(category) * 100;

    return List.generate(end - start, (i) {
      final index = start + i;
      return Product(
        id: baseId + index + 1,
        name: '$category商品 ${index + 1}',
        price: 9.9 + index % 100,
        category: category,
      );
    });
  }
}
