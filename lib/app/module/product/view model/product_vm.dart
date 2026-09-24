import 'package:flutter/foundation.dart' hide Category;
import '../model/product_model.dart';
import '../services/product_services.dart';

class ProductListViewModel extends ChangeNotifier {
  final ProductService _service = ProductService();

  static const int pageSize = 20;

  List<Product> products = [];
  List<Category> categories = [];

  /// null = no category filter applied (showing the general product list)
  String? selectedCategorySlug;

  String searchQuery = '';

  bool isLoading = false;
  String? error;

  int currentPage = 1; // 1-based, for display ("Page 1 of 10")
  int total = 0;

  int get _skip => (currentPage - 1) * pageSize;

  int get totalPages => total == 0 ? 1 : (total / pageSize).ceil();
  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;

  /// e.g. "1-20 of 194"
  String get rangeLabel {
    if (total == 0) return '0 of 0';
    final start = _skip + 1;
    final end = (_skip + products.length).clamp(0, total);
    return '$start-$end of $total';
  }

  Future<void> init() async {
    await fetchCategories();
    await fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      categories = await _service.getCategories();
      notifyListeners();
    } catch (e) {
      // Non-fatal — filter list just stays empty if this fails.
    }
  }

  /// Loads the current page for the general (unfiltered) list.
  Future<void> fetchProducts() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await _service.getProducts(limit: pageSize, skip: _skip);
      products = result.products;
      total = result.total;
      error = null;
    } catch (e) {
      error = 'Failed to load products. Please check your connection.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Loads the current page for the selected category.
  Future<void> fetchByCategory() async {
    final slug = selectedCategorySlug;
    if (slug == null) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await _service.getProductsByCategory(slug, limit: pageSize, skip: _skip);
      products = result.products;
      total = result.total;
      error = null;
    } catch (e) {
      error = 'Failed to load this category. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _reload() {
    return selectedCategorySlug == null ? fetchProducts() : fetchByCategory();
  }

  Future<void> retry() => _reload();

  Future<void> nextPage() async {
    if (!hasNextPage) return;
    currentPage++;
    await _reload();
  }

  Future<void> previousPage() async {
    if (!hasPreviousPage) return;
    currentPage--;
    await _reload();
  }

  /// Called when the user picks a category from the filter sheet.
  Future<void> onCategorySelected(String slug) async {
    selectedCategorySlug = slug;
    currentPage = 1;
    searchQuery = '';
    await fetchByCategory();
  }

  Future<void> onSearchChanged(String query) async {
    searchQuery = query;
    selectedCategorySlug = null;
    currentPage = 1;

    if (query.isEmpty) {
      await fetchProducts();
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await _service.searchProducts(query);
      products = result.products;
      total = result.total;
      error = null;
    } catch (e) {
      error = 'Search failed. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class ProductDetailViewModel extends ChangeNotifier {
  final ProductService _service = ProductService();

  Product? product;
  bool isLoading = false;
  String? error;

  Future<void> fetchProductDetail(int id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      product = await _service.getProductDetail(id);
      error = null;
    } catch (e) {
      error = 'Failed to load product detail.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> retry(int id) => fetchProductDetail(id);
}