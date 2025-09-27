import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import for SVG

void main() {
  runApp(ProfileScreen());
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.teal),
            onPressed: () {
              // Go back
            },
          ),
          title: const Text('Profile', style: TextStyle(color: Colors.teal)),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              color: Colors.teal.shade100, // Color of the divider
              height: 1, // Height of the divider
            ),
            const SizedBox(
                height: 2), // Minimal space between divider and profile image
            Expanded(child: ProfilePage()),
          ],
        ),
        backgroundColor: Colors.white, // Background color set to white
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 117,
                      height: 117,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    CustomPaint(
                      size: const Size(117, 117),
                      painter: HalfCirclePainter(),
                    ),
                  ],
                ),
                const SizedBox(width: 20), // Space between image and text
                SizedBox(
                  width: 160,
                  height: 64,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'XYZ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      Text(
                        'xyz@mail.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30), // Space between header and buttons
            ProfileButton(
                icon: SvgPicture.asset('assets/icons/favorite.svg'),
                label: 'Favorite'),
            ProfileButton(
                icon: SvgPicture.asset('assets/icons/referral.svg'),
                label: 'Referral'),
            ProfileButton(
                icon: SvgPicture.asset('assets/icons/schedule.svg'),
                label: 'Schedule'),
            ProfileButton(
                icon: SvgPicture.asset('assets/icons/editprofile.svg'),
                label: 'Edit Profile'),
            ProfileButton(
                icon: SvgPicture.asset('assets/icons/setting.svg'),
                label: 'Settings'),
            ProfileButton(
                icon: SvgPicture.asset('assets/icons/reward.svg'),
                label: 'Rewards'),
            ProfileButton(
                icon: SvgPicture.asset('assets/icons/HelpFAQs.svg'),
                label: 'Help & FAQs'),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft, // Aligns the button to the left
              child: ElevatedButton.icon(
                onPressed: () {
                  // Log out action
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Log Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 255, 204, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final Path path = Path()
      ..arcTo(
        Rect.fromLTWH(0, 0, size.width, size.height),
        -1.5, // Starting angle for half-circle on the right side
        3.0, // Sweep angle for the half-circle
        false,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ProfileButton extends StatelessWidget {
  final Widget icon; // Changed from IconData to Widget
  final String label;

  const ProfileButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 361, // Width set to 361 pixels
        height: 42, // Height set to 42 pixels
        child: OutlinedButton.icon(
          onPressed: () {
            // Button action
          },
          icon: icon, // Using the passed Widget directly
          label: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(label),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.teal),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            foregroundColor: Colors.teal,
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
