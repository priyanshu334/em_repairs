class ServiceCenterModel {
  final String? id;  // Make 'id' nullable
  final String name;
  final String contactNumber;
  final String address;

  ServiceCenterModel({
    this.id,  // Now 'id' can be nullable
    required this.name,
    required this.contactNumber,
    required this.address,
  });

  // Convert the model to a map (for Appwrite Database operations)
  Map<String, dynamic> toMap() {
    return {
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
}
