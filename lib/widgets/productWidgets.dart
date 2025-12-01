import 'package:flutter/material.dart';
import 'package:myecommerce/modal/productModel.dart';
import 'package:myecommerce/widgets/shimmerWidgets.dart';

import '../services/api_service.dart';

// --- PRODUCT GRID ---
class ProductGrid extends StatelessWidget {
  final int? limit;
  final String? filterCategory;
  final RangeValues? priceRange; // <--- 1. AA VARI ABLE ADD KARO

  const ProductGrid({
    super.key,
    this.limit,
    this.filterCategory,
    this.priceRange, // <--- 2. CONSTRUCTOR MA ADD KARO
  });

  @override
  Widget build(BuildContext context) {
    Future<List<Product>> fetchLogic;

    if (filterCategory != null && filterCategory != "All Products") {
      fetchLogic = ApiService.getProductsByCategory(filterCategory!);
    } else {
      fetchLogic = ApiService.getAllProducts();
    }

    return FutureBuilder<List<Product>>(
      future: fetchLogic,
      builder: (context, snapshot) {
        // --- SHIMMER EFFECT ---
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ProductShimmerGrid(itemCount: limit ?? 6);
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No products found"));
        }

        List<Product> products = snapshot.data!;

        // --- 3. PRICE FILTER LOGIC ---
        // Jo priceRange pass thayu hoy, to filter karo
        if (priceRange != null) {
          products = products.where((p) {
            return p.price >= priceRange!.start && p.price <= priceRange!.end;
          }).toList();
        }

        // Jo filter karya pachi koi product na vadhe
        if (products.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text("No products match this price range.")),
          );
        }

        // --- LIMIT LOGIC ---
        if (limit != null) {
          products = products.take(limit!).toList();
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio: 0.65,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (ctx, i) => _ProductCard(product: products[i]),
        );
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, '/product', arguments: widget.product),
        child: AnimatedScale(
          scale: hover ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFFF0EEED),
                  ),
                  child: Image.network(
                    widget.product.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(
                    " ${widget.product.rating['rate']}/5",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "\$${widget.product.price}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- FILTER SIDEBAR ---
class FilterSidebar extends StatelessWidget {
  final RangeValues currentRange;
  final Function(RangeValues) onPriceChanged;
  final String currentCategory;

  const FilterSidebar({
    super.key,
    required this.currentRange,
    required this.onPriceChanged,
    required this.currentCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Categories",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ...[
            "electronics",
            "jewelery",
            "men's clothing",
            "women's clothing",
          ].map(
            (e) => InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/category',
                  arguments: {'title': e},
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        e,
                        style: TextStyle(
                          color: currentCategory == e
                              ? Colors.black
                              : Colors.grey,
                          fontWeight: currentCategory == e
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, size: 16),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 30),
          const Text(
            "Price Range",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("\$${currentRange.start.round()}"),
              Text("\$${currentRange.end.round()}"),
            ],
          ),
          RangeSlider(
            values: currentRange,
            min: 0,
            max: 1000,
            divisions: 20,
            activeColor: Colors.black,
            inactiveColor: Colors.grey[300],
            labels: RangeLabels(
              "\$${currentRange.start.round()}",
              "\$${currentRange.end.round()}",
            ),
            onChanged: (RangeValues values) {
              onPriceChanged(values);
            },
          ),
        ],
      ),
    );
  }
}
