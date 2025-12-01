import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecommerce/widgets/productWidgets.dart';

import '../widgets/commonWidget.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // Initial Price Range (0 thi 1000 sudhi)
  RangeValues _currentRange = const RangeValues(0, 1000);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String categoryName = args?['title'] ?? "All Products";

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(height: 1),
            Breadcrumbs(path: ["Home", categoryName]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SIDEBAR MA VALUES PASS KARI ---
                  if (isDesktop)
                    SizedBox(
                      width: 280,
                      child: FilterSidebar(
                        currentCategory: categoryName,
                        currentRange: _currentRange,
                        onPriceChanged: (newRange) {
                          // Jyare slider hale tyare UI update karo
                          setState(() {
                            _currentRange = newRange;
                          });
                        },
                      ),
                    ),

                  if (isDesktop) const SizedBox(width: 30),

                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              categoryName,
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Sort by: Most Popular",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        // Mobile mate filter batavva mate nanu button (Optional)
                        if (!isDesktop)
                          ExpansionTile(
                            title: const Text("Show Filters"),
                            children: [
                              FilterSidebar(
                                currentCategory: categoryName,
                                currentRange: _currentRange,
                                onPriceChanged: (newRange) {
                                  setState(() => _currentRange = newRange);
                                },
                              ),
                            ],
                          ),

                        const SizedBox(height: 20),

                        // --- PRODUCT GRID MA RANGE PASS KARI ---
                        ProductGrid(
                          filterCategory: categoryName,
                          priceRange:
                              _currentRange, // <--- Ahia value pass kari
                        ),

                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}
