import 'package:flutter/material.dart';

import 'data/products.dart';
import 'pages/book_detail_page.dart';
import 'pages/book_list_page.dart';
import 'pages/home_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/product_home_page.dart';
import 'pages/product_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '图书分类',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        BookListPage.routeName: (context) => const BookListPage(),
        BookDetailPage.routeName: (context) => const BookDetailPage(),
        ProductHomePage.routeName: (context) => const ProductHomePage(),
        ProductListPage.routeName: (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments;
          return ProductListPage(
            category: arguments is String
                ? arguments
                : MockApi.categories.first,
          );
        },
        ProductDetailPage.routeName: (context) => const ProductDetailPage(),
      },
    );
  }
}
