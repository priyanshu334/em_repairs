import 'package:em_repairs/components/Device_kyc_form.dart';
import 'package:em_repairs/components/EstimateForm.dart';
import 'package:em_repairs/components/ReapairPartnerDetails.dart';
import 'package:em_repairs/components/ReceiverDetails.dart';
import 'package:em_repairs/components/nav_bar.dart';
import 'package:em_repairs/components/order_details_form.dart';
import 'package:em_repairs/components/other_components/customer_details.dart';

import 'package:em_repairs/components/custom_app_bar.dart'; // Import the custom AppBar
import 'package:flutter/material.dart';

class AddOrders extends StatefulWidget {
  const AddOrders({super.key});

  @override
  State<AddOrders> createState() => _AddOrdersState();
}

class _AddOrdersState extends State<AddOrders> {
  int selectedIndex = 0;

  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Orders",
        leadingIcon: Icons.add_shopping_cart,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              // Handle help action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReceiverDetails(),
            CustomerDetails(
              searchController: searchController,
              nameController: nameController,
              phoneController: phoneController,
              addressController: addressController,
            ),
            OrderDetailsForm(),
            DeviceKycForm(),
        
            EstimateForm(),
            RepairPartnerDetails(),
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
