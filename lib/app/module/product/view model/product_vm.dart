import 'package:flutter/foundation.dart';
import '../model/product_model.dart';
import '../services/product_services.dart';

class ProductListViewModel extends ChangeNotifier {
  final ProductService _service = ProductService();

  static const int _pageSize = 20;

  List<Product> products = [];
  List<String> categories = ['All'];
  String selectedCategory = 'All';
  String searchQuery = '';

  bool isLoading = false;     // true only for the very first load
  bool isLoadingMore = false; // true while fetching the next page
  String? error;

  int _skip = 0;
  int _total = 0;

  bool get _hasMore => products.length < _total;

  /// Initial fetch — called once when the screen first opens.
  Future<void> fetchProducts() async {
    isLoading = true;
    error = null;
    _skip = 0;
    notifyListeners();

    try {
      final result = await _service.getProducts(limit: _pageSize, skip: _skip);
      products = result.products;
      _total = result.total;
      _skip = result.skip + result.products.length;
      error = null;
    } catch (e) {
      error = 'Failed to load products. Please check your connection.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Called when the user scrolls near the bottom of the list.
  Future<void> loadMore() async {
    if (isLoadingMore || isLoading || !_hasMore) return;

    isLoadingMore = true;
    notifyListeners();

    try {
      final result = await _service.getProducts(limit: _pageSize, skip: _skip);
      products = [...products, ...result.products];
      _total = result.total;
      _skip = result.skip + result.products.length;
    } catch (e) {
      // Keep existing products visible; just stop the "loading more" spinner.
      // A snackbar could be shown here instead of a full error state.
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Called by the retry button in the error state.
  Future<void> retry() => fetchProducts();

  /// Called (after debounce) whenever the search text changes.
  Future<void> onSearchChanged(String query) async {
    searchQuery = query;

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
      _total = result.total;
      _skip = result.products.length;
      error = null;
    } catch (e) {
      error = 'Search failed. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Called when the user picks a category chip.
  void onCategorySelected(String category) {
    selectedCategory = category;
    // Category filtering is applied client-side on the currently
    // loaded products — see README for why this approach was chosen.
    notifyListeners();
  }
}