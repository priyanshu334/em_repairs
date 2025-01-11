import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/pages/List_page.dart';
import 'package:em_repairs/pages/ServiceCenter_Page.dart';
import 'package:em_repairs/pages/help_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceDetailsPage extends StatelessWidget {
  const ServiceDetailsPage({super.key});

  void _navigateToListPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListPage()),
    );
  }

  void _navigateToServiceCenterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ServiceCenterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Service Details",
        leadingIcon: CupertinoIcons.cube_box,
         actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              // Handle help action
                 Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HelpPage()));
            
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Hero Widget for animated settings icon
              Hero(
                tag: 'settingsIcon',
                child: const Icon(
                  Icons.settings,
                  size: 120,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 24),
              
              // Animated Text
              AnimatedText(
                text: "Welcome to Repair Partner  Details",
                textStyle: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Manage your services and find detailed information here.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 32),

              // Card with some service info
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.assignment_turned_in,
                        color: Colors.blue,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Service Updates: Your service is in progress.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Animated Buttons with icons
              _buildAnimatedButton(
                context: context,
                label: "Add a service operator",
                color: Colors.blue,
                onPressed: () => _navigateToListPage(context),
                icon: Icons.list,
              ),
              const SizedBox(height: 16),
              _buildAnimatedButton(
                context: context,
                label: "Go to Service Center",
                color: Colors.green,
                onPressed: () => _navigateToServiceCenterPage(context),
                icon: Icons.local_shipping,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedButton({
    required BuildContext context,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.8, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Less rounded
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            ),
            onPressed: onPressed,
            icon: Icon(icon, color: Colors.white),
            label: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;

  const AnimatedText({Key? key, required this.text, required this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeInOut,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
