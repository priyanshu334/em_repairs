import 'package:em_repairs/models/accessories_model.dart';

class DeviceKycModels {
  final String? id; // Nullable 'id' for document ID
  final String? frontImagePath; 
  final String? backImagePath; 
  final String? sideImage1Path; 
  final String? sideImage2Path; 
  final List<int>? lockCode; 
  final String? patternCode; 
  final String? barcode; 
  final AccessoriesModel? accessoriesModel; 

  DeviceKycModels({
    this.id, // Nullable 'id'
    this.frontImagePath,
    this.backImagePath,
    this.sideImage1Path,
    this.sideImage2Path,
    this.lockCode,
    this.patternCode,
    this.barcode,
    this.accessoriesModel,
  });

  // Convert the model to a map
  Map<String, dynamic> toMap() {
    return {
      'frontImagePath': frontImagePath,
      'backImagePath': backImagePath,
      'sideImage1Path': sideImage1Path,
      'sideImage2Path': sideImage2Path,
      'lockCode': lockCode,
      'patternCode': patternCode,
      'barcode': barcode,
      'accessories': accessoriesModel?.toMap(),
    };
  }

  // Create a model from a map (useful for parsing response)
  factory DeviceKycModels.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return DeviceKycModels(
      id: documentId, // Use document ID from the response
      frontImagePath: map['frontImagePath'],
      backImagePath: map['backImagePath'],
      sideImage1Path: map['sideImage1Path'],
      sideImage2Path: map['sideImage2Path'],
      lockCode: map['lockCode'] != null ? List<int>.from(map['lockCode']) : null,
      patternCode: map['patternCode'],
      barcode: map['barcode'],
      accessoriesModel: map['accessories'] != null
          ? AccessoriesModel.fromMap(map['accessories'])
          : null,
    );
  }

  @override
  String toString() {
    return 'DeviceKycModel(id: $id, frontImagePath: $frontImagePath, backImagePath: $backImagePath, '
        'sideImage1Path: $sideImage1Path, sideImage2Path: $sideImage2Path, lockCode: $lockCode, '
        'patternCode: $patternCode, barcode: $barcode, accessoriesModel: $accessoriesModel)';
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
    AccessoriesModel? accessoriesModel,
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
