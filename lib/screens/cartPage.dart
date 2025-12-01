import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../services/cartServices.dart';
import '../widgets/commonWidget.dart';

// import '../widgets/common_widgets.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Local Data List
  List<CartItem> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  // Data Load Karo (Simulated Delay for Shimmer)
  void _loadCart() async {
    // Thodo delay rakhiye jethi Shimmer dekhay (Real app ma aa jaruri nathi)
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _cartItems = CartService.getItems(); // Local List mathi data lavo
        _isLoading = false;
      });
    }
  }

  // Remove Item
  void _removeItem(int productId) {
    setState(() {
      CartService.removeItem(productId);
      _cartItems = CartService.getItems(); // UI Refresh
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Item removed"), duration: Duration(milliseconds: 500)),
    );
  }

  // Update Quantity
  void _updateQty(int productId, int change) {
    setState(() {
      CartService.updateQuantity(productId, change);
      _cartItems = CartService.getItems(); // UI Refresh
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    // --- LOADING (SHIMMER) ---
    if (_isLoading) {
      return Scaffold(
        appBar: const CustomAppBar(),
        body: _CartShimmerView(isDesktop: isDesktop),
      );
    }

    // --- EMPTY STATE ---
    if (_cartItems.isEmpty) {
      return Scaffold(
        appBar: const CustomAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text("Your cart is empty", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)
                ),
                child: const Text("Start Shopping"),
              )
            ],
          ),
        ),
      );
    }

    // --- CALCULATION ---
    double subtotal = 0;
    for (var item in _cartItems) {
      subtotal += (item.product.price * item.quantity);
    }
    double discount = subtotal * 0.20; // 20% discount logic
    double delivery = 15;
    double total = subtotal - discount + delivery;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(height: 1),
            const Breadcrumbs(path: ["Home", "Cart"]),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 60 : 20,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "YOUR CART",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Flex(
                    direction: isDesktop ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- LEFT SIDE: CART ITEMS ---
                      Expanded(
                        flex: isDesktop ? 3 : 0,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: _cartItems.map((item) {
                              return Column(
                                children: [
                                  _CartItemWidget(
                                    item: item,
                                    onDelete: () => _removeItem(item.product.id),
                                    onUpdateQty: (change) => _updateQty(item.product.id, change),
                                  ),
                                  if (item != _cartItems.last)
                                    const Divider(height: 30),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      if (isDesktop) const SizedBox(width: 20),
                      if (!isDesktop) const SizedBox(height: 20),

                      // --- RIGHT SIDE: SUMMARY ---
                      Expanded(
                        flex: isDesktop ? 2 : 0,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Order Summary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              _summaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                              _summaryRow("Discount (-20%)", "-\$${discount.toStringAsFixed(2)}", isRed: true),
                              _summaryRow("Delivery Fee", "\$${delivery.toStringAsFixed(2)}"),
                              const Divider(height: 30),
                              _summaryRow("Total", "\$${total.toStringAsFixed(2)}", isBold: true),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pushNamed(context, '/checkout'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Text("Go to Checkout", style: TextStyle(fontSize: 16)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

  Widget _summaryRow(String label, String amount, {bool isRed = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          Text(
            amount,
            style: TextStyle(
              fontSize: isBold ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: isRed ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// --- ITEM WIDGET ---
class _CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onDelete;
  final Function(int) onUpdateQty;

  const _CartItemWidget({required this.item, required this.onDelete, required this.onUpdateQty});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF0EEED),
          ),
          child: Image.network(item.product.image, fit: BoxFit.contain),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: SizedBox(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    InkWell(
                      onTap: onDelete,
                      child: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                    ),
                  ],
                ),
                Text("Category: ${item.product.category}", style: const TextStyle(fontSize: 12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${item.product.price}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => onUpdateQty(-1),
                            child: const Icon(Icons.remove, size: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          InkWell(
                            onTap: () => onUpdateQty(1),
                            child: const Icon(Icons.add, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- SHIMMER VIEW ---
class _CartShimmerView extends StatelessWidget {
  final bool isDesktop;
  const _CartShimmerView({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(height: 1),
            Container(margin: const EdgeInsets.all(20), width: 150, height: 20, color: Colors.white),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20, vertical: 20),
              child: Column(
                children: [
                  Container(width: 200, height: 40, color: Colors.white),
                  const SizedBox(height: 20),
                  Container(width: double.infinity, height: 400, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}