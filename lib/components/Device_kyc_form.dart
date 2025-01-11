import 'package:em_repairs/components/Accessories_form.dart';
import 'package:em_repairs/components/other_components/bar_code.dart';
import 'package:em_repairs/components/other_components/bar_code_scan_componet.dart';
import 'package:em_repairs/components/other_components/lock_code.dart';
import 'package:em_repairs/components/other_components/model_details.dart';
import 'package:flutter/material.dart';

class DeviceKycForm extends StatelessWidget {
  final Function(String accessoryName, String additionalDetails, bool isWarranty, DateTime? warrantyDate)? onFormSubmit;

  const DeviceKycForm({Key? key, this.onFormSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Device KYC",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // ModelDetails wrapped in a Card for consistency
   
                 Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ModelDetails(),
                ),
              
              // LockCode wrapped in a Card for consistency
              

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LockCode(),
                ),
                 
                      

               
            
              
    
              
              // AccessoriesForm with onSubmit callback
              AccessoriesForm(
                onSubmit: (accessoryName, additionalDetails, isWarranty, warrantyDate) {
                  if (onFormSubmit != null) {
                    onFormSubmit!(accessoryName, additionalDetails, isWarranty, warrantyDate);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
