import 'package:em_repairs/components/FilterSection.dart';
import 'package:em_repairs/pages/ServiceDetails_page.dart';
import 'package:flutter/material.dart';
import 'package:em_repairs/components/custom_app_bar.dart';
import 'package:em_repairs/pages/Add_Orders.dart';
import 'package:em_repairs/pages/List_page.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool showFilters = false; // State to toggle FiltersSection visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "ORDERS",
        leadingIcon: Icons.shopping_cart,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              // Handle help action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showFilters = !showFilters; // Toggle visibility
                });
              },
              child: AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: showFilters ? Colors.blue : Colors.black,
                ),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    const SizedBox(width: 5,),
                    Text('Filters'),
                   
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // Animated filters section
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: showFilters
                  ? FiltersSection(
                      onCustomerNameChanged: (value) {
                        // Handle customer name input
                      },
                      onOperatorChanged: (value) {
                        // Handle operator dropdown change
                      },
                      onOrderChanged: (value) {
                        // Handle order dropdown change
                      },
                      onLocationChanged: (value) {
                        // Handle location dropdown change
                      },
                      onTodayPressed: () {
                        // Handle "Today" button click
                      },
                      onSearchPressed: () {
                        // Handle "Search" button click
                      },
                    )
                  : SizedBox.shrink(),
            ),
            if (showFilters) SizedBox(height: 20),

            // No Data/Records Found Section (Conditional)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    duration: Duration(seconds: 1),
                    opacity: showFilters ? 0.5 : 1.0,
                    child: Image.asset(
                      'assets/images/background.png',
                      height: 200,
                    ),
                  ),
                  AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 300),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    child: Text('No Records Found'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Buttons with animation
      floatingActionButton: AnimatedFloatingActionButton(),
    );
  }
}

class AnimatedFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TweenAnimationBuilder(
          duration: Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: FloatingActionButton(
                heroTag: 'addOrder',
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddOrders()),
                  );
                },
                child: Icon(Icons.add),
                tooltip: 'Add Orders',
              ),
            );
          },
        ),
        SizedBox(height: 10),
        TweenAnimationBuilder(
          duration: Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: FloatingActionButton(
                heroTag: 'listPage',
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceDetailsPage(),
                    ),
                  );
                },
                child: Icon(Icons.list),
                tooltip: 'View List',
              ),
            );
          },
        ),
      ],
    );
  }
}
