import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view model/product_vm.dart';
import 'widget/state.dart';

class ProductDetailView extends StatefulWidget {
  final int productId;

  const ProductDetailView({super.key, required this.productId});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductDetailViewModel>().fetchProductDetail(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: Consumer<ProductDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) return const LoadingStateWidget();
          if (viewModel.error != null) {
            return ErrorStateWidget(onRetry: () => viewModel.retry(widget.productId));
          }

          final product = viewModel.product;
          if (product == null) return const EmptyStateWidget();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: product.images.isNotEmpty ? product.images.length : 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final imageUrl =
                          product.images.isNotEmpty ? product.images[index] : product.thumbnail;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          width: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image_outlined, size: 48),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
                Text(product.brand, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text('${product.rating}'),
                    const SizedBox(width: 16),
                    Text('Stock: ${product.stock}'),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (product.discountPercentage > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        '-${product.discountPercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                Text(product.description, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 16),

                if (product.tags.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    children: product.tags.map((t) => Chip(label: Text(t))).toList(),
                  ),
                const SizedBox(height: 16),

                const Divider(),
                _InfoRow(label: 'SKU', value: product.sku),
                _InfoRow(label: 'Availability', value: product.availabilityStatus),
                _InfoRow(label: 'Minimum order', value: '${product.minimumOrderQuantity} unit(s)'),
                _InfoRow(label: 'Warranty', value: product.warrantyInformation),
                _InfoRow(label: 'Shipping', value: product.shippingInformation),
                _InfoRow(label: 'Return policy', value: product.returnPolicy),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}