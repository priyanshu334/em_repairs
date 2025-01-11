class BarcodeModel {
  final String? id; // ID for Appwrite document, nullable because it may not be set when creating a new barcode record.
  final String barcodeData; // Data from the scanned barcode
  final DateTime scannedAt; // The date and time when the barcode was scanned
  final String? additionalInfo; // Any additional information related to the barcode

  BarcodeModel({
    this.id, // `id` is optional, as it may not be set on creation
    required this.barcodeData,
    required this.scannedAt,
    this.additionalInfo, // Optional field
  });

  // Factory constructor to create a BarcodeModel from a Map (for example, fetched from Appwrite)
  factory BarcodeModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BarcodeModel(
      id: documentId, // Assign the document ID from Appwrite
      barcodeData: map['barcodeData'] ?? '',
      scannedAt: DateTime.parse(map['scannedAt'] ?? DateTime.now().toString()),
      additionalInfo: map['additionalInfo'], // Optional field
    );
  }

  // Method to convert BarcodeModel to a Map for Appwrite operations
  Map<String, dynamic> toMap() {
    return {
      'barcodeData': barcodeData,
      'scannedAt': scannedAt.toIso8601String(), // Convert DateTime to string format
      'additionalInfo': additionalInfo,
    };
  }
}
