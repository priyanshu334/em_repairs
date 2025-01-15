import 'package:em_repairs/models/order_details_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:em_repairs/components/Device_kyc_form.dart';
import 'package:em_repairs/components/EstimateForm.dart';
import 'package:em_repairs/components/ReapairPartnerDetails.dart';
import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/components/nav_bar.dart';
import 'package:em_repairs/components/other_components/customer_details.dart';
import 'package:em_repairs/components/ReceiverDetails.dart';
import 'package:em_repairs/components/order_details_form.dart';
import 'package:em_repairs/models/DeviceKycModels.dart';
import 'package:em_repairs/models/Order_model.dart';
import 'package:em_repairs/models/receiver_model.dart';
import 'package:em_repairs/models/repair_partner_detail.dart';
import 'package:em_repairs/models/estimate_form.dart';
import 'package:em_repairs/models/customer_model.dart';
import 'package:em_repairs/provider/order_provider.dart';
import 'package:em_repairs/pages/help_page.dart';

class AddOrders extends StatefulWidget {
  const AddOrders({Key? key}) : super(key: key);

  @override
  State<AddOrders> createState() => _AddOrdersState();
}

class _AddOrdersState extends State<AddOrders> {
  int selectedIndex = 0;

  // State variables to track data from child components
  Map<String, dynamic>? _receiverDetailsModel;
  Map<String, dynamic>? _customerModel;
  Map<String, dynamic>? _orderDetailsModel;
  Map<String, dynamic>? _estimateModel;
  Map<String, dynamic>? _deviceKycModels;
  Map<String, dynamic>? _repairPartnerDetailsModel;

  bool agreeToTerms = false;

  // Callbacks for child components
  void _handleReceiverAdded(ReceiverDetailsModel details) {
    setState(() {
      debugPrint('Receiver Details: $details');
      _receiverDetailsModel = details.toMap();
    });
  }

  void _handleCustomerSelected(CustomerModel? customer) {
    setState(() {
      debugPrint('Selected Customer: $customer');
      _customerModel = customer?.toMap();
    });
  }

  void _handleEstimateAdded(EstimateModel estimate) {
    setState(() {
      debugPrint('Estimate: $estimate');
      _estimateModel = estimate.toMap();
    });
  }

  void _handleRepairPartnerDetails(RepairPartnerDetailsModel details) {
    setState(() {
      debugPrint('Repair Partner Details: $details');
      _repairPartnerDetailsModel = details.toMap();
    });
  }

  void _handleOrderDetailsAdded(OrderDetailsModel order) {
    setState(() {
      debugPrint('Order Details: $order');
      _orderDetailsModel = order.toMap();
    });
  }

  void _handleDeviceKycSaved(DeviceKycModels deviceKyc) {
    setState(() {
      debugPrint('Device KYC: $deviceKyc');
      _deviceKycModels = deviceKyc.toMap();
    });
  }

  // Handle form submission
  Future<void> _handleSubmit() async {
    if (_receiverDetailsModel != null ||
        _customerModel != null ||
        _orderDetailsModel != null ||
        _estimateModel != null ||
        _deviceKycModels != null ||
        _repairPartnerDetailsModel != null) {
      final orderId = const Uuid().v4();

      final order = OrderModel(
        
        receiverDetailsModel: _receiverDetailsModel,
        customerModel: _customerModel,
        orderDetailsModel: _orderDetailsModel,
        estimateModel: _estimateModel,
        deviceKycModels: _deviceKycModels,
        repairPartnerDetailsModel: _repairPartnerDetailsModel,
      );

      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      try {
        // Async save operation
        await orderProvider.saveOrder(order);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order submitted successfully!")),
        );

        Navigator.pop(context); // Return to the previous screen
      } catch (e) {
        debugPrint('Error saving order: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error submitting the order. Please try again.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please complete at least one section of the form."),
        ),
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
            DeviceKycForm(onDeviceKycSaved: _handleDeviceKycSaved),
            RepairPartnerDetail(onDetailsChanged: _handleRepairPartnerDetails),
            const SizedBox(height: 16),
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
