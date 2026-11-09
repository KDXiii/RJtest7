import 'package:flutter/material.dart';

import '../data/products.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

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

  /// 详情页返回时携带的结果
  String? _lastActionResult;

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('商品列表（分页模拟）'),
            Text(
              _lastActionResult ?? '点击商品查看详情',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
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
            return ProductCard(
              product: product,
              onTap: () => _openDetail(product),
            );
          },
        ),
      ),
    );
  }

  /// 进入详情页，并接收详情页回传的结果
  Future<void> _openDetail(Product product) async {
    final result = await Navigator.pushNamed(
      context,
      ProductDetailPage.routeName,
      arguments: product,
    );
    if (result is String && mounted) {
      setState(() => _lastActionResult = result);
    }
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
