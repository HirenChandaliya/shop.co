import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecommerce/widgets/commonWidget.dart'; // Ensure path is correct
import 'package:myecommerce/widgets/homeWidgets.dart'; // For ProductGrid
import 'package:myecommerce/widgets/productWidgets.dart';
import '../modal/productModel.dart';
import '../services/cartServices.dart'; // Ensure path is correct

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  String _selectedSize = "Large";
  Color _selectedColor = const Color(0xFF4F4631);
  int _selectedImageIndex = 0;
  late TabController _tabController;

  final List<Color> _colors = [
    const Color(0xFF4F4631),
    const Color(0xFF314F4A),
    const Color(0xFF31344F),
  ];

  final List<String> _sizes = ["Small", "Medium", "Large", "X-Large"];

  // --- DATA FOR TABS ---
  final List<Map<String, dynamic>> _reviews = [
    {
      "name": "Samantha D.",
      "rating": 4.5,
      "date": "August 14, 2023",
      "comment": "I absolutely love this t-shirt! The design is unique and the fabric feels so comfortable."
    },
    {
      "name": "Alex M.",
      "rating": 4.0,
      "date": "August 15, 2023",
      "comment": "Great t-shirt, fits well and looks good. The material is nice."
    },
    {
      "name": "Liam K.",
      "rating": 3.5,
      "date": "August 16, 2023",
      "comment": "Good quality but the sizing runs a bit small. Order a size up."
    },
    {
      "name": "Ethan R.",
      "rating": 5.0,
      "date": "August 17, 2023",
      "comment": "Perfect fit and amazing quality. Will buy again!"
    },
  ];

  final List<Map<String, String>> _productSpecs = [
    {"label": "Material", "value": "100% Organic Cotton"},
    {"label": "Fabric Weight", "value": "180 GSM (Medium Weight)"},
    {"label": "Fit Type", "value": "Regular Fit"},
    {"label": "Neckline", "value": "Crew Neck"},
    {"label": "Care", "value": "Machine Wash Cold"},
    {"label": "Origin", "value": "Made in USA"},
  ];

  final List<Map<String, String>> _faqs = [
    {"question": "Is this t-shirt 100% cotton?", "answer": "Yes, it is made of 100% high-quality organic cotton."},
    {"question": "How do I choose the right size?", "answer": "Please refer to our size chart available above."},
    {"question": "What is the return policy?", "answer": "We offer a 30-day return policy for unused items."},
  ];

  @override
  void initState() {
    super.initState();
    // Default index 1 sets it to "Rating & Reviews" tab
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addToCart(Product product) {
    CartService.addItem(product, _quantity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product.title} added to cart!"), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    // 1. GET PRODUCT DATA
    final Product product = ModalRoute.of(context)!.settings.arguments as Product;

    // 2. IMAGES LIST
    final List<String> galleryImages = product.images;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(height: 1),
            Breadcrumbs(
              path: ["Home", "Shop", product.category, "Details"],
            ),

            // --- TOP SECTION: IMAGES & INFO ---
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60 : 20,
                vertical: 20,
              ),
              child: Flex(
                direction: isDesktop ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- IMAGE GALLERY ---
                  Expanded(
                    flex: isDesktop ? 1 : 0,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnails
                        Column(
                          children: List.generate(galleryImages.length, (index) {
                            return GestureDetector(
                              onTap: () => setState(() => _selectedImageIndex = index),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0EEED),
                                  borderRadius: BorderRadius.circular(15),
                                  border: _selectedImageIndex == index
                                      ? Border.all(color: Colors.black, width: 2)
                                      : null,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.network(
                                    galleryImages[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (c,e,s) => const Icon(Icons.error),
                                  ),
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
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EEED),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                galleryImages.length > _selectedImageIndex
                                    ? galleryImages[_selectedImageIndex]
                                    : galleryImages[0],
                                fit: BoxFit.cover, // Changed to contain for better view
                                errorBuilder: (c,e,s) => const Center(child: Icon(Icons.image_not_supported)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isDesktop) const SizedBox(width: 40),
                  if (!isDesktop) const SizedBox(height: 40),

                  // --- PRODUCT INFO ---
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
                            Row(children: List.generate(5, (i) => Icon(i < 4 ? Icons.star : Icons.star_border, color: Colors.amber, size: 22))),
                            const SizedBox(width: 10),
                            const Text("4.5/5", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text("\$${product.price}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          product.description,
                          style: TextStyle(color: Colors.grey[600], height: 1.5, fontSize: 16),
                        ),
                        const Divider(height: 40),
                        const Text("Select Colors", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 15),
                        Row(
                          children: _colors.map((color) => GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: Container(
                              margin: const EdgeInsets.only(right: 15),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                              child: _selectedColor == color ? const Icon(Icons.check, color: Colors.white) : null,
                            ),
                          )).toList(),
                        ),
                        const Divider(height: 40),
                        const Text("Choose Size", style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 15),
                        Wrap(
                          spacing: 12,
                          children: _sizes.map((s) => GestureDetector(
                            onTap: () => setState(() => _selectedSize = s),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              decoration: BoxDecoration(
                                color: _selectedSize == s ? Colors.black : const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(s, style: TextStyle(color: _selectedSize == s ? Colors.white : Colors.grey[600], fontWeight: FontWeight.w500)),
                            ),
                          )).toList(),
                        ),
                        const Divider(height: 40),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(40)),
                              child: Row(
                                children: [
                                  InkWell(onTap: () => setState(() { if (_quantity > 1) _quantity--; }), child: const Icon(Icons.remove)),
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: 25), child: Text("$_quantity", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                                  InkWell(onTap: () => setState(() => _quantity++), child: const Icon(Icons.add)),
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
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text("Add to Cart", style: TextStyle(fontSize: 16)),
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

            const SizedBox(height: 50),

            // --- TABS SECTION (REVIEWS, SPECS, FAQS) ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20),
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    tabs: const [
                      Tab(text: "Product Details"),
                      Tab(text: "Rating & Reviews"),
                      Tab(text: "FAQs"),
                    ],
                  ),
                  const Divider(height: 1),

                  // FIXED HEIGHT FOR TAB CONTENT TO MAKE PAGE LONG
                  SizedBox(
                    height: 600,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // 1. Details Tab
                        ListView(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          physics: const NeverScrollableScrollPhysics(), // Scroll main page instead
                          children: _productSpecs.map((spec) => Column(children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(spec['label']!, style: TextStyle(color: Colors.grey[600], fontSize: 16)), Text(spec['value']!, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16))])),
                            const Divider(),
                          ])).toList(),
                        ),

                        // 2. Reviews Tab
                        ListView(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text("All Reviews (451)", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, shape: const StadiumBorder()), child: const Text("Write a Review"))]),
                            const SizedBox(height: 30),
                            // Review Cards
                            ..._reviews.map((r) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(20)),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: List.generate(5, (i) => Icon(i < r['rating'].round() ? Icons.star : Icons.star_border, color: Colors.amber, size: 20))), Icon(Icons.more_horiz, color: Colors.grey[400])]),
                                  const SizedBox(height: 10),
                                  Text(r['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 5),
                                  Text('"${r['comment']}"', style: TextStyle(color: Colors.grey[600], height: 1.5)),
                                  const SizedBox(height: 10),
                                  Text("Posted on ${r['date']}", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                                ]),
                              ),
                            )).toList(),
                            Center(child: OutlinedButton(onPressed: () {}, child: const Text("Load More Reviews", style: TextStyle(color: Colors.black)))),
                          ],
                        ),

                        // 3. FAQs Tab
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _faqs.length,
                          itemBuilder: (ctx, i) => Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(15)),
                            child: ExpansionTile(title: Text(_faqs[i]['question']!, style: const TextStyle(fontWeight: FontWeight.bold)), children: [Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), child: Text(_faqs[i]['answer']!, style: TextStyle(color: Colors.grey[600])))]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- YOU MIGHT ALSO LIKE ---
            const SizedBox(height: 50),
            Text("YOU MIGHT ALSO LIKE", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w900)),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: ProductGrid(limit: 4), // Requires your ProductGrid widget
            ),

            const SizedBox(height: 80),

            // --- FOOTER SECTION ---
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}