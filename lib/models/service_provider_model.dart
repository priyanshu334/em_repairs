class ServiceProviderModel {
  final String id; // Required 'id'
  final String name;
  final String contactNo;
  final String description;

  ServiceProviderModel({
    required this.id, // 'id' is now required
    required this.name,
    required this.contactNo,
    required this.description,
  });

  // Convert the model to a map (for Appwrite Database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include 'id' in the map
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
      contactNo: map['contactNo'] ?? '', // Fixed the key to 'contactNo'
      description: map['description'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ServiceProviderModel(id: $id, name: $name, contactNo: $contactNo, description: $description)';
  }

  // CopyWith method for creating modified copies
  ServiceProviderModel copyWith({
    String? id,
    String? name,
    String? contactNo,
    String? description,
  }) {
    return ServiceProviderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contactNo: contactNo ?? this.contactNo,
      description: description ?? this.description,
    );
  }
}
