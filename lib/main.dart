import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/module/product/view model/product_vm.dart';
import 'app/module/product/view/productDetail_view.dart';
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
        onGenerateRoute: (settings) {
          if (settings.name == '/product-detail') {
            final productId = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => ProductDetailViewModel(),
                child: ProductDetailView(productId: productId),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}