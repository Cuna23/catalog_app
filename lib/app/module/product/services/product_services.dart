import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product_model.dart';

class ProductService {
  static const String baseUrl = 'https://dummyjson.com';

  Future<ProductListResponse> getProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    final url = Uri.parse('$baseUrl/products?limit=$limit&skip=$skip');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ProductListResponse.fromJson(data);
    } else {
      throw Exception('Failed to load products (status ${response.statusCode})');
    }
  }

  Future<Product> getProductDetail(int id) async {
    final url = Uri.parse('$baseUrl/products/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product detail (status ${response.statusCode})');
    }
  }

  Future<ProductListResponse> searchProducts(String query) async {
    final url = Uri.parse('$baseUrl/products/search?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ProductListResponse.fromJson(data);
    } else {
      throw Exception('Failed to search products (status ${response.statusCode})');
    }
  }

  /// GET /products/categories — returns slug + name pairs for the filter list.
  Future<List<Category>> getCategories() async {
    final url = Uri.parse('$baseUrl/products/categories');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories (status ${response.statusCode})');
    }
  }

  /// GET /products/category/{slug}?limit=&skip=
  /// This endpoint supports the same pagination params as the main list,
  /// so category filtering stays server-side and paginated — not just
  /// filtering whatever happens to already be loaded on screen.
  Future<ProductListResponse> getProductsByCategory(
    String slug, {
    int limit = 20,
    int skip = 0,
  }) async {
    final url = Uri.parse('$baseUrl/products/category/$slug?limit=$limit&skip=$skip');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return ProductListResponse.fromJson(data);
    } else {
      throw Exception('Failed to load category products (status ${response.statusCode})');
    }
  }
}