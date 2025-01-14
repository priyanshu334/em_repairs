import 'package:em_repairs/pages/Add_Orders.dart';
import 'package:em_repairs/pages/ServiceDetails_page.dart';
import 'package:flutter/material.dart';


class AnimatedFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: FloatingActionButton(
                heroTag: 'addOrder',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AddOrders()));
                },
                child: const Icon(Icons.add),
                tooltip: 'Add Orders',
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: FloatingActionButton(
                heroTag: 'listPage',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceDetailsPage()));
                },
                child: const Icon(Icons.list),
                tooltip: 'View List',
              ),
            );
          },
        ),
      ],
    );
  }
}
