import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/product_model.dart';

class ProductService {
  static const String baseUrl = 'https://dummyjson.com';

  /// GET /products?limit=20&skip=0
  /// Used for the main list screen with pagination.
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

  /// GET /products/{id}
  /// Used for the detail screen.
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

  /// GET /products/search?q=keyword
  /// Used for the search bar.
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
}