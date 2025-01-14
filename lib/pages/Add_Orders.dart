import 'package:em_repairs/provider/order_provider.dart';
import 'package:em_repairs/provider/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Import UUID
import 'package:provider/provider.dart'; // For state management
import 'package:em_repairs/models/order_model.dart'; // Import your OrderModel
import 'package:em_repairs/services/apwrite_service.dart'; // Appwrite Service
import 'package:em_repairs/components/Device_kyc_form.dart';
import 'package:em_repairs/components/EstimateForm.dart';
import 'package:em_repairs/components/ReapairPartnerDetails.dart';
import 'package:em_repairs/components/ReceiverDetails.dart';
import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/components/nav_bar.dart';
import 'package:em_repairs/components/order_details_form.dart';
import 'package:em_repairs/components/other_components/customer_details.dart';
import 'package:em_repairs/pages/help_page.dart';

class AddOrders extends StatefulWidget {
  const AddOrders({Key? key}) : super(key: key);

  @override
  State<AddOrders> createState() => _AddOrdersState();
}

class _AddOrdersState extends State<AddOrders> {
  int selectedIndex = 0;

  // State variables to track data from child components
  String? receiverId;
  String? orderId;
  String? estimateId;
  String? deviceId;
  String? selectedCustomerId;
  String? repairPartnerId;
  bool agreeToTerms = false;

  // TextControllers for CustomerDetails
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Bottom Navigation
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Callbacks for child components
  void _handleReceiverAdded(String id) {
    setState(() {
      receiverId = id;
    });
    print("Receiver ID: $receiverId");
  }

  void _handleCustomerSelected(String? customerId) {
    setState(() {
      selectedCustomerId = customerId;
    });
    print("Selected Customer ID: $selectedCustomerId");
  }

  void _handleOrderAdded(String id) {
    setState(() {
      orderId = id;
    });
    print("Order ID: $orderId");
  }

  void _handleEstimateAdded(String id) {
    setState(() {
      estimateId = id;
    });
    print("Estimate ID: $estimateId");
  }

  void _handleDeviceIdGenerated(String id) {
    setState(() {
      deviceId = id;
    });
    print("Device ID: $deviceId");
  }

  void _handleRepairPartnerDetails(String id) {
    setState(() {
      repairPartnerId = id;
    });
    print("Repair Partner ID: $repairPartnerId");
  }

  // Submit action with UUID generation
  void _handleSubmit() async {
    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms and conditions')),
      );
      return;
    }

    if (receiverId == null ||
        selectedCustomerId == null ||
        orderId == null ||
        estimateId == null ||
        deviceId == null ||
        repairPartnerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required steps')),
      );
      return;
    }

    // Generate a unique ID using UUID
    final uuid = Uuid().v4();

    // Create OrderModel
    final order = OrderModel(
      id: uuid, // Use the generated UUID here
      receiverId: receiverId!,
      customerId: selectedCustomerId!,
      orderId: orderId!,
      estimateId: estimateId!,
      deviceId: deviceId!,
      repairPartnerId: repairPartnerId!,
    );

    // Save order using the provider
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    try {
      await orderProvider.saveOrder(order);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add Orders",
        leadingIcon: Icons.add_shopping_cart,
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
            ReceiverDetails(onReceiverAdded: _handleReceiverAdded),
            CustomerDetails(
              searchController: _searchController,
              nameController: _nameController,
              phoneController: _phoneController,
              addressController: _addressController,
              onCustomerSelected: _handleCustomerSelected, // Callback for customer selection
            ),
            OrderDetails(onOrderAdded: _handleOrderAdded),
            EstimateForm(onEstimateAdded: _handleEstimateAdded),
            DeviceKycForm(onDeviceIdGenerated: _handleDeviceIdGenerated),
            RepairPartnerDetails(onDetailsChanged: _handleRepairPartnerDetails),
            
            const SizedBox(height: 16),
            // Terms and Conditions Checkbox
            Row(
              children: [
                Checkbox(
                  value: agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      agreeToTerms = value!;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    "Do you agree to the terms and conditions?",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            // Submit Button
            if (agreeToTerms)
              ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text("Submit"),
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
