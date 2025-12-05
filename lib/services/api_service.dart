import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:myecommerce/modal/productModel.dart'; // Make sure this path is correct

class ApiService {
  // Platzi API Base URL
  static const String baseUrl = "https://api.escuelajs.co/api/v1";

  // Static variable to store token after login
  static String? currentToken;

  // 1. Badhi Products Lavo
  static Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      log("Error fetching products: $e");
      return [];
    }
  }

  // 2. Specific Category ni Products Lavo
  static Future<List<Product>> getProductsByCategory(String categoryName) async {
    try {
      final allProducts = await getAllProducts();
      // Filter locally because Platzi uses IDs for category endpoints usually
      return allProducts.where((p) => p.category.toLowerCase() == categoryName.toLowerCase()).toList();
    } catch (e) {
      throw Exception('Failed to load category products');
    }
  }

  // 3. Badhi Categories Lavo
  static Future<List<dynamic>> getAllCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // Top 5 categories return kariye design mate
        return data.take(5).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // 4. Product by ID
  static Future<Product> getProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  // 5. Login User (Updated to save Token)
  static Future<String> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        currentToken = data['access_token']; // <--- Token save karyo
        log("Login Success! Token: $currentToken");
        return currentToken!;
      } else {
        log("Login Error: ${response.body}");
        throw Exception('Invalid email or password');
      }
    } catch (e) {
      log("Login Exception: $e");
      throw e;
    }
  }

  // 6. Register User
  static Future<bool> registerUser(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/'), // Correct endpoint
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": name,
          "email": email,
          "password": password,
          "avatar": "https://i.imgur.com/LDOO4Qs.jpg" // Platzi needs avatar
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        log("Registration Error: ${response.body}");
        throw Exception('Failed to create account');
      }
    } catch (e) {
      log("Register Exception: $e");
      throw e;
    }
  }

  // 7. Get User Profile (New Function)
  static Future<Map<String, dynamic>> getProfile() async {
    // Check if user is logged in
    if (currentToken == null) {
      throw Exception("User not logged in");
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: {
          'Authorization': 'Bearer $currentToken', // <--- Token Header ma moklyo
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  // 8. Create New Product
  static Future<bool> createProduct({
    required String title,
    required double price,
    required String description,
    required int categoryId,
    required List<String> images,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "title": title,
          "price": price,
          "description": description,
          "categoryId": categoryId,
          "images": images
        }),
      );

      if (response.statusCode == 201) { // 201 Created
        return true;
      } else {
        log("Create Product Error: ${response.body}");
        throw Exception('Failed to create product');
      }
    } catch (e) {
      log("Create Product Exception: $e");
      throw e;
    }
  }
}