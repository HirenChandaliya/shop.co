class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'],
    );
  }
}

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image; // Main thumbnail for Grid
  final List<String> images; // <--- NEW: List for Detail Page Gallery
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.images, // <--- Add to constructor
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // --- 1. HANDLE IMAGES LIST ---
    List<String> parsedImages = [];

    if (json['images'] != null) {
      // Platzi API returns raw strings sometimes with brackets like '["url"]'
      // We need to clean each URL in the list
      for (var img in json['images']) {
        String cleanImg = img.toString();
        // Remove [" and "] and " characters
        cleanImg = cleanImg.replaceAll('["', '').replaceAll('"]', '').replaceAll('"', '').replaceAll('[', '').replaceAll(']', '');

        if (cleanImg.startsWith('http')) {
          parsedImages.add(cleanImg);
        }
      }
    }

    // Fallback: If list is empty, put a placeholder
    if (parsedImages.isEmpty) {
      parsedImages.add("https://i.imgur.com/4y9g3K8.png");
    }

    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      // Platzi returns category as object, ensure we handle it or string
      category: json['category'] is Map ? json['category']['name'] : (json['category'] ?? 'General'),
      // Use the first image from the list as the main image
      image: parsedImages.isNotEmpty ? parsedImages[0] : "",
      images: parsedImages, // <--- Assign the list
      rating: Rating(rate: 4.5, count: 100), // Dummy rating for Platzi
    );
  }
}