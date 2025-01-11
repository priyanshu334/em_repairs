import 'package:em_repairs/pages/Add_Orders.dart';
import 'package:em_repairs/pages/List_page.dart';
import 'package:em_repairs/pages/ServiceCenter_Page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:em_repairs/components/custom_app_bar.dart';


class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Help & Guide",
        leadingIcon: Icons.help_outline,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome to the Help Page!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Here's how to use the application effectively:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              _buildAnimatedCard(
                title: "1. Setting Lock Code",
                content:
                    "Navigate to the Lock Code page, enter your desired code, and save it to secure your app.",
                icon: FontAwesomeIcons.lock,
              ),
              _buildAnimatedCard(
                title: "2. Creating a Pattern Lock",
                content:
                    "Navigate to the Pattern Lock page, draw your pattern, and confirm it for authentication.",
                icon: FontAwesomeIcons.key,
              ),
              _buildAnimatedCard(
                title: "3. Managing Service Center Details",
                content:
                    "Fill in the service center name, contact number, and address. Submit the details or clear the fields if necessary.",
                icon: FontAwesomeIcons.tools,
              ),
              _buildAnimatedCard(
                title: "4. Capturing Model Details",
                content:
                    "Open the Model Details dialog, capture images or upload required details, and save by clicking 'Done'.",
                icon: FontAwesomeIcons.camera,
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white54),
              const SizedBox(height: 16),
              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildModernButton(
                context: context,
                label: "Add Record",
                icon: FontAwesomeIcons.plus,
                color: Colors.teal,
                targetPage: const AddOrders(),
              ),
              _buildModernButton(
                context: context,
                label: "Service Operators",
                icon: FontAwesomeIcons.users,
                color: Colors.indigoAccent,
                targetPage: const ListPage(),
              ),
              _buildModernButton(
                context: context,
                label: "Add Service Center",
                icon: FontAwesomeIcons.building,
                color: Colors.pinkAccent,
                targetPage: const ServiceCenterPage(),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white54),
              const SizedBox(height: 16),
              const Text(
                "Need Further Assistance?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "If you have any questions or encounter issues, feel free to reach out to us through the 'Contact Us' page in the app or email support@example.com.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Back to Home",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16, color: Colors.white, ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required Widget targetPage,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetPage),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
