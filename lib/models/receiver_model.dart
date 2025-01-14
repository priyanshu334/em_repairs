class ReceiverDetailsModel {
  final String? id; // 'id' is now optional
  final String name;
  final bool isOwner;
  final bool isStaff;

  ReceiverDetailsModel({
    this.id, // 'id' is now optional
    required this.name,
    this.isOwner = false,
    this.isStaff = false,
  });

  // Convert the model to a map (for Appwrite Database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include 'id' in the map, even if null
      'name': name,
      'isOwner': isOwner,
      'isStaff': isStaff,
    };
  }

  // Create a model from a map (useful for parsing Appwrite's response)
factory ReceiverDetailsModel.fromMap(Map<String, dynamic> map) {
  return ReceiverDetailsModel(
    name: map['name'] ?? '',
    isOwner: map['isOwner'] ?? false,
    isStaff: map['isStaff'] ?? false,
  );
}


  @override
  String toString() {
    return 'ReceiverDetailsModel(id: $id, name: $name, isOwner: $isOwner, isStaff: $isStaff)';
  }

  // CopyWith method for creating modified copies
  ReceiverDetailsModel copyWith({
    String? id,
    String? name,
    bool? isOwner,
    bool? isStaff,
  }) {
    return ReceiverDetailsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isOwner: isOwner ?? this.isOwner,
      isStaff: isStaff ?? this.isStaff,
    );
  }
}
