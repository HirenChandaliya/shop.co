import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:myecommerce/modal/productModel.dart';

class ApiService {
  static const String baseUrl = "https://fakestoreapi.com";

  // 1. Badhi Products Lavo
  static Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // 2. Specific Category ni Products Lavo
  static Future<List<Product>> getProductsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/category/$category'),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load category products');
    }
  }

  // 3. Badhi Categories Lavo
  static Future<List<String>> getAllCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/products/categories'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  static Future<List<dynamic>> getUserCart() async {
    final response = await http.get(Uri.parse('$baseUrl/carts/user/1'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // FakeStore API user ni badhi carts return kare che, aapne sauthi latest levani
      if (data.isNotEmpty) {
        return data[0]['products']; // Return only products list
      }
      return [];
    } else {
      throw Exception('Failed to load cart');
    }
  }

  // 5. Product by ID Lavo (Cart items ni details mate)
  static Future<Product> getProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  // 6. Add to Cart (POST Request)
  static Future<Map<String, dynamic>> addToCart(int userId, int productId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/carts'),
      body: json.encode({
        'userId': userId,
        'date': DateTime.now().toString(),
        'products': [
          {'productId': productId, 'quantity': quantity}
        ]
      }),
      headers: {'Content-Type': 'application/json'}, // Header zaruri chhe
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add to cart');
    }
  }
  static Future<Map<String, dynamic>> deleteCartItem(int cartId) async {
    final response = await http.delete(Uri.parse('$baseUrl/carts/$cartId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete cart item');
    }
  }
  static Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: json.encode({
        'username': username,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'];
    } else {
      log("error ave ceh ");
      throw Exception('Invalid username or password');
    }
  }
}
