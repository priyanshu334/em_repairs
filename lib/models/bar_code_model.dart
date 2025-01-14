class BarcodeModel {
  final String? id; // Unique identifier for the barcode (nullable, assigned by Appwrite)
  final String barcode; // Data of the scanned barcode

  BarcodeModel({
    this.id, // Nullable, as Appwrite generates it
    required this.barcode,
  });

  /// Factory constructor to create a `BarcodeModel` from a Map (e.g., fetched from Appwrite)
  factory BarcodeModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return BarcodeModel(
      id: documentId ?? map['\$id'], // Assign ID from Appwrite's document ID or map
      barcode: map['barcode'] ?? '',
    );
  }

  /// Converts the `BarcodeModel` instance to a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
    };
  }

  @override
  String toString() {
    return 'BarcodeModel(id: $id, barcode: $barcode)';
  }

  /// Helper method to create a copy of the instance with updated fields
  BarcodeModel copyWith({
    String? id,
    String? barcode,
  }) {
    return BarcodeModel(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
    );
  }
}
