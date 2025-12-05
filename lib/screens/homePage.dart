import 'package:flutter/material.dart';
import 'package:myecommerce/screens/productCreatePage.dart';
import '../widgets/commonWidget.dart';
import '../widgets/homeWidgets.dart';

class HomePage extends StatefulWidget { // 1. Convert to StatefulWidget
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 2. Key for refreshing product list
  Key _productSectionKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final padding = w > 1200 ? 100.0 : (w > 800 ? 50.0 : 20.0);

    return Scaffold(
      // 3. Floating Action Button to Add Product
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Product", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () async {
          // Navigate to Create Page and wait for result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateProductPage()),
          );

          // If product created successfully (result == true), refresh the list
          if (result == true) {
            setState(() {
              _productSectionKey = UniqueKey(); // This forces rebuild
            });
          }
        },
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: const NavBar(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: const HeroSection(),
            ),
            const BrandStrip(),
            const SizedBox(height: 50),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              // 4. Pass the Key here to refresh this section
              child: ProductSection(
                  key: _productSectionKey,
                  title: "NEW ARRIVALS"
              ),
            ),

            const Divider(
              height: 100,
              thickness: 1,
              indent: 100,
              endIndent: 100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: const DressStyleSection(),
            ),
            const SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: const ReviewsSection(),
            ),
            const SizedBox(height: 100),
            const FooterSection(),
          ],
        ),
      ),
    );
  }
}