import 'dart:io';
import 'package:flutter/material.dart';

class RecordCard extends StatelessWidget {
  final Map<String, dynamic> record;

  const RecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final String? imagePath = record['imagePath'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.pink),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imagePath != null && imagePath.isNotEmpty)
                Image.file(
                  File(imagePath),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 8),
              Text('Status: ${record['status'] ?? 'Not available'}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Model: ${record['model'] ?? 'Not available'}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                'Customer Name: ${record['customerName'] ?? 'Not available'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text('Repair Type: ${record['repairType'] ?? 'Not available'}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Date: ${record['date'] ?? 'Not available'}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}