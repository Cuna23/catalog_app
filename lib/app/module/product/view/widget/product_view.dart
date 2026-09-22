import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import '../../view model/product_vm.dart';
// import 'widget/search_bar_widget.dart';
// import 'widget/filter_chip_bar.dart';
// import 'widget/product_grid.dart';
// import 'widget/loading_state_widget.dart';
// import 'widget/error_state_widget.dart';
// import 'widget/empty_state_widget.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  void initState() {
    super.initState();
    // Trigger the initial fetch once when the screen first loads.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductListViewModel>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Catalog')),
      body: Consumer<ProductListViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              // Top: search field + filter button
              SearchBarWidget(
                onChanged: viewModel.onSearchChanged,
                onFilterTap: () {
                  // Opens category filter — wired once FilterChipBar is ready.
                },
              ),

              // Category filter chips (Product / Category attribute)
              FilterChipBar(
                categories: viewModel.categories,
                selectedCategory: viewModel.selectedCategory,
                onSelect: viewModel.onCategorySelected,
              ),

              // Bottom: the actual product list — this is where
              // loading / error / empty / success states are decided.
              Expanded(
                child: _buildBody(viewModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(ProductListViewModel viewModel) {
    if (viewModel.isLoading && viewModel.products.isEmpty) {
      return const LoadingStateWidget();
    }

    if (viewModel.error != null && viewModel.products.isEmpty) {
      return ErrorStateWidget(onRetry: viewModel.retry);
    }

    if (viewModel.products.isEmpty) {
      return const EmptyStateWidget();
    }

    return ProductGrid(
      products: viewModel.products,
      isLoadingMore: viewModel.isLoadingMore,
      onLoadMore: viewModel.loadMore,
    );
  }
}