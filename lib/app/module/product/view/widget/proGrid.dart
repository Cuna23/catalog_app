import 'package:flutter/material.dart';
import '../../model/product_model.dart';
import 'proCard.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const ProductGrid({
    super.key,
    required this.products,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Trigger loadMore when the user is close to the bottom.
    const threshold = 200;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - threshold) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: widget.products.length + (widget.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= widget.products.length) {
          // Small spinner at the bottom while the next page loads.
          return const Center(child: CircularProgressIndicator());
        }

        final product = widget.products[index];
        return ProductCard(
          product: product,
          onTap: () {
            Navigator.pushNamed(
              context,
              '/product-detail',
              arguments: product.id,
            );
          },
        );
      },
    );
  }
}