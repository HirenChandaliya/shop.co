import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecommerce/services/api_service.dart';
import 'package:myecommerce/widgets/productWidgets.dart';
import 'package:myecommerce/widgets/shimmerWidgets.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      color: const Color(0xFFF2F0F1),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        children: [
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FIND CLOTHES\nTHAT MATCHES\nYOUR STYLE",
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 38 : 58,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/category'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 18,
                      ),
                    ),
                    child: const Text("Shop Now"),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _Stat(num: "200+", label: "Brands"),
                      _Stat(num: "2k+", label: "Products"),
                      _Stat(num: "30k+", label: "Customers"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Image.network(
              "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600",
              height: 500,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

 class _Stat extends StatelessWidget {
  final String num, label;

  const _Stat({required this.num, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          num,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class BrandStrip extends StatefulWidget {
  const BrandStrip({super.key});

  @override
  State<BrandStrip> createState() => _BrandStripState();
}

class _BrandStripState extends State<BrandStrip>
    with SingleTickerProviderStateMixin {

  late ScrollController _scrollController;
  late AnimationController _animationController;

  final List<String> brands = ["VERSACE", "ZARA", "GUCCI", "PRADA", "CK"];

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..addListener(() {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _animationController.value *
              _scrollController.position.maxScrollExtent,
        );
      }
    });

    _animationController.repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Duplicate list — infinite scrolling feel
    final displayList = [...brands, ...brands, ...brands];

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 30),
      width: double.infinity,
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                displayList[index],
                style: GoogleFonts.cinzel(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
class ProductSection extends StatelessWidget {
  final String title;

  const ProductSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 40),
        const ProductGrid(limit: 4),
        const SizedBox(height: 30),
        OutlinedButton(
          onPressed: () => Navigator.pushNamed(context, '/category'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          child: const Text("View All", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}

// ... baki na widgets (HeroSection etc) same rakho
class DressStyleSection extends StatelessWidget {
  const DressStyleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          Text(
            "BROWSE BY CATEGORY",
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          FutureBuilder<List<String>>(
            future: ApiService.getAllCategories(),
            builder: (context, snapshot) {
              // --- SHIMMER EFFECT HERE ---
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CategoryShimmerList(); // <--- Shimmer
              } else if (snapshot.hasError) {
                return const Text("Failed to load categories");
              }

              final categories = snapshot.data!;
              final Map<String, String> catImages = {
                "electronics":
                    "https://images.unsplash.com/photo-1498049860654-af1a5c5668ba?w=400",
                "jewelery":
                    "https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=400",
                "men's clothing":
                    "https://images.unsplash.com/photo-1490114538077-0a7f8cb49891?w=400",
                "women's clothing":
                    "https://images.unsplash.com/photo-1525507119028-ed4c629a60a3?w=400",
              };

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: categories.map((catName) {
                  return InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/category',
                      arguments: {'title': catName},
                    ),
                    child: Container(
                      width: 250,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(
                            catImages[catName] ??
                                "https://via.placeholder.com/300",
                          ),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.3),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        catName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "OUR HAPPY CUSTOMERS",
          style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ["Sarah", "Alex", "James"]
                .map(
                  (e) => Container(
                    width: 300,
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                            Icon(Icons.star, color: Colors.amber),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          e,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        const Text("I love the quality! It's amazing."),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
