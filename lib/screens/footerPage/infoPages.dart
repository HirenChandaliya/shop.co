import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. GENERIC INFO PAGE LAYOUT (આ એક કોમન ડિઝાઈન છે જે બધા પેજ વાપરશે)
class BaseInfoPage extends StatelessWidget {
  final String title;
  final String content;

  const BaseInfoPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              content,
              style: GoogleFonts.poppins(
                fontSize: 16,
                height: 1.6,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 2. ABOUT PAGE
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseInfoPage(
      title: "About Us",
      content:
          "Welcome to SHOP.CO. We are a fashion brand that believes in style and comfort. Established in 2000, we have been serving customers with the best quality clothes.\n\nOur mission is to make fashion accessible to everyone. We source the finest materials and work with top designers to bring you the latest trends.",
    );
  }
}

// 3. TERMS & CONDITIONS PAGE
class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseInfoPage(
      title: "Terms & Conditions",
      content:
          "1. Introduction\nBy using SHOP.CO, you agree to these terms.\n\n2. Purchases\nAll purchases are subject to availability. Prices may change without notice.\n\n3. Returns\nYou can return items within 30 days of receipt.\n\n4. User Accounts\nYou are responsible for maintaining the confidentiality of your account.",
    );
  }
}

// 4. PRIVACY POLICY PAGE
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseInfoPage(
      title: "Privacy Policy",
      content:
          "We value your privacy. This policy explains how we collect and use your data.\n\n- We collect your email and shipping address for order processing.\n- We do not share your data with third parties.\n- You can request to delete your data at any time.",
    );
  }
}

// 5. DELIVERY DETAILS PAGE
class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseInfoPage(
      title: "Delivery Details",
      content:
          "Standard Delivery:\n3-5 Business Days - \$15\n\nExpress Delivery:\n1-2 Business Days - \$25\n\nInternational Shipping:\nAvailable to select countries. Custom duties may apply.",
    );
  }
}

// 6. CAREERS PAGE (Simple List)
class CareersPage extends StatelessWidget {
  const CareersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Careers"),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Join Our Team",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _jobTile("Senior Flutter Developer", "Remote"),
          _jobTile("UI/UX Designer", "New York, USA"),
          _jobTile("Product Manager", "London, UK"),
        ],
      ),
    );
  }

  Widget _jobTile(String title, String loc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(loc),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: const Text("Apply"),
        ),
      ),
    );
  }
}
