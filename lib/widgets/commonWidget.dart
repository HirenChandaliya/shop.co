import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecommerce/screens/footerPage/infoPages.dart';
import 'package:myecommerce/screens/footerPage/supportPages.dart';

// --- Custom App Bar ---
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: InkWell(
        onTap: () => Navigator.pushNamed(context, '/'),
        child: Text(
          "SHOP.CO",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w900,
            color: Colors.black,
            fontSize: 24,
          ),
        ),
      ),
      actions: [
        const Icon(Icons.search, color: Colors.black),
        const SizedBox(width: 15),
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/cart'),
          child: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
        ),
        const SizedBox(width: 15),
        const Icon(Icons.person_outline, color: Colors.black),
        const SizedBox(width: 20),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

// --- Navigation Bar (For Home Page) ---
class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 900;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          if (!isDesktop) ...[
            const Icon(Icons.menu),
            const SizedBox(width: 10),
          ],
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/'),
            child: Text(
              "SHOP.CO",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 40),
            _navLink(context, "Shop"),
            _navLink(context, "On Sale"),
            _navLink(context, "New Arrivals"),
            _navLink(context, "Brands"),
          ],
          const Spacer(),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/cart'),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
          const SizedBox(width: 15),
          const Icon(Icons.account_circle_outlined),
        ],
      ),
    );
  }

  Widget _navLink(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/category'),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    // ... (Container ane UI code same rahevado)
    // _buildFooterColumn call karvana logic same rakho
    // Ahiya khali me content copy nathi karyo, tamare juno code j rakhvano chhe
    // bas niche apel function add karvanu chhe.

    return Container(
      color: const Color(0xFFF0F0F0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        children: [
          Wrap(
            spacing: 50,
            runSpacing: 30,
            alignment: WrapAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SHOP.CO",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "We have clothes that suit your style.",
                      style: TextStyle(color: Colors.grey, height: 1.5),
                    ),
                  ],
                ),
              ),

              // COMPANY
              _buildFooterColumn(context, "COMPANY", [
                "About",
                "Features",
                "Works",
                "Career",
              ]),
              // HELP
              _buildFooterColumn(context, "HELP", [
                "Customer Support",
                "Delivery Details",
                "Terms & Conditions",
                "Privacy Policy",
              ]),
              // FAQ
              _buildFooterColumn(context, "FAQ", [
                "Account",
                "Manage Deliveries",
                "Orders",
                "Payments",
              ]),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(),
          const Text("Shop.co © 2000-2025"),
        ],
      ),
    );
  }

  Widget _buildFooterColumn(
    BuildContext context,
    String title,
    List<String> links,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        ...links.map(
          (linkText) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                // Ahiya Logic change karyu chhe:
                Widget page = _getFooterPage(linkText);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              },
              child: Text(
                linkText,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getFooterPage(String linkText) {
    switch (linkText) {
      case "About":
        return const AboutPage();
      case "Career":
        return const CareersPage();
      case "Terms & Conditions":
        return const TermsPage();
      case "Privacy Policy":
        return const PrivacyPage();
      case "Delivery Details":
        return const DeliveryPage();
      case "Customer Support":
        return const CustomerSupportPage();
      case "Account":
      case "Manage Deliveries":
      case "Orders":
      case "Payments":
        // Aa badha FAQ section ma jase
        return const FaqPage();
      default:
        // Jo koi page banavelu na hoy to generic Info page batave
        return BaseInfoPage(
          title: linkText,
          content: "Information regarding $linkText will be updated soon.",
        );
    }
  }
}

class _SimpleInfoPage extends StatelessWidget {
  final String title;

  const _SimpleInfoPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              "$title Page",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "This is a placeholder page content. In a real app, actual legal or support information would go here.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }
}

class Breadcrumbs extends StatelessWidget {
  final List<String> path;

  const Breadcrumbs({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: path.map((e) {
          bool isLast = e == path.last;
          return Row(
            children: [
              Text(
                e,
                style: TextStyle(
                  color: isLast ? Colors.black : Colors.grey[600],
                  fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (!isLast)
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            ],
          );
        }).toList(),
      ),
    );
  }
}
