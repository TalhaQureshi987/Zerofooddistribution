import 'package:flutter/material.dart';
import '../account/personal_info_screen.dart';
import '../account/address_screen.dart';
import '../account/phone_number_screen.dart';

// Mock user data model
class UserProfile {
  final String name;
  final String email;
  final String? profileUrl;
  final int donations;
  final int requests;
  final int points;

  UserProfile({
    required this.name,
    required this.email,
    this.profileUrl,
    this.donations = 0,
    this.requests = 0,
    this.points = 0,
  });
}

// Mock fetch function (replace with real backend call)
Future<UserProfile> fetchUserProfile() async {
  await Future.delayed(Duration(seconds: 1));
  return UserProfile(
    name: "Talha Abid",
    email: "talha@example.com",
    profileUrl: null, // e.g. https://example.com/avatar.jpg
    donations: 12,
    requests: 5,
    points: 1250,
  );
}

class ProfileScreen extends StatelessWidget {
  final Color bgColor = const Color(0xFFF4F4F4);
  final Color cardColor = const Color(0xFFD6B6A4);
  final Color accentColor = Colors.brown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF4F4F4), Color(0xFFE8F5E9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: FutureBuilder<UserProfile>(
            future: fetchUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error loading profile."));
              }

              final user = snapshot.data!;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(context),
                    const SizedBox(height: 20),
                    _profileCard(user),
                    const SizedBox(height: 24),
                    _buildMenuSection("Account", [
                      _menuItem(
                        Icons.person_outline,
                        "Personal Information",
                        () {
                          Navigator.pushNamed(context, "/edit_profile");
                        },
                      ),
                      _menuItem(Icons.location_on_outlined, "Address", () {
                        Navigator.pushNamed(context, "/address");
                      }),
                      _menuItem(Icons.phone_outlined, "Phone Number", () {
                        Navigator.pushNamed(context, "/phone_number");
                      }),
                      _menuItem(Icons.lock_outline, "Change Password", () {
                        Navigator.pushNamed(context, "/change_password");
                      }),
                    ]),
                    const SizedBox(height: 16),
                    _buildMenuSection("Activity", [
                      _menuItem(Icons.history, "Donation History", () {
                        Navigator.pushNamed(context, "/donation_history");
                      }),
                      _menuItem(Icons.receipt_long, "Request History", () {
                        Navigator.pushNamed(context, "/request_history");
                      }),
                      _menuItem(Icons.star_outline, "My Reviews", () {
                        Navigator.pushNamed(context, "/my_reviews");
                      }),
                      _menuItem(
                        Icons.notifications_outlined,
                        "Notifications",
                        () {
                          Navigator.pushNamed(context, "/notifications");
                        },
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildMenuSection("Support", [
                      _menuItem(Icons.help_outline, "Help & Support", () {
                        Navigator.pushNamed(context, "/help_support");
                      }),
                      _menuItem(Icons.info_outline, "About App", () {
                        Navigator.pushNamed(context, "/about_app");
                      }),
                      _menuItem(
                        Icons.privacy_tip_outlined,
                        "Privacy Policy",
                        () {
                          Navigator.pushNamed(context, "/privacy_policy");
                        },
                      ),
                      _menuItem(
                        Icons.description_outlined,
                        "Terms of Service",
                        () {
                          Navigator.pushNamed(context, "/terms_of_service");
                        },
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _logoutButton(context),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: accentColor, size: 28),
        ),
        Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pushNamed(context, "/edit_profile"),
          icon: Icon(Icons.edit, color: accentColor, size: 24),
        ),
      ],
    );
  }

  Widget _profileCard(UserProfile user) {
    return Center(
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: accentColor.withOpacity(0.1),
                backgroundImage:
                    user.profileUrl != null
                        ? NetworkImage(user.profileUrl!)
                        : null,
                child:
                    user.profileUrl == null
                        ? Icon(Icons.person, size: 50, color: accentColor)
                        : null,
              ),
              const SizedBox(height: 16),
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.email,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _statItem(
                    "Donations",
                    user.donations.toString(),
                    Icons.favorite,
                  ),
                  _statItem(
                    "Requests",
                    user.requests.toString(),
                    Icons.handshake,
                  ),
                  _statItem("Points", user.points.toString(), Icons.stars),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.brown.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.brown, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(children: items),
          ),
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.brown, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text("Logout"),
                  content: Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Implement logout logic
                        // e.g. clear user session/token from shared preferences
                        Navigator.pushReplacementNamed(context, "/login");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Logout"),
                    ),
                  ],
                ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[400],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            const SizedBox(width: 8),
            Text(
              "Logout",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
