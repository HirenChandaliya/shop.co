import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/cartServices.dart';
import '../widgets/commonWidget.dart';
// import '../services/cart_service.dart';
// import '..//widgets/common_widgets.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedPayment = "Credit Card"; // Default selection

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  // Calculation Helper
  double get _totalAmount {
    double subtotal = 0;
    for (var item in CartService.getItems()) {
      subtotal += (item.product.price * item.quantity);
    }
    double discount = subtotal * 0.20;
    double delivery = 15;
    return subtotal - discount + delivery;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Colors.white, // Website feel
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(height: 1),
            const Breadcrumbs(path: ["Home", "Cart", "Checkout"]),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 20, vertical: 30),
              child: Form(
                key: _formKey,
                child: Flex(
                  direction: isDesktop ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- LEFT SIDE: SHIPPING & PAYMENT ---
                    Expanded(
                      flex: isDesktop ? 3 : 0, // Desktop ma vadhu jagya
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Shipping Address", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),

                          // Form Fields
                          _buildTextField("Full Name", Icons.person, _nameController),
                          const SizedBox(height: 15),
                          _buildTextField("Street Address", Icons.home, _addressController),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(child: _buildTextField("City", Icons.location_city, _cityController)),
                              const SizedBox(width: 15),
                              Expanded(child: _buildTextField("Zip Code", Icons.numbers, _zipController)),
                            ],
                          ),

                          const SizedBox(height: 40),
                          Text("Payment Method", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),

                          // Payment Options Grid
                          Row(
                            children: [
                              Expanded(child: _paymentCard("Credit Card", Icons.credit_card)),
                              const SizedBox(width: 15),
                              Expanded(child: _paymentCard("Google Pay", Icons.account_balance_wallet)),
                            ],
                          ),
                          const SizedBox(height: 15),
                          _paymentCard("Cash on Delivery", Icons.money),
                        ],
                      ),
                    ),

                    if (isDesktop) const SizedBox(width: 60),
                    if (!isDesktop) const SizedBox(height: 50),

                    // --- RIGHT SIDE: ORDER SUMMARY ---
                    Expanded(
                      flex: isDesktop ? 2 : 0,
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Order Summary", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),

                            // Mini Cart List
                            if (CartService.getItems().isEmpty)
                              const Text("Your cart is empty.", style: TextStyle(color: Colors.grey))
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: CartService.getItems().length,
                                separatorBuilder: (ctx, i) => const Divider(),
                                itemBuilder: (ctx, i) {
                                  final item = CartService.getItems()[i];
                                  return Row(
                                    children: [
                                      Container(
                                        width: 50, height: 50,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(color: const Color(0xFFF0EEED), borderRadius: BorderRadius.circular(8)),
                                        child: Image.network(item.product.image),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(item.product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                                            Text("Qty: ${item.quantity}  x  \$${item.product.price}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                      Text("\$${(item.product.price * item.quantity).toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  );
                                },
                              ),

                            const Divider(height: 40, thickness: 1),

                            // Total Calculation
                            _summaryRow("Delivery Fee", "\$15.00"),
                            _summaryRow("Discount (20%)", "Included", isGreen: true),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                Text("\$${_totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              ],
                            ),

                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _processOrder,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text("Confirm Payment", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTextField(String label, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: (value) => value!.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey, size: 20),
            hintText: "Enter $label",
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black)),
          ),
        ),
      ],
    );
  }

  Widget _paymentCard(String name, IconData icon) {
    bool isSelected = _selectedPayment == name;
    return InkWell(
      onTap: () => setState(() => _selectedPayment = name),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withOpacity(0.03) : Colors.white,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade200, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: isSelected ? Colors.black : Colors.grey),
            const SizedBox(height: 10),
            Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.black : Colors.grey[700])),
            if (isSelected) ...[
              const SizedBox(height: 5),
              const Icon(Icons.check_circle, size: 16, color: Colors.black),
            ]
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: isGreen ? Colors.green : Colors.black)),
        ],
      ),
    );
  }

  void _processOrder() {
    if (_formKey.currentState!.validate()) {
      // Success Dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 20),
              const Text("Order Successful!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Thank you for your purchase.", textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                child: const Text("Continue Shopping"),
              )
            ],
          ),
        ),
      );
    }
  }
}