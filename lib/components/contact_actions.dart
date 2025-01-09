import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactActions extends StatelessWidget {
  // Function to launch phone dialer
  void _launchPhone() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '1234567890'); // Phone number to dial
    if (!await launchUrl(phoneUri)) {
      throw 'Could not launch $phoneUri';
    }
  }

  // Function to launch WhatsApp
  void _launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse('https://wa.me/1234567890'); // WhatsApp link
    if (!await launchUrl(whatsappUri)) {
      throw 'Could not launch $whatsappUri';
    }
  }

  // Function to launch SMS
  void _launchSMS() async {
    final Uri messageUri = Uri(scheme: 'sms', path: '1234567890'); // Phone number for SMS
    if (!await launchUrl(messageUri)) {
      throw 'Could not launch $messageUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
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
            onTap: _launchPhone,
          ),
          _buildNavItem(
            context,
            icon: Icons.message,
            label: 'Message',
            onTap: _launchSMS,
          ),
          _buildNavItem(
            context,
            icon: FontAwesomeIcons.whatsapp,
            label: 'WhatsApp',
            onTap: _launchWhatsApp,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.teal.shade300,
              size: 28,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.teal.shade300,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
