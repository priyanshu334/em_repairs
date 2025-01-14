import 'package:em_repairs/models/Order_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:em_repairs/components/FilterSection.dart';
import 'package:em_repairs/components/Filter_tiggle_components.dart';
import 'package:em_repairs/components/orderList_component.dart';
import 'package:em_repairs/components/animated_floationg_button.dart';
import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/pages/Edit_page.dart';
import 'package:em_repairs/pages/help_page.dart';
import 'package:em_repairs/provider/order_provider.dart';

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
      await orderProvider.listOrders(); // Fetch all orders

    } catch (e) {
      debugPrint('Error loading orders: $e');
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
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        await orderProvider.deleteOrder(orderId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Order deleted successfully!"),
            backgroundColor: Colors.green,
          ),
        );
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
                      onCustomerNameChanged: (value) =>
                          debugPrint('Customer name: $value'),
                      onOperatorChanged: (value) =>
                          debugPrint('Operator: $value'),
                      onOrderChanged: (value) => debugPrint('Order: $value'),
                      onLocationChanged: (value) =>
                          debugPrint('Location: $value'),
                      onTodayPressed: () => debugPrint('Today pressed'),
                      onSearchPressed: () => debugPrint('Search pressed'),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        debugPrint("Order ID: ${order.id}");

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              order.customer.name ?? "Loading...",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Model: ${order.orderDetailsModel.deviceModel ?? 'Loading...'}"),
                                Text(
                                    "Status: ${order.orderDetailsModel.orderStatus ?? 'Pending'}"),
                                Text(
                                    "Customer Number: ${order.customer.phone ?? 'Loading'}"),
                                Text(
                                    "Due Date: ${order.estimate.pickupDate ?? 'Loading'}"),
                                Text(
                                    "Date: ${DateTime.now().toLocal().toString().split(' ')[0]}"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPage(
                                          orderId: order.id!,
                                          receiverId: order.receiverDetails.id,
                                          deviceId: order.orderDetailsModel.id,
                                          estimateId: order.estimate.id,
                                          repairPartnerId: order.repairPartnerDetails.id,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteOrder(order.id!),
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
