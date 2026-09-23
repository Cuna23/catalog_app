import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/module/product/view model/product_vm.dart';
import 'app/module/product/view/product_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductListViewModel(),
      child: MaterialApp(
        title: 'Product Catalog',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ProductView(),
        // The '/product-detail' route (used by ProductGrid when a card is
        // tapped) will be added here once ProductDetailView is built.
      ),
    );
  }
}