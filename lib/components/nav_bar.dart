import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';  // Added import
import 'package:em_repairs/provider/customer_provider.dart';  // Added import

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  // Function to launch different apps based on index
  void _launchApp(BuildContext context, int index) async {
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    final customer = customerProvider.selectedCustomer;

    if (customer == null) {
      // Show an error message if no customer is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No customer selected')),
      );
      return;
    }

    final String phoneNumber = customer.phone; // Get the phone number from the selected customer

    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber); // Phone number to dial
    final Uri messageUri = Uri(scheme: 'sms', path: phoneNumber); // Phone number for SMS
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber'); // WhatsApp link
    final Uri printUri = Uri.parse('https://example.com'); // Placeholder for Printout

    try {
      switch (index) {
        case 0: // Phone
          if (!await launchUrl(phoneUri)) {
            throw 'Could not launch $phoneUri';
          }
          break;
        case 1: // Message
          if (!await launchUrl(messageUri)) {
            throw 'Could not launch $messageUri';
          }
          break;
        case 2: // WhatsApp
          if (!await launchUrl(whatsappUri)) {
            throw 'Could not launch $whatsappUri';
          }
          break;
        case 3: // Printout
          if (!await launchUrl(printUri)) {
            throw 'Could not launch $printUri';
          }
          break;
        default:
          break;
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8), // Reduce the margin
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduce padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8, // Reduced blur radius for a more compact effect
            spreadRadius: 3, // Reduced spread radius
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            context,
            icon: Icons.phone,
            label: 'Phone',
            isSelected: selectedIndex == 0,
            index: 0,
          ),
          _buildNavItem(
            context,
            icon: Icons.message,
            label: 'Message',
            isSelected: selectedIndex == 1,
            index: 1,
          ),
          _buildNavItem(
            context,
            icon: FontAwesomeIcons.whatsapp,
            label: 'WhatsApp',
            isSelected: selectedIndex == 2,
            index: 2,
          ),
          _buildNavItem(
            context,
            icon: Icons.print,
            label: 'Printout',
            isSelected: selectedIndex == 3,
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        _launchApp(context, index); // Pass context to the _launchApp function
        onItemTapped(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reduced padding
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.shade700 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.teal.shade300,
              size: 24, // Reduced icon size
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12, // Reduced text size
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
