import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myecommerce/services/api_service.dart';
import 'package:myecommerce/widgets/commonWidget.dart'; // Ensure CustomAppBar is here

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ApiService.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Scaffold(
      extendBodyBehindAppBar: true, // App bar pachal background java de
      appBar: const CustomAppBar(), // Your existing transparent/white app bar
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE
          Positioned.fill(
            child: Image.network(
              "https://images.unsplash.com/photo-1490481651871-ab68de25d43d?q=80&w=1470&auto=format&fit=crop", // Profile Theme Image
              fit: BoxFit.cover,
            ),
          ),
          // 2. BLACK OVERLAY
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.6)),
          ),

          // 3. MAIN CONTENT (CENTERED CARD)
          Center(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _profileFuture,
              builder: (context, snapshot) {
                // Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.white);
                }

                // Error State
                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock_outline, size: 50, color: Colors.red),
                        const SizedBox(height: 20),
                        const Text("Please Log In to view profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                          child: const Text("Go to Login"),
                        )
                      ],
                    ),
                  );
                }

                // Success State
                final user = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20), // Spacing for AppBar
                  child: Container(
                    width: isDesktop ? 600 : double.infinity, // Max width for card
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        // --- Profile Header ---
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4), // Border space
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: NetworkImage(user['avatar'] ?? "https://i.imgur.com/xdbHo4E.png"),
                              ),
                            ),
                            // Edit Icon
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                              child: const Icon(Icons.edit, color: Colors.white, size: 18),
                            )
                          ],
                        ),

                        const SizedBox(height: 20),

                        Text(
                          user['name'].toString().toUpperCase(),
                          style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          user['email'],
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            user['role'].toString().toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                        ),

                        const SizedBox(height: 40),
                        const Divider(),
                        const SizedBox(height: 20),

                        // --- Menu Options ---
                        _buildMenuItem(Icons.shopping_bag_outlined, "My Orders"),
                        _buildMenuItem(Icons.favorite_outline, "Wishlist"),
                        _buildMenuItem(Icons.location_on_outlined, "Shipping Address"),
                        _buildMenuItem(Icons.credit_card, "Payment Methods"),
                        _buildMenuItem(Icons.settings_outlined, "Account Settings"),

                        const SizedBox(height: 40),

                        // --- Logout Button ---
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              ApiService.currentToken = null; // Clear Token
                              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[50],
                              foregroundColor: Colors.red,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.logout),
                                SizedBox(width: 10),
                                Text("Log Out", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.black, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(5)),
        child: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      ),
    );
  }
}