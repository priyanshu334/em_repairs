import 'package:flutter/material.dart';

import 'package:em_repairs/components/Device_kyc_form.dart';
import 'package:em_repairs/components/edit_components/estimate_component.dart';
import 'package:em_repairs/components/edit_components/receiver_details.dart';
import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/components/nav_bar.dart';
import 'package:em_repairs/components/edit_components/order_details.dart';
import 'package:em_repairs/components/other_components/customer_details.dart';
import 'package:em_repairs/pages/help_page.dart';
import 'package:em_repairs/components/edit_components/repair_partner_details.dart';

class EditPage extends StatefulWidget {
   final String orderId;
  final String? receiverId;
  final String? deviceId;
  final String? estimateId;
  final String? repairPartnerId;

  EditPage({
    required this.orderId,
    this.receiverId,
    this.deviceId,
    this.estimateId,
    this.repairPartnerId,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  int selectedIndex = 0;

  // Bottom Navigation
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit Order",
        leadingIcon: Icons.edit,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Receiver Details Section
            ReceiverDetails(receiverId: widget.receiverId),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Receiver Details (Editable)",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            // Customer Details Section
        

            // Order Details Section
            OrderDetails(orderId: widget.orderId),

            // Estimate Form Section
            EstimateForm(estimateId: widget.estimateId),

            // Device KYC Section
           
            // Repair Partner Details Section
            RepairPartnerDetails(repairPartnerId: widget.repairPartnerId),

            const SizedBox(height: 16),

            // Terms and Conditions Checkbox
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: null,
                ),
                const Expanded(
                  child: Text(
                    "Do you agree to the terms and conditions?",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            // Update Button
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text("Update"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
