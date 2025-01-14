class ServiceCenterModel {
  final String id;  // Required 'id'
  final String name;
  final String contactNumber;
  final String address;

  ServiceCenterModel({
    required this.id,  // 'id' is now required
    required this.name,
    required this.contactNumber,
    required this.address,
  });

  // Convert the model to a map (for Appwrite Database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include 'id' in the map
      'name': name,
      'contactNumber': contactNumber,
      'address': address,
    };
  }

  // Create a model from a map (useful for parsing Appwrite's response)
  factory ServiceCenterModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ServiceCenterModel(
      id: documentId,  // Use the document ID from Appwrite response
      name: map['name'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      address: map['address'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ServiceCenterModel(id: $id, name: $name, contactNumber: $contactNumber, address: $address)';
  }

  // CopyWith method for creating modified copies
  ServiceCenterModel copyWith({
    String? id,
    String? name,
    String? contactNumber,
    String? address,
  }) {
    return ServiceCenterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contactNumber: contactNumber ?? this.contactNumber,
      address: address ?? this.address,
    );
  }
}
