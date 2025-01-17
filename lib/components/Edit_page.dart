import 'package:em_repairs/components/edit_components/device_kyc_edit.dart';
import 'package:em_repairs/components/edit_components/estimate_form.dart';
import 'package:em_repairs/components/edit_components/repair_partner_details_edit.dart';
import 'package:em_repairs/components/edit_components/receiver_details_edit.dart';
import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/components/edit_components/order_details_edit.dart';
import 'package:em_repairs/components/edit_components/customer_details_edit.dart';
import 'package:em_repairs/models/customer_model.dart';
import 'package:em_repairs/models/estimate_form.dart';
import 'package:em_repairs/models/order_details_models.dart';
import 'package:em_repairs/models/receiver_model.dart';
import 'package:em_repairs/models/repair_partner_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:em_repairs/models/Order_model.dart';
// Update imports
import 'package:em_repairs/models/DeviceKycModels.dart';


import 'package:em_repairs/provider/order_provider.dart';

class EditOrderPage extends StatefulWidget {
  final String orderId;

  const EditOrderPage({Key? key, required this.orderId}) : super(key: key);

  @override
  _EditOrderPageState createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> {
  int selectedIndex = 0;

  // State variables to track data from child components
  Map<String, dynamic>? _receiverDetailsModel;
  Map<String, dynamic>? _customerModel;
  Map<String, dynamic>? _orderDetailsModel;
  Map<String, dynamic>? _estimateModel;
  Map<String, dynamic>? _deviceKycModels;
  Map<String, dynamic>? _repairPartnerDetailsModel;

  bool isLoading = false;
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
      final orderId = widget.orderId; // Use the passed orderId to update the order

      final updatedOrder = OrderModel(
        id: widget.orderId,
        receiverDetailsModel: _receiverDetailsModel,
        customerModel: _customerModel,
        orderDetailsModel: _orderDetailsModel,
        estimateModel: _estimateModel,
        deviceKycModels: _deviceKycModels,
        repairPartnerDetailsModel: _repairPartnerDetailsModel,
      );

      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      try {
        await orderProvider.updateOrder(orderId, updatedOrder);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order updated successfully!")),
        );

        Navigator.pop(context); // Return to the previous screen
      } catch (e) {
        debugPrint('Error saving order: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error updating the order. Please try again.")),
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
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() async {
    setState(() {
      isLoading = true;
    });

    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final order = await orderProvider.getOrderById(widget.orderId);

      setState(() {
        _receiverDetailsModel = order.receiverDetailsModel;
        _customerModel = order.customerModel;
        _orderDetailsModel = order.orderDetailsModel;
        _estimateModel = order.estimateModel;
        _deviceKycModels = order.deviceKycModels;
        _repairPartnerDetailsModel = order.repairPartnerDetailsModel;

      });
    } catch (e) {
      debugPrint('Error initializing fields: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading order details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit order",  
        leadingIcon: Icons.edit,
        actions: [
          
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  ReceiverDetails(onReceiverAdded: _handleReceiverAdded,existingReceiver: ReceiverDetailsModel.fromMap(_receiverDetailsModel! ,documentId: _receiverDetailsModel?['id'],) ),
                  CustomerDetails(onCustomerSelected: _handleCustomerSelected,),
                  OrderDetailsForm(onOrderAdded: _handleOrderDetailsAdded,existingOrder: OrderDetailsModel.fromMap(_orderDetailsModel!,documentId: _orderDetailsModel?['id'],)),

  // ),),

                  EstimateForm(onEstimateAdded: _handleEstimateAdded,existingEstimate: EstimateModel.fromMap(_estimateModel!,documentId: _estimateModel?['id'], ),),
                  DeviceKycForm(onDeviceKycSaved: _handleDeviceKycSaved , deviceKycModel: DeviceKycModels.fromMap(_deviceKycModels!),),
                  RepairPartnerDetail(onDetailsChanged: _handleRepairPartnerDetails,existingDetails: RepairPartnerDetailsModel.fromMap(_repairPartnerDetailsModel!,documentId: _repairPartnerDetailsModel?['id'],),),
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
                      child: const Text("Save Changes"),
                    ),
                ],
              ),
            ),
    );
  }
}
