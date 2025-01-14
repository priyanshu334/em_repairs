import 'package:em_repairs/components/animated_floationg_button.dart';
import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/models/order_model.dart';
import 'package:em_repairs/pages/Edit_page.dart';
import 'package:em_repairs/pages/help_page.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool isLoading = true;
  late List<OrderModel> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  // Load orders using mock data with realistic IDs
  Future<void> _loadOrders() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Mock data for orders using the OrderModel with realistic values
      orders = [
        OrderModel(
          id: 'ORD001',
          customerId: 'CUST-101',
          deviceId: 'DEV-ABC123',
          repairPartnerId: 'RP-001',
          receiverId: 'RCV-201',
          estimateId: 'EST-1001',
          orderId: 'ORD-1001',
        ),
        OrderModel(
          id: 'ORD002',
          customerId: 'CUST-102',
          deviceId: 'DEV-XYZ456',
          repairPartnerId: 'RP-002',
          receiverId: 'RCV-202',
          estimateId: 'EST-1002',
          orderId: 'ORD-1002',
        ),
        OrderModel(
          id: 'ORD003',
          customerId: 'CUST-103',
          deviceId: 'DEV-PQR789',
          repairPartnerId: 'RP-003',
          receiverId: 'RCV-203',
          estimateId: 'EST-1003',
          orderId: 'ORD-1003',
        ),
        OrderModel(
          id: 'ORD004',
          customerId: 'CUST-104',
          deviceId: 'DEV-MNO321',
          repairPartnerId: 'RP-004',
          receiverId: 'RCV-204',
          estimateId: 'EST-1004',
          orderId: 'ORD-1004',
        ),
        OrderModel(
          id: 'ORD005',
          customerId: 'CUST-105',
          deviceId: 'DEV-STU654',
          repairPartnerId: 'RP-005',
          receiverId: 'RCV-205',
          estimateId: 'EST-1005',
          orderId: 'ORD-1005',
        ),
        OrderModel(
          id: 'ORD006',
          customerId: 'CUST-106',
          deviceId: 'DEV-VWX987',
          repairPartnerId: 'RP-006',
          receiverId: 'RCV-206',
          estimateId: 'EST-1006',
          orderId: 'ORD-1006',
        ),
        OrderModel(
          id: 'ORD007',
          customerId: 'CUST-107',
          deviceId: 'DEV-DEF654',
          repairPartnerId: 'RP-007',
          receiverId: 'RCV-207',
          estimateId: 'EST-1007',
          orderId: 'ORD-1007',
        ),
        OrderModel(
          id: 'ORD008',
          customerId: 'CUST-108',
          deviceId: 'DEV-GHI543',
          repairPartnerId: 'RP-008',
          receiverId: 'RCV-208',
          estimateId: 'EST-1008',
          orderId: 'ORD-1008',
        ),
        OrderModel(
          id: 'ORD009',
          customerId: 'CUST-109',
          deviceId: 'DEV-JKL432',
          repairPartnerId: 'RP-009',
          receiverId: 'RCV-209',
          estimateId: 'EST-1009',
          orderId: 'ORD-1009',
        ),
        OrderModel(
          id: 'ORD010',
          customerId: 'CUST-110',
          deviceId: 'DEV-MNO123',
          repairPartnerId: 'RP-010',
          receiverId: 'RCV-210',
          estimateId: 'EST-1010',
          orderId: 'ORD-1010',
        ),
      ];
    } catch (e) {
      debugPrint('Error loading orders: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Delete an order
  Future<void> _deleteOrder(String orderId) async {
    try {
      setState(() {
        orders.removeWhere((order) => order.id == orderId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order deleted successfully')),
      );
    } catch (e) {
      debugPrint('Error deleting order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete order')),
      );
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
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Order: ${order.orderId}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer: ${order.customerId}'),
                          Text('Device: ${order.deviceId}'),
                          Text('Repair Partner: ${order.repairPartnerId}'),
                          Text('Receiver: ${order.receiverId}'),
                          Text('Estimate ID: ${order.estimateId}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPage(
                                    orderId: order.id,
                                    receiverId: order.receiverId ?? 'Default Receiver',
                                    deviceId: order.deviceId ?? 'Default Device',
                                    estimateId: order.estimateId ?? 'Default Estimate',
                                    repairPartnerId: order.repairPartnerId ?? 'Default Repair Partner',
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Delete Order'),
                                  content: Text('Are you sure you want to delete this order?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () => Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () => Navigator.of(context).pop(true),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await _deleteOrder(order.id);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: AnimatedFloatingActionButton(),
    );
  }
}
