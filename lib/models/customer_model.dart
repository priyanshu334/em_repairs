class CustomerModel {
  final String? id; // ID for Appwrite document, nullable because it may not be set when creating a new customer.
  final String name;
  final String phone;
  final String address;

  CustomerModel({
    this.id, // `id` is optional since it may not be set on creation
    required this.name,
    required this.phone,
    required this.address,
  });

  // Factory constructor to create a CustomerModel from a Map (for example, fetched from Appwrite)
  factory CustomerModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CustomerModel(
      id: documentId,  // Assign the document ID from Appwrite
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
    );
  }

  // Method to convert CustomerModel to a Map for Appwrite operations
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
    };
  }
}
