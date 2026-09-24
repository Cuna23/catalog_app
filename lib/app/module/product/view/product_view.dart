import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/product_model.dart';
import '../view model/product_vm.dart';
import 'widget/proGrid.dart';
import 'widget/searchBar.dart';
import 'widget/state.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductListViewModel>().init();
    });
  }

  void _openFilterSheet(BuildContext context, ProductListViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        // isScrollControlled + a fractional height lets this sheet scroll
        // when there are many categories, instead of overflowing.
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Filter by category', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: viewModel.categories.isEmpty
                      ? const Center(child: Text('No categories available'))
                      : ListView.builder(
                          itemCount: viewModel.categories.length,
                          itemBuilder: (context, index) {
                            final category = viewModel.categories[index];
                            final isSelected = category.slug == viewModel.selectedCategorySlug;
                            return ListTile(
                              title: Text(category.name),
                              trailing: isSelected ? const Icon(Icons.check) : null,
                              onTap: () {
                                viewModel.onCategorySelected(category.slug);
                                Navigator.pop(sheetContext);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Catalog')),
      body: Consumer<ProductListViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              SearchBarWidget(
                onChanged: viewModel.onSearchChanged,
                onFilterTap: () => _openFilterSheet(context, viewModel),
              ),
              if (viewModel.selectedCategorySlug != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Chip(
                        label: Text(
                          viewModel.categories
                              .firstWhere(
                                (c) => c.slug == viewModel.selectedCategorySlug,
                                orElse: () => Category(slug: '', name: viewModel.selectedCategorySlug!),
                              )
                              .name,
                        ),
                        onDeleted: () {
                          viewModel.selectedCategorySlug = null;
                          viewModel.currentPage = 1;
                          viewModel.fetchProducts();
                        },
                      ),
                    ],
                  ),
                ),
              Expanded(child: _buildBody(viewModel)),
              if (!viewModel.isLoading && viewModel.error == null && viewModel.products.isNotEmpty)
                _buildPaginationBar(viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(ProductListViewModel viewModel) {
    if (viewModel.isLoading) {
      return const LoadingStateWidget();
    }

    if (viewModel.error != null) {
      return ErrorStateWidget(onRetry: viewModel.retry);
    }

    if (viewModel.products.isEmpty) {
      return const EmptyStateWidget();
    }

    return SingleChildScrollView(
      child: ProductGrid(products: viewModel.products),
    );
  }

  Widget _buildPaginationBar(ProductListViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: viewModel.hasPreviousPage ? viewModel.previousPage : null,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(viewModel.rangeLabel),
          IconButton(
            onPressed: viewModel.hasNextPage ? viewModel.nextPage : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}