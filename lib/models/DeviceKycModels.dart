import 'package:flutter/material.dart';

class DeviceKycModels {
  final String id; // Make 'id' non-nullable
  final String? frontImagePath;
  final String? backImagePath;
  final String? sideImage1Path;
  final String? sideImage2Path;
  final List<int>? lockCode;
  final String? patternCode;
  final String? barcode;
  final Map<String, dynamic>? accessoriesModel; // Changed to Map for Appwrite

  DeviceKycModels({
    required this.id, // 'id' is now required
    this.frontImagePath,
    this.backImagePath,
    this.sideImage1Path,
    this.sideImage2Path,
    this.lockCode,
    this.patternCode,
    this.barcode,
    this.accessoriesModel,
  });

  // Convert the model to a map (for Appwrite Database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include 'id' in the map
      'frontImagePath': frontImagePath,
      'backImagePath': backImagePath,
      'sideImage1Path': sideImage1Path,
      'sideImage2Path': sideImage2Path,
      'lockCode': lockCode,
      'patternCode': patternCode,
      'barcode': barcode,
      'accessoriesModel': accessoriesModel, // Store it as a Map or JSON
    };
  }

  // Create a model from a map (useful for parsing Appwrite's response)
  factory DeviceKycModels.fromMap(Map<String, dynamic> map) {
    return DeviceKycModels(
      id: map['id'], // 'id' is now mandatory
      frontImagePath: map['frontImagePath'],
      backImagePath: map['backImagePath'],
      sideImage1Path: map['sideImage1Path'],
      sideImage2Path: map['sideImage2Path'],
      lockCode: map['lockCode']?.cast<int>(),
      patternCode: map['patternCode'],
      barcode: map['barcode'],
      accessoriesModel: map['accessoriesModel'],
    );
  }

  @override
  String toString() {
    return 'DeviceKycModel(id: $id, frontImagePath: $frontImagePath, backImagePath: $backImagePath, '
        'sideImage1Path: $sideImage1Path, sideImage2Path: $sideImage2Path, '
        'lockCode: $lockCode, patternCode: $patternCode, barcode: $barcode, '
        'accessoriesModel: $accessoriesModel)';
  }

  // CopyWith method for easier updates
  DeviceKycModels copyWith({
    String? id,
    String? frontImagePath,
    String? backImagePath,
    String? sideImage1Path,
    String? sideImage2Path,
    List<int>? lockCode,
    String? patternCode,
    String? barcode,
    Map<String, dynamic>? accessoriesModel,
  }) {
    return DeviceKycModels(
      id: id ?? this.id,
      frontImagePath: frontImagePath ?? this.frontImagePath,
      backImagePath: backImagePath ?? this.backImagePath,
      sideImage1Path: sideImage1Path ?? this.sideImage1Path,
      sideImage2Path: sideImage2Path ?? this.sideImage2Path,
      lockCode: lockCode ?? this.lockCode,
      patternCode: patternCode ?? this.patternCode,
      barcode: barcode ?? this.barcode,
      accessoriesModel: accessoriesModel ?? this.accessoriesModel,
    );
  }
}
