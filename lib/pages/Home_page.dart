import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:em_repairs/components/FilterSection.dart';
import 'package:em_repairs/components/Filter_tiggle_components.dart';
import 'package:em_repairs/components/orderList_component.dart';
import 'package:em_repairs/components/animated_floationg_button.dart';
import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/pages/help_page.dart';
import 'package:em_repairs/provider/order_provider.dart';
import 'package:em_repairs/components/Edit_page.dart';
import 'package:em_repairs/models/Order_model.dart';
import 'package:intl/intl.dart'; // Import the intl package

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool isLoading = true;
  bool showFilters = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
    });

    try {
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      debugPrint('Fetching orders from provider...');
      await orderProvider.listOrders(); // Fetch all orders asynchronously

      // Debugging fetched orders
      debugPrint('Fetched Orders: ${orderProvider.orderList}');

      if (orderProvider.orderList.isEmpty) {
        debugPrint('No orders found!');
      }
    } catch (e) {
      debugPrint('Error loading orders: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading orders: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteOrder(String orderId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Order"),
        content: const Text("Are you sure you want to delete this order?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm) {
      try {
        final orderProvider =
            Provider.of<OrderProvider>(context, listen: false);
        await orderProvider.deleteOrder(orderId); // Delete order asynchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Order deleted successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        _loadOrders(); // Reload the orders after deletion
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete order: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orderList;

    // Get the current date and format it
    final currentDate = DateTime.now();
    final formattedCurrentDate = DateFormat('dd/MM/yyyy').format(currentDate);

    // Debugging: Check if orders are null or empty
    debugPrint('Order list in build method: $orders');

    return Scaffold(
      appBar: CustomAppBar(
        title: "ORDERS",
        leadingIcon: Icons.shopping_cart,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpPage()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FilterToggle(
                    showFilters: showFilters,
                    onToggle: () {
                      setState(() {
                        showFilters = !showFilters;
                      });
                    },
                  ),
                  if (showFilters)
                    FiltersSection(
                      orders: orders,
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];

                        // Debugging: Print order data at this index
                        debugPrint('Order at index $index: $order');

                        // Access fields within optional maps
                        final customerName =
                            order.customerModel?['name'] ?? 'Not Available';

                        final orderStatus =
                            order.orderDetailsModel?['orderStatus'] ??
                                'Not Available';
                        final model = order.orderDetailsModel?['deviceModel'] ??
                            'Not Available';
                        final customerPhone =
                            order.customerModel?['phone'] ?? 'Not Available';
                        final dueDate = order.estimateModel?['pickupDate'] ?? 'Not Available';

                        // If dueDate is available and needs to be formatted
                        String formattedDueDate = dueDate;
                        if (dueDate != 'Not Available' && dueDate != null) {
                          try {
                            final parsedDueDate = DateTime.parse(dueDate);
                            formattedDueDate = DateFormat('dd/MM/yyyy').format(parsedDueDate);
                          } catch (e) {
                            debugPrint('Error formatting due date: $e');
                          }
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              customerName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Model: $model"),
                                Text("Status: $orderStatus"),
                                Text("Customer Number: $customerPhone"),
                                Text("Due Date: $formattedDueDate"), // Display formatted due date
                                Text("Current Date: $formattedCurrentDate"), // Display formatted current date
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    debugPrint(
                                        'Navigating to edit page for order ID: ${order.id}');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditOrderPage(
                                          orderId: order.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteOrder(order.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: AnimatedFloatingActionButton(),
    );
  }
}
