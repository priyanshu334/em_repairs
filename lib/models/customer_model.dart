class CustomerModel {
  final String? id; // Nullable, as Appwrite generates it
  final String name;
  final String phone;
  final String address;

  CustomerModel({
    this.id, // Nullable, as Appwrite generates it
    required this.name,
    required this.phone,
    required this.address,
  });

  /// Factory constructor to create a `CustomerModel` from a Map (e.g., fetched from Appwrite)
  factory CustomerModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return CustomerModel(
      id: documentId ?? map['\$id'], // Assign ID from Appwrite's document ID or map
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
    );
  }

  /// Converts the `CustomerModel` instance to a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
    };
  }

  @override
  String toString() {
    return 'CustomerModel(id: $id, name: $name, phone: $phone, address: $address)';
  }

  /// Helper method to create a copy of the instance with updated fields
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
