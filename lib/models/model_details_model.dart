import 'package:flutter/material.dart';

class ModelDetailsModel {
  final String? id; // Nullable ID
  String? frontImagePath; // File path for the front image
  String? backImagePath; // File path for the back image
  String? sideImage1Path; // File path for the first side image
  String? sideImage2Path; // File path for the second side image

  ModelDetailsModel({
    this.id, // `id` is now optional
    this.frontImagePath,
    this.backImagePath,
    this.sideImage1Path,
    this.sideImage2Path,
  });

  // Convert the model to a map (useful for database storage or API operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // `id` can be null now
      'frontImagePath': frontImagePath,
      'backImagePath': backImagePath,
      'sideImage1Path': sideImage1Path,
      'sideImage2Path': sideImage2Path,
    };
  }

  // Create a model from a map (useful for parsing database or API responses)
  factory ModelDetailsModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return ModelDetailsModel(
      id: documentId, // Use documentId from the response (nullable)
      frontImagePath: map['frontImagePath'],
      backImagePath: map['backImagePath'],
      sideImage1Path: map['sideImage1Path'],
      sideImage2Path: map['sideImage2Path'],
    );
  }

  @override
  String toString() {
    return 'ModelDetailsModel(id: $id, frontImagePath: $frontImagePath, backImagePath: $backImagePath, sideImage1Path: $sideImage1Path, sideImage2Path: $sideImage2Path)';
  }

  // CopyWith method for easier updates
  ModelDetailsModel copyWith({
    String? id,
    String? frontImagePath,
    String? backImagePath,
    String? sideImage1Path,
    String? sideImage2Path,
  }) {
    return ModelDetailsModel(
      id: id ?? this.id,
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
      sideImage1Path: sideImage1Path ?? this.sideImage1Path,
      sideImage2Path: sideImage2Path ?? this.sideImage2Path,
    );
  }
}
