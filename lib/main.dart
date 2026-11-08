import 'package:flutter/material.dart';

import 'pages/about_page.dart';
import 'pages/book_detail_page.dart';
import 'pages/book_list_page.dart';

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
      initialRoute: BookListPage.routeName,
      routes: {
        BookListPage.routeName: (context) => const BookListPage(),
        BookDetailPage.routeName: (context) => const BookDetailPage(),
        AboutPage.routeName: (context) => const AboutPage(),
      },
    );
  }
}
