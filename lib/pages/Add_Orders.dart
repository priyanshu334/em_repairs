import 'package:em_repairs/components/Device_kyc_form.dart';
import 'package:em_repairs/components/ReapairPartnerDetails.dart';
import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/components/edit_components/repair_partner_details.dart';
import 'package:em_repairs/components/nav_bar.dart';
import 'package:em_repairs/components/other_components/customer_details.dart';
import 'package:em_repairs/models/DeviceKycModels.dart';
import 'package:em_repairs/models/device_kyc_model.dart';
import 'package:em_repairs/models/receiver_model.dart';
import 'package:em_repairs/models/repair_partner_detail.dart';
import 'package:em_repairs/pages/help_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:em_repairs/components/EstimateForm.dart';
import 'package:em_repairs/components/ReceiverDetails.dart';
import 'package:em_repairs/components/order_details_form.dart';
import 'package:em_repairs/models/Order_model.dart';
import 'package:em_repairs/models/order_details_models.dart';
import 'package:em_repairs/models/estimate_form.dart';
import 'package:em_repairs/models/customer_model.dart';
import 'package:em_repairs/provider/order_provider.dart';

class AddOrders extends StatefulWidget {
  const AddOrders({Key? key}) : super(key: key);

  @override
  State<AddOrders> createState() => _AddOrdersState();
}

class _AddOrdersState extends State<AddOrders> {
  int selectedIndex = 0;

  // State variables to track data from child components
  ReceiverDetailsModel? _receiverDetails;
  CustomerModel? _selectedCustomer;
  EstimateModel? _estimate;
  RepairPartnerDetailsModel? _repairPartnerDetails;
  OrderDetailsModel? _orderDetails;
  DeviceKycModels? _deviceKyc;  // Track DeviceKycModel

  bool agreeToTerms = false;

  // Callbacks for child components
  void _handleReceiverAdded(ReceiverDetailsModel details) {
    setState(() {
      _receiverDetails = details;
    });
  }

  void _handleCustomerSelected(CustomerModel? customer) {
    setState(() {
      _selectedCustomer = customer;
    });
  }

  void _handleEstimateAdded(EstimateModel estimate) {
    setState(() {
      _estimate = estimate;
    });
  }

  void _handleRepairPartnerDetails(RepairPartnerDetailsModel details) {
    setState(() {
      _repairPartnerDetails = details;
    });
  }

  void _handleOrderDetailsAdded(OrderDetailsModel order) {
    setState(() {
      _orderDetails = order;
    });
  }

  // Device KYC saved callback
  void _handleDeviceKycSaved(DeviceKycModels? deviceKyc) {
    setState(() {
      _deviceKyc = deviceKyc;
    });
  }

  // Handle form submission
  void _handleSubmit() {
    if (_receiverDetails != null &&
        _selectedCustomer != null &&
        _estimate != null &&
        _repairPartnerDetails != null &&
        _orderDetails != null &&
        _deviceKyc != null) {
      final orderId = const Uuid().v4();

      final order = OrderModel(
   
        receiverDetails: _receiverDetails!,
        customer: _selectedCustomer!,
        orderDetailsModel: _orderDetails!,
        estimate: _estimate!,
        deviceKyc: _deviceKyc!, // Include device KYC data
        repairPartnerDetails: _repairPartnerDetails!,
      );

      // Save the order using the provider
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      orderProvider.saveOrder(order);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order submitted successfully!")),
      );

      Navigator.pop(context); // Return to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields.")),
      );
    }
  }

  // Bottom navigation callback
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
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
            CustomerDetails(onCustomerSelected: _handleCustomerSelected),
            OrderDetailsForm(onOrderAdded: _handleOrderDetailsAdded),
            EstimateForm(onEstimateAdded: _handleEstimateAdded),
            DeviceKycForm(onKycSaved: _handleDeviceKycSaved), // Pass callback to DeviceKycForm
            RepairPartnerDetail(onDetailsChanged: _handleRepairPartnerDetails),
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
