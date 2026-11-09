import 'package:flutter/material.dart';

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

/// 列表分页模拟（ListView.builder + 上拉加载）
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  static const String routeName = '/products';

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<Product> _products = [];
  final ScrollController _scrollController = ScrollController();

  int _page = 0;
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMore();
    // 监听滚动，接近底部时触发上拉加载
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    final newItems = await MockApi.fetchProducts(_page);
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (newItems.length < MockApi.pageSize) {
        _hasMore = false; // 返回不足一页，说明没有更多数据了
      }
      _products.addAll(newItems);
      _page++;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _products.clear();
      _page = 0;
      _hasMore = true;
    });
    await _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('商品列表（分页模拟）'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _products.length + 1, // 最后一项是加载状态栏
          itemBuilder: (context, index) {
            if (index == _products.length) {
              return _buildFooter();
            }
            final product = _products[index];
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
              ),
            );
          },
        ),
      ),
    );
  }

  /// 底部加载状态：加载中 / 没有更多
  Widget _buildFooter() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('正在加载...'),
            ],
          ),
        ),
      );
    }
    if (!_hasMore) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text('— 已经到底啦 —', style: TextStyle(color: Colors.grey)),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
