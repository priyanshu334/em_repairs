import 'package:flutter/material.dart';

class CustomerModel {
  final String? id; // Nullable 'id' as Appwrite generates it
  final String name;
  final String phone;
  final String address;

  CustomerModel({
    this.id, // Nullable 'id'
    required this.name,
    required this.phone,
    required this.address,
  });

  // Convert the model to a map (for Appwrite Database operations)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
    };
  }

  // Create a model from a map (useful for parsing Appwrite's response)
  factory CustomerModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return CustomerModel(
      id: documentId, // Use the document ID from Appwrite response (nullable)
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
    );
  }

  @override
  String toString() {
    return 'CustomerModel(id: $id, name: $name, phone: $phone, address: $address)';
  }

  // CopyWith method for easier updates
  CustomerModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
