class ReceiverDetailsModel {
  final String? id; // Nullable 'id'
  final String name;
  final bool isOwner;
  final bool isStaff;

  ReceiverDetailsModel({
    this.id, // Nullable 'id'
    required this.name,
    this.isOwner = false,
    this.isStaff = false,
  });

  // Convert the model to a map (for Appwrite Database operations)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isOwner': isOwner,
      'isStaff': isStaff,
    };
  }

  // Create a model from a map (useful for parsing Appwrite's response)
  factory ReceiverDetailsModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ReceiverDetailsModel(
      id: documentId, // Use the document ID from Appwrite response
      name: map['name'] ?? '',
      isOwner: map['isOwner'] ?? false,
      isStaff: map['isStaff'] ?? false,
    );
  }

  @override
  String toString() {
    return 'ReceiverDetailsModel(id: $id, name: $name, isOwner: $isOwner, isStaff: $isStaff)';
  }
}
