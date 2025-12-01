import 'package:flutter/material.dart';

import '../widgets/commonWidget.dart';
import '../widgets/homeWidgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final padding = w > 1200 ? 100.0 : (w > 800 ? 50.0 : 20.0);

    return Scaffold(
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
              child: const ProductSection(title: "NEW ARRIVALS"),
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
