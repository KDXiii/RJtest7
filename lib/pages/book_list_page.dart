import 'package:flutter/material.dart';

import '../data/books.dart';
import 'book_detail_page.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  static const String routeName = '/list';

  /// 借阅次数达到该值视为高借阅量。
  static const int highBorrowThreshold = 50;

  Future<void> _showFilterSheet(BuildContext context, String category) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  '筛选',
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('仅看高借阅量'),
                subtitle: Text('借阅次数 ≥ $highBorrowThreshold'),
                onTap: () => Navigator.pop(sheetContext, '仅看高借阅量'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (choice == null || !context.mounted) {
      return;
    }
    // 把选择结果回传给首页。
    Navigator.pop(context, '$category · $choice');
  }

  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as String;
    final items = books.where((book) => book.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final book = items[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(book.month.replaceAll('月', '')),
            ),
            title: Text(book.title),
            subtitle: Text('${book.author} · ${book.category}'),
            trailing: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .end,
              children: [
                Row(
                  mainAxisSize: .min,
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < book.rating ? Icons.star : Icons.star_border,
                      size: 14,
                      color: Colors.amber,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '借阅 ${book.borrowCount}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            onTap: () => Navigator.pushNamed(
              context,
              BookDetailPage.routeName,
              arguments: book,
            ),
            onLongPress: () => _showFilterSheet(context, category),
          );
        },
      ),
    );
  }
}
