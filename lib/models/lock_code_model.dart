class LockCodeModel {
  final String? id; // Optional ID, can be null
  final List<int> lockCode; // Stores the lock code as a list of integers
  final String? patternCode; // Stores the pattern lock code as a string (nullable)

  LockCodeModel({
    this.id, // Optional ID
    required this.lockCode,
    this.patternCode,
  });

  // Factory constructor to create an instance from a Map (e.g., for database storage)
  factory LockCodeModel.fromMap(Map<String, dynamic> map, [String? documentId]) {
    return LockCodeModel(
      id: documentId ?? map['id'], // Use the provided documentId or fetch it from the map
      lockCode: List<int>.from(map['lockCode'] ?? []),
      patternCode: map['patternCode'],
    );
  }

  // Converts the instance to a Map for saving to database or other storage
  Map<String, dynamic> toMap() {
    return {
      'lockCode': lockCode,
      'patternCode': patternCode,
    };
  }

  @override
  String toString() {
    return 'LockCodeModel(id: $id, lockCode: $lockCode, patternCode: $patternCode)';
  }
}
