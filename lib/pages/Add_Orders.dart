import 'package:em_repairs/components/ReapairPartnerDetails.dart';
import 'package:flutter/material.dart';
import 'package:em_repairs/components/Device_kyc_form.dart';
import 'package:em_repairs/components/EstimateForm.dart';
// Import RepairPartnerDetails
import 'package:em_repairs/components/ReceiverDetails.dart';
import 'package:em_repairs/components/nav_bar.dart';
import 'package:em_repairs/components/order_details_form.dart';
import 'package:em_repairs/components/other_components/customer_details.dart';
import 'package:em_repairs/components/custom_app_bar.dart'; // Import the custom AppBar
import 'package:em_repairs/pages/help_page.dart';

class AddOrders extends StatefulWidget {
  const AddOrders({super.key});

  @override
  State<AddOrders> createState() => _AddOrdersState();
}

class _AddOrdersState extends State<AddOrders> {
  int selectedIndex = 0;
  bool isTermsAccepted = false; // State for checkbox

  final TextEditingController searchController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController deviceModelController = TextEditingController();
  final TextEditingController problemController = TextEditingController();

  // Variables to hold the receiver's data
  String receiverName = '';
  bool isOwner = false;
  bool isStaff = false;

  // Variables for EstimateForm
  String repairCost = '';
  String advancePaid = '';
  DateTime? pickupDate;
  TimeOfDay? pickupTime;

  // Variables for RepairPartnerDetails
  bool isInHouse = false;
  bool isServiceCenter = false;
  String? selectedServiceCenter;
  String? selectedOperator;

  // List of order status options
  final List<String> orderStatusOptions = ['Pending', 'In Progress', 'Completed'];

  // Function to handle data received from ReceiverDetailsForm
  void handleReceiverDetails(String name, bool isOwnerValue, bool isStaffValue) {
    setState(() {
      receiverName = name;
      isOwner = isOwnerValue;
      isStaff = isStaffValue;
    });
    print("Receiver Details: Name = $receiverName, Is Owner = $isOwner, Is Staff = $isStaff");
  }

  // Function to handle data received from OrderDetailsForm
  void handleOrderDetails(String deviceModel, List<String> problems, String? orderStatus) {
    print("Order Details: Device Model = $deviceModel, Problems = $problems, Order Status = $orderStatus");
  }

  // Function to handle data received from DeviceKycForm
  void handleDeviceKycData(
    bool powerAdapterChecked,
    bool keyboardChecked,
    bool mouseChecked,
    bool warrantyChecked,
    String accessories,
    String details,
    DateTime? warrantyDate,
    List<int>? lockCode,
    List<int>? patternCode,
  ) {
    print("Device KYC Data: Power Adapter = $powerAdapterChecked, Keyboard = $keyboardChecked, Mouse = $mouseChecked");
    print("Accessories = $accessories, Details = $details, Warranty Date = $warrantyDate");
    print("Lock Code = $lockCode, Pattern Code = $patternCode");
  }

  // Function to handle data received from EstimateForm
  void handleEstimateFormChange({
    required String repairCost,
    required String advancePaid,
    required DateTime? pickupDate,
    required TimeOfDay? pickupTime,
  }) {
    setState(() {
      this.repairCost = repairCost;
      this.advancePaid = advancePaid;
      this.pickupDate = pickupDate;
      this.pickupTime = pickupTime;
    });
    print("Estimate Form Updated: Repair Cost: $repairCost, Advance Paid: $advancePaid, Pickup Date: $pickupDate, Pickup Time: $pickupTime");
  }

  // Function to handle data received from RepairPartnerDetails
  void handleRepairPartnerDetails({
    required bool isInHouse,
    required bool isServiceCenter,
    String? selectedServiceCenter,
    String? selectedOperator,
    DateTime? pickupDate,
    TimeOfDay? pickupTime,
  }) {
    setState(() {
      this.isInHouse = isInHouse;
      this.isServiceCenter = isServiceCenter;
      this.selectedServiceCenter = selectedServiceCenter;
      this.selectedOperator = selectedOperator;
      this.pickupDate = pickupDate;
      this.pickupTime = pickupTime;
    });
    print("Repair Partner Details: InHouse = $isInHouse, ServiceCenter = $isServiceCenter, Selected Service Center = $selectedServiceCenter, Selected Operator = $selectedOperator, Pickup Date = $pickupDate, Pickup Time = $pickupTime");
  }

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
    deviceModelController.dispose();
    problemController.dispose();
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ReceiverDetailsForm(onDataChanged: handleReceiverDetails),
                  CustomerDetails(
                    nameController: nameController,
                    phoneController: phoneController,
                    addressController: addressController,
                  ),
                  OrderDetailsForm(
                    deviceModelController: deviceModelController,
                    problemController: problemController,
                    onOrderDetailsChanged: handleOrderDetails,
                    orderStatusOptions: orderStatusOptions,
                  ),
                  DeviceKycForm(
                    onFormSubmit: handleDeviceKycData, // Passing the callback here
                  ),
                  EstimateForm(
                    onFormChange: handleEstimateFormChange, // Passing the callback here
                  ),
                  RepairPartnerDetails(onDetailsChanged: handleRepairPartnerDetails) // Integrating RepairPartnerDetails
                ],
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Checkbox(
                  value: isTermsAccepted,
                  onChanged: (value) {
                    setState(() {
                      isTermsAccepted = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    "I agree to the Terms and Conditions",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          if (isTermsAccepted)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  print("Order Submitted with Receiver Name: $receiverName, Is Owner: $isOwner, Is Staff: $isStaff");
                  print("Repair Cost: $repairCost, Advance Paid: $advancePaid, Pickup Date: $pickupDate, Pickup Time: $pickupTime");
                  print("Repair Partner Details: InHouse = $isInHouse, ServiceCenter = $isServiceCenter, Selected Service Center = $selectedServiceCenter, Selected Operator = $selectedOperator");
                  // Add the logic to submit the order to your database or API
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Submit Order",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
