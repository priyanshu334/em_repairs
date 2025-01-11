class ServiceProviderModel {
  final String? id; // Nullable 'id'
  final String name;
  final String contactNo;
  final String description;

  ServiceProviderModel({
    this.id, // Nullable 'id'
    required this.name,
    required this.contactNo,
    required this.description,
  });

  // Convert the model to a map (for Appwrite Database operations)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'contactNo': contactNo,
      'description': description,
    };
  }

  // Create a model from a map (useful for parsing Appwrite's response)
  factory ServiceProviderModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ServiceProviderModel(
      id: documentId, // Use the document ID from Appwrite response
      name: map['name'] ?? '',
      contactNo: map['service'] ?? '',
      description: map['description'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ServiceProviderModel(id: $id, name: $name, scontactNo: $contactNo, description: $description)';
  }
}
