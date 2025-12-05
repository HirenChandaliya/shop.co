import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecommerce/screens/cartPage.dart';
import 'package:myecommerce/screens/categoryPage.dart';
import 'package:myecommerce/screens/checkoutPage.dart';
import 'package:myecommerce/screens/homePage.dart';
import 'package:myecommerce/screens/loginPage.dart';
import 'package:myecommerce/screens/productDetailPage.dart';

void main() {
  runApp(const ShopCoApp());
}

class ShopCoApp extends StatelessWidget {
  const ShopCoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHOP.CO Final',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      // --- ROUTES SETUP ---
      initialRoute: '/login', // <--- Have pehla Login Page khulse
      routes: {
        '/login': (context) => const LoginPage(), // <--- Add this
        '/home': (context) => const HomePage(),
        '/': (context) => const HomePage(), // Fallback
        '/category': (context) => const CategoryPage(),
        '/product': (context) => const ProductDetailPage(),
        '/cart': (context) => const CartPage(),
        '/checkout': (context) => const CheckoutPage(),
      },
    );
  }
}