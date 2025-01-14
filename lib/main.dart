import 'package:camera/camera.dart';
import 'package:em_repairs/locator.dart';
import 'package:em_repairs/provider/accesories_provider.dart';
import 'package:em_repairs/provider/bar_code_provider.dart';
import 'package:em_repairs/provider/customer_provider.dart';
import 'package:em_repairs/provider/device_kyc_provider.dart';
import 'package:em_repairs/provider/estimate_provider.dart';
import 'package:em_repairs/provider/lock_code_provider.dart';
import 'package:em_repairs/provider/model_provider.dart';
import 'package:em_repairs/provider/order_details_provider.dart';
import 'package:em_repairs/provider/order_provider.dart';

import 'package:em_repairs/provider/receiver_provider.dart';
import 'package:em_repairs/provider/repair_partner_provider.dart';
import 'package:em_repairs/provider/service_center_provider.dart';
import 'package:em_repairs/provider/service_provider.dart';

import 'package:em_repairs/services/apwrite_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/splash_screen.dart';

List<CameraDescription> cameras = []; // Ensuring it is non-nullable.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  // Initialize cameras
  try {
    cameras = await availableCameras();
  } catch (e, stackTrace) {
    debugPrint("Error initializing cameras: $e");
    debugPrint("StackTrace: $stackTrace");
  }

  // Initialize Appwrite Service
  final appwriteService = AppwriteService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CustomerProvider(appwriteService),
        ),
        ChangeNotifierProvider(
            create: (_) => ServiceCenterProvider(appwriteService))
        // Add other providers here if needed
        ,
        ChangeNotifierProvider(
            create: (_) => EstimateProvider(appwriteService)),
        ChangeNotifierProvider(
            create: (_) => ServiceProviderProvider(appwriteService)),
        ChangeNotifierProvider(
            create: (_) => ReceiverDetailsProvider(appwriteService)),
        ChangeNotifierProvider(create: (_)=>ModelDetailsProvider(appwriteService)),

        ChangeNotifierProvider(create: (_)=>LockCodeProvider(appwriteService)),
        ChangeNotifierProvider(create: (_)=>BarcodeProvider(appwriteService)),
        ChangeNotifierProvider(create: (_)=>AccessoriesProvider(appwriteService)),
        ChangeNotifierProvider(create: (_)=>ModelDetailsProvider(appwriteService)),
        ChangeNotifierProvider(create: (_)=>RepairPartnerDetailsProvider(appwriteService)),
        ChangeNotifierProvider(create: (_)=>DeviceKycProvider(appwriteService)),
        ChangeNotifierProvider(create: (_)=>OrderProvider(appwriteService)),
        ChangeNotifierProvider(create: (_)=>OrderDetailsProvider(appwriteService)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Em Repairing",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal.shade900),
        useMaterial3: true,
      ),
      home: SplashScreen(), // Passing cameras to SplashScreen
    );
  }
}