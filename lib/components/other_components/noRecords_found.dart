import 'package:flutter/material.dart';

class NoRecordsFound extends StatelessWidget {
  const NoRecordsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/ep.png',
            height: 150,
          ),
          const SizedBox(height: 20),
          const Text(
            'No records found',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}