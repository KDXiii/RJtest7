import 'package:flutter/material.dart';

import 'data/books.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '图书列表',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const BookListPage(),
    );
  }
}

class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  /// 列表页只展示前 20 条模拟数据。
  static const int itemCount = 20;

  @override
  Widget build(BuildContext context) {
    final items = books.take(itemCount).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('图书列表'),
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
          );
        },
      ),
    );
  }
}
