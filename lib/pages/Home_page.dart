import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:em_repairs/components/FilterSection.dart';
import 'package:em_repairs/components/Filter_tiggle_components.dart';
import 'package:em_repairs/components/orderList_component.dart';
import 'package:em_repairs/components/animated_floationg_button.dart';
import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/models/customer_model.dart';
import 'package:em_repairs/models/estimate_form.dart';
import 'package:em_repairs/models/order_details_models.dart';
import 'package:em_repairs/models/order_model.dart';
import 'package:em_repairs/pages/Edit_page.dart';
import 'package:em_repairs/pages/help_page.dart';
import 'package:em_repairs/provider/customer_provider.dart';
import 'package:em_repairs/provider/estimate_provider.dart';
import 'package:em_repairs/provider/order_details_provider.dart';
import 'package:em_repairs/provider/order_provider.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool isLoading = true;
  bool showFilters = false;
  late List<OrderModel> orders = [];
  Map<String, CustomerModel?> customerCache = {};
  Map<String, OrderDetailsModel?> orderDetailsCache = {};
  Map<String, EstimateModel?> estimateDetailsCache = {};

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
      final orders = orderProvider.orderList;
      debugPrint('Orders:$orders');

      for (var order in orders) {
        if (!customerCache.containsKey(order.customerId)) {
          final customer =
              await Provider.of<CustomerProvider>(context, listen: false)
                  .fetchCustomerById(order.customerId!);
          customerCache[order.customerId!] = customer;
        }
        if (!orderDetailsCache.containsKey(order.deviceId)) {
          final orderDetail =
              await Provider.of<OrderDetailsProvider>(context, listen: false)
                  .getOrderDetailById(order.deviceId!);
          orderDetailsCache[order.deviceId!] = orderDetail;
        }
        if (!estimateDetailsCache.containsKey(order.estimateId)) {
          final estimate =
              await Provider.of<EstimateProvider>(context, listen: false)
                  .getEstimateById(order.estimateId!);
          estimateDetailsCache[order.estimateId!] = estimate;
        }
      }
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
        await Provider.of<OrderProvider>(context, listen: false)
            .deleteOrder(orderId);
        setState(() {
          orders.removeWhere((order) => order.id == orderId);
        });
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
                        debugPrint("Customer ID: ${order.customerId}");
                        debugPrint("Device ID: ${order.deviceId}");
                        debugPrint("Estimate ID: ${order.estimateId}");

                        final customer = customerCache[order.customerId];
                        final orderDetail = orderDetailsCache[order.deviceId];
                        final estimate = estimateDetailsCache[order.estimateId];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              customer?.name ?? "Loading...",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Model: ${orderDetail?.deviceModel ?? 'Loading...'}"),
                                Text(
                                    "Status: ${orderDetail?.orderStatus ?? 'Pending'}"),
                                Text(
                                    "Customer Number: ${customer?.phone ?? 'Loading'}"),
                                Text(
                                    "Due Date: ${estimate?.pickupDate ?? 'Loading'}"),
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
                                          orderId: order.id,
                                          receiverId: order.receiverId,
                                          deviceId: order.deviceId,
                                          estimateId: order.estimateId,
                                          repairPartnerId:
                                              order.repairPartnerId,
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
