import 'package:em_repairs/models/service_center_model.dart';
import 'package:em_repairs/models/service_provider_model.dart';
import 'package:em_repairs/provider/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:em_repairs/models/Order_model.dart';
import 'package:em_repairs/provider/order_provider.dart';
import 'package:em_repairs/provider/service_center_provider.dart';


class FiltersSection extends StatefulWidget {
  final Function(String)? onCustomerNameChanged;
  final VoidCallback? onTodayPressed;
  final VoidCallback? onSearchPressed;
  final List<OrderModel> orders;

  const FiltersSection({
    Key? key,
    this.onCustomerNameChanged,
    this.onTodayPressed,
    this.onSearchPressed,
    required this.orders,
  }) : super(key: key);

  @override
  _FiltersSectionState createState() => _FiltersSectionState();
}

class _FiltersSectionState extends State<FiltersSection> {
  DateTime? selectedDate;
  String customerSearchQuery = "";

  ServiceCenterModel? selectedServiceCenter;
  ServiceProviderModel? selectedServiceProvider;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final serviceCenterProvider = Provider.of<ServiceCenterProvider>(context);
    final serviceProviderProvider = Provider.of<ServiceProviderProvider>(context);

    // Filter the orders based on the customerSearchQuery
    final filteredOrders = widget.orders.where((order) {
      final customerName =
          order.customerModel?['name'] ?? ''; // Ensure we are comparing valid strings
      return customerName.toLowerCase().contains(customerSearchQuery.toLowerCase());
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search TextField for Customer Name
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter Customer Name',
            suffixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: const Color.fromARGB(255, 77, 9, 9),
          ),
          onChanged: (value) {
            setState(() {
              customerSearchQuery = value;
            });

            if (widget.onCustomerNameChanged != null) {
              widget.onCustomerNameChanged!(value);
            }
          },
        ),
        SizedBox(height: 16),

        // Dropdown for selecting Service Center
        DropdownButton<ServiceCenterModel>(
          value: selectedServiceCenter,
          hint: Text('Select Service Center'),
          onChanged: (ServiceCenterModel? newValue) {
            setState(() {
              selectedServiceCenter = newValue;
            });
          },
          items: serviceCenterProvider.serviceCenters.map((serviceCenter) {
            return DropdownMenuItem<ServiceCenterModel>(
              value: serviceCenter,
              child: Text(serviceCenter.name),
            );
          }).toList(),
        ),

        SizedBox(height: 16),

        // Dropdown for selecting Service Provider
        DropdownButton<ServiceProviderModel>(
          value: selectedServiceProvider,
          hint: Text('Select Service Provider'),
          onChanged: (ServiceProviderModel? newValue) {
            setState(() {
              selectedServiceProvider = newValue;
            });
          },
          items: serviceProviderProvider.serviceProviders.map((serviceProvider) {
            return DropdownMenuItem<ServiceProviderModel>(
              value: serviceProvider,
              child: Text(serviceProvider.name),
            );
          }).toList(),
        ),

        SizedBox(height: 16),

        // Display the search results for orders
        if (customerSearchQuery.isNotEmpty)
          orderProvider.isLoading
              ? Center(child: CircularProgressIndicator())
              : filteredOrders.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text("No orders found for this customer."),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order Results for '$customerSearchQuery':",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...filteredOrders.map((order) {
                            final customerName =
                                order.customerModel?['name'] ?? 'Not Available';
                            final orderStatus =
                                order.orderDetailsModel?['orderStatus'] ??
                                    'Not Available';
                            final model = order.orderDetailsModel?['deviceModel'] ??
                                'Not Available';
                            final customerPhone =
                                order.customerModel?['phone'] ?? 'Not Available';
                            final dueDate = order.estimateModel?['pickupDate'] ??
                                'Not Available';

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(
                                  customerName,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Model: $model"),
                                    Text("Status: $orderStatus"),
                                    Text("Customer Number: $customerPhone"),
                                    Text("Due Date: $dueDate"),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        // Handle editing the order
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        // Handle deleting the order
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
      ],
    );
  }
}
