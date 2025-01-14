import 'package:em_repairs/provider/estimate_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:em_repairs/models/estimate_form.dart';

class EstimateDetailPage extends StatefulWidget {
  final String estimateId;  // Pass the estimate ID to fetch the estimate

  EstimateDetailPage({required this.estimateId});

  @override
  _EstimateDetailPageState createState() => _EstimateDetailPageState();
}

class _EstimateDetailPageState extends State<EstimateDetailPage> {
  late EstimateProvider _estimateProvider;
  EstimateModel? _estimate;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialize EstimateProvider
    _estimateProvider = Provider.of<EstimateProvider>(context, listen: false);
    // Fetch the estimate by its ID
    _fetchEstimateById();
  }

  // Fetch estimate by its ID
  Future<void> _fetchEstimateById() async {
    try {
      // Get the estimate using the method provided
      EstimateModel estimate = await _estimateProvider.getEstimateById(widget.estimateId);
      setState(() {
        _estimate = estimate;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch estimate. Please try again later.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estimate Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estimate ID: ${_estimate!.id}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Repair Cost: \$${_estimate!.repairCost}', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Description: ${_estimate!.advancePaid}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 10),
                      // Add more details here as per the EstimateModel
                    ],
                  ),
                ),
    );
  }
}
