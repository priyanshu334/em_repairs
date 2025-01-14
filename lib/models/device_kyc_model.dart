import 'package:em_repairs/models/accessories_model.dart';
import 'package:em_repairs/models/bar_code_model.dart';
import 'package:em_repairs/models/lock_code_model.dart';
import 'package:em_repairs/models/model_details_model.dart';

class DeviceKycModel {
  final String? deviceId; // Nullable identifier for the device
  final ModelDetailsModel? modelDetailsModel; // Optional model details
  final LockCodeModel? lockCodeModel; // Optional lock code
  final BarcodeModel? barcodeModel; // Optional barcode
  final AccessoriesModel? accessoriesModel; // Optional accessories

  DeviceKycModel({
    this.deviceId, // Now optional
    this.modelDetailsModel,
    this.lockCodeModel,
    this.barcodeModel,
    this.accessoriesModel,
  });

  // Convert to Map (for example, for saving or sending data)
  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId, // Can be null now
      'modelDetails': modelDetailsModel?.toMap(),
      'lockCode': lockCodeModel?.toMap(),
      'barcode': barcodeModel?.toMap(),
      'accessories': accessoriesModel?.toMap(),
    };
  }

  // Convert from Map (for example, when loading data)
  factory DeviceKycModel.fromMap(Map<String, dynamic> map) {
    return DeviceKycModel(
      deviceId: map['deviceId'], // No need to use ?? '' anymore
      modelDetailsModel: map['modelDetails'] != null
          ? ModelDetailsModel.fromMap(map['modelDetails'])
          : null,
      lockCodeModel: map['lockCode'] != null
          ? LockCodeModel.fromMap(map['lockCode'])
          : null,
      barcodeModel: map['barcode'] != null
          ? BarcodeModel.fromMap(map['barcode'])
          : null,
      accessoriesModel: map['accessories'] != null
          ? AccessoriesModel.fromMap(map['accessories'])
          : null,
    );
  }

  @override
  String toString() {
    return 'DeviceKycModel(deviceId: $deviceId, modelDetailsModel: $modelDetailsModel, '
        'lockCodeModel: $lockCodeModel, barcodeModel: $barcodeModel, '
        'accessoriesModel: $accessoriesModel)';
  }

  // Helper method to create a copy of the instance with updated fields
  DeviceKycModel copyWith({
    String? deviceId,
    ModelDetailsModel? modelDetailsModel,
    LockCodeModel? lockCodeModel,
    BarcodeModel? barcodeModel,
    AccessoriesModel? accessoriesModel,
  }) {
    return DeviceKycModel(
      deviceId: deviceId ?? this.deviceId,
      modelDetailsModel: modelDetailsModel ?? this.modelDetailsModel,
      lockCodeModel: lockCodeModel ?? this.lockCodeModel,
      barcodeModel: barcodeModel ?? this.barcodeModel,
      accessoriesModel: accessoriesModel ?? this.accessoriesModel,
    );
  }
}
