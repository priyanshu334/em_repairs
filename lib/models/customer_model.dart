  import 'package:flutter/material.dart';

  class CustomerModel {
    final String id; // 'id' is now required and non-nullable
    final String name;
    final String phone;
    final String address;

    CustomerModel({
      required this.id, // 'id' is now required
      required this.name,
      required this.phone,
      required this.address,
    });

    // Convert the model to a map (for database operations)
    Map<String, dynamic> toMap() {
      return {
        'id': id, // Include 'id' in the map if needed for updates
        'name': name,
        'phone': phone,
        'address': address,
      };
    }

    // Create a model from a map
    factory CustomerModel.fromMap(Map<String, dynamic> map, {required String documentId}) {
      return CustomerModel(
        id: documentId, // 'id' is now required
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
