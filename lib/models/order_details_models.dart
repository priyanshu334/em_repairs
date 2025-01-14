enum OrderStatus {
  pending,
  repaired,
  delivered,
  cancelled,
}

class OrderDetailsModel {
  final String? id; // Make 'id' nullable
  final String deviceModel;
  final OrderStatus orderStatus;
  final List<String> problems;

  OrderDetailsModel({
    this.id, // Now 'id' is optional
    required this.deviceModel,
    required this.orderStatus,
    required this.problems,
  });

  // Convert the model to a map (for Appwrite Database operations)
  Map<String, dynamic> toMap() {
    return {
      'deviceModel': deviceModel,
      'orderStatus': orderStatus.name, // Convert enum to its name
      'problems': problems,
    };
  }

  // Create a model from a map (useful for parsing Appwrite's response)
  factory OrderDetailsModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderDetailsModel(
      id: documentId, // Use the document ID from Appwrite response
      deviceModel: map['deviceModel'] ?? '',
      orderStatus: OrderStatus.values.firstWhere(
        (e) => e.name == map['orderStatus'],
        orElse: () => OrderStatus.pending, // Default to pending if not found
      ),
      problems: List<String>.from(map['problems'] ?? []),
    );
  }

  @override
  String toString() {
    return 'OrderDetailsModel(id: $id, deviceModel: $deviceModel, orderStatus: $orderStatus, problems: $problems)';
  }

  // CopyWith method for creating modified copies
  OrderDetailsModel copyWith({
    String? id,
    String? deviceModel,
    OrderStatus? orderStatus,
    List<String>? problems,
  }) {
    return OrderDetailsModel(
      id: id ?? this.id,
      deviceModel: deviceModel ?? this.deviceModel,
      orderStatus: orderStatus ?? this.orderStatus,
      problems: problems ?? this.problems,
    );
  }
}
