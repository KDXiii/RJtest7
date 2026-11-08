import 'package:flutter/material.dart';

import '../data/books.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Text('图书列表 Demo', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              Text('内置图书 ${books.length} 条，列表页展示前 20 条。'),
            ],
          ),
        ),
      ),
    );
  }
}
