import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecommerce/widgets/commonWidget.dart';

import '../modal/productModel.dart';
import '../services/cartServices.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  String _selectedSize = "Large";
  Color _selectedColor = const Color(0xFF4F4631); // Default Olive color
  int _selectedImageIndex = 0;
  late TabController _tabController;

  // Sample colors (API ma nathi hotu etle static)
  final List<Color> _colors = [
    const Color(0xFF4F4631),
    const Color(0xFF314F4A),
    const Color(0xFF31344F),
  ];

  // Sample sizes
  final List<String> _sizes = ["Small", "Medium", "Large", "X-Large"];

  // Sample Reviews Data
  final List<Map<String, dynamic>> _reviews = [
    {
      "name": "Samantha D.",
      "rating": 4.5,
      "date": "August 14, 2023",
      "comment":
          "I absolutely love this t-shirt! The design is unique and the fabric feels so comfortable. As a fellow designer, I appreciate the attention to detail. It's become my favorite go-to shirt.",
    },
    {
      "name": "Alex M.",
      "rating": 4.0,
      "date": "August 15, 2023",
      "comment":
          "Great t-shirt, fits well and looks good. The material is nice.",
    },
    {
      "name": "Liam K.",
      "rating": 3.5,
      "date": "August 16, 2023",
      "comment":
          "Good quality but the sizing runs a bit small. Order a size up.",
    },
  ];

  // Product Details Data
  final List<Map<String, String>> _productSpecs = [
    {"label": "Material", "value": "100% Organic Cotton"},
    {"label": "Fabric Weight", "value": "180 GSM (Medium Weight)"},
    {"label": "Fit Type", "value": "Regular Fit"},
    {"label": "Neckline", "value": "Crew Neck"},
    {"label": "Sleeve Length", "value": "Short Sleeve"},
    {
      "label": "Care Instructions",
      "value": "Machine Wash Cold, Tumble Dry Low",
    },
    {"label": "Country of Origin", "value": "Made in USA"},
  ];

  // FAQs Data
  final List<Map<String, String>> _faqs = [
    {
      "question": "Is this t-shirt 100% cotton?",
      "answer":
          "Yes, it is made of 100% high-quality organic cotton which is soft on the skin and breathable.",
    },
    {
      "question": "How do I choose the right size?",
      "answer":
          "Please refer to our size chart available above the size selection buttons. It fits true to size for a regular fit.",
    },
    {
      "question": "Does the color fade after washing?",
      "answer":
          "No, we use high-grade dyes that ensure the color stays vibrant even after multiple washes if care instructions are followed.",
    },
    {
      "question": "What is the return policy?",
      "answer":
          "We offer a 30-day return policy for unused items with original tags attached. You can initiate a return from your account.",
    },
    {
      "question": "Do you ship internationally?",
      "answer":
          "Yes, we ship to over 100 countries worldwide. Shipping times may vary based on location.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 1,
    ); // Start at Reviews tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addToCart(Product product) {
    CartService.addItem(product, _quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.title} added to cart!"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    // Fake multiple images for gallery UI (using same image 3 times)
    final List<String> galleryImages = [
      product.image,
      product.image,
      product.image,
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(height: 1),
            Breadcrumbs(
              path: ["Home", "Shop", product.category, "Product Details"],
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60 : 20,
                vertical: 20,
              ),
              child: Flex(
                direction: isDesktop ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- IMAGE GALLERY SECTION ---
                  Expanded(
                    flex: isDesktop ? 1 : 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnails (Vertical List)
                        Column(
                          children: List.generate(galleryImages.length, (
                            index,
                          ) {
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedImageIndex = index),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0EEED),
                                  borderRadius: BorderRadius.circular(15),
                                  border: _selectedImageIndex == index
                                      ? Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                padding: const EdgeInsets.all(5),
                                child: Image.network(
                                  galleryImages[index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 20),
                        // Main Image
                        Expanded(
                          child: Container(
                            height: 500,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EEED),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(30),
                            child: Image.network(
                              galleryImages[_selectedImageIndex],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isDesktop) const SizedBox(width: 40),
                  if (!isDesktop) const SizedBox(height: 40),

                  // --- PRODUCT INFO SECTION ---
                  Expanded(
                    flex: isDesktop ? 1 : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title.toUpperCase(),
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Row(
                              children: List.generate(
                                5,
                                (i) => Icon(
                                  i < product.rating['rate'].round()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${product.rating['rate']}/5",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Price Row
                        Row(
                          children: [
                            Text(
                              "\$${product.price}",
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "\$${(product.price * 1.2).toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "-20%",
                                style: TextStyle(
                                  color: Colors.red[400],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          product.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            height: 1.5,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(height: 40),

                        // Select Colors
                        const Text(
                          "Select Colors",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: _colors
                              .map(
                                (color) => GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedColor = color),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 15),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                    child: _selectedColor == color
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const Divider(height: 40),

                        // Choose Size
                        const Text(
                          "Choose Size",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 15),
                        Wrap(
                          spacing: 12,
                          children: _sizes
                              .map(
                                (s) => GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedSize = s),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _selectedSize == s
                                          ? Colors.black
                                          : const Color(0xFFF0F0F0),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      s,
                                      style: TextStyle(
                                        color: _selectedSize == s
                                            ? Colors.white
                                            : Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const Divider(height: 40),

                        // Quantity & Add Buttons
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () => setState(() {
                                      if (_quantity > 1) _quantity--;
                                    }),
                                    child: const Icon(Icons.remove),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                    ),
                                    child: Text(
                                      "$_quantity",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => setState(() => _quantity++),
                                    child: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _addToCart(product),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  "Add to Cart",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- TABS SECTION (Reviews, Specs, FAQs) ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(text: "Product Details"),
                      Tab(text: "Rating & Reviews"),
                      Tab(text: "FAQs"),
                    ],
                  ),
                  const Divider(height: 1),
                  SizedBox(
                    height: 600, // Fixed height for tab content area
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab 1: Product Details (Specs)
                        ListView(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          children: [
                            const Text(
                              "Specifications",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ..._productSpecs
                                .map(
                                  (spec) => Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              spec['label']!,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              spec['value']!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                    ],
                                  ),
                                )
                                .toList(),
                          ],
                        ),

                        // Tab 2: Reviews List
                        ListView(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "All Reviews (451)",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Filter Buttons (Dummy Design)
                                Row(
                                  children: [
                                    _filterBtn(Icons.tune),
                                    const SizedBox(width: 10),
                                    _filterBtn(
                                      Icons.keyboard_arrow_down,
                                      label: "Latest",
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                        shape: const StadiumBorder(),
                                      ),
                                      child: const Text("Write a Review"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            // Reviews Grid
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _reviews.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isDesktop ? 2 : 1,
                                    childAspectRatio: isDesktop ? 2.5 : 1.8,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                  ),
                              itemBuilder: (ctx, i) =>
                                  _ReviewCard(review: _reviews[i]),
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 15,
                                  ),
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text(
                                  "Load More Reviews",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Tab 3: FAQs
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          itemCount: _faqs.length,
                          itemBuilder: (ctx, i) => Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ExpansionTile(
                              shape: const Border(),
                              // Remove default borders
                              tilePadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              title: Text(
                                _faqs[i]['question']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    0,
                                    20,
                                    20,
                                  ),
                                  child: Text(
                                    _faqs[i]['answer']!,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _filterBtn(IconData icon, {String? label}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20),
    );
  }
}

// --- REVIEW CARD WIDGET ---
class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review['rating'].round()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
              ),
              Icon(Icons.more_horiz, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(
                review['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.check_circle, color: Colors.green, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              '"${review['comment']}"',
              style: TextStyle(color: Colors.grey[600], height: 1.5),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Posted on ${review['date']}",
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }
}
