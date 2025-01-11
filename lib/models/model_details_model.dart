class ModelDetailsModel {
  String? frontImagePath; // File path for the front image
  String? backImagePath; // File path for the back image
  String? sideImage1Path; // File path for the first side image
  String? sideImage2Path; // File path for the second side image

  ModelDetailsModel({
    this.frontImagePath,
    this.backImagePath,
    this.sideImage1Path,
    this.sideImage2Path,
  });

  // Convert the model to a map (useful for database storage or API operations)
  Map<String, dynamic> toMap() {
    return {
      'frontImagePath': frontImagePath,
      'backImagePath': backImagePath,
      'sideImage1Path': sideImage1Path,
      'sideImage2Path': sideImage2Path,
    };
  }

  // Create a model from a map (useful for parsing database or API responses)
  factory ModelDetailsModel.fromMap(Map<String, dynamic> map) {
    return ModelDetailsModel(
      frontImagePath: map['frontImagePath'],
      backImagePath: map['backImagePath'],
      sideImage1Path: map['sideImage1Path'],
      sideImage2Path: map['sideImage2Path'],
    );
  }

  @override
  String toString() {
    return 'ModelDetailsModel(frontImagePath: $frontImagePath, backImagePath: $backImagePath, sideImage1Path: $sideImage1Path, sideImage2Path: $sideImage2Path)';
  }
}
