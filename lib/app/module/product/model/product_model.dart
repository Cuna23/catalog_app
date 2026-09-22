class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double rating;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      thumbnail: json['thumbnail'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

/// Wraps the list-style responses from /products, /products/search,
/// and /products/category/{name} — they all share this shape:
/// { "products": [...], "total": n, "skip": n, "limit": n }
class ProductListResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  ProductListResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      skip: json['skip'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
    );
  }
}