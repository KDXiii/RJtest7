/// 商品数据模型
class Product {
  const Product({required this.id, required this.name, required this.price});

  final int id;
  final String name;
  final double price;
}

/// 模拟后端接口：分页返回商品数据
class MockApi {
  static const int pageSize = 20;
  static const int totalCount = 57; // 模拟服务器总数据量

  static Future<List<Product>> fetchProducts(int page) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(milliseconds: 800));

    final start = page * pageSize;
    if (start >= totalCount) return <Product>[];

    final end = (start + pageSize).clamp(0, totalCount);
    return List.generate(
      end - start,
      (i) => Product(
        id: start + i + 1,
        name: '商品 ${start + i + 1}',
        price: 9.9 + (start + i) % 100,
      ),
    );
  }
}
