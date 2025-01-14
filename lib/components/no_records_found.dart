import 'package:flutter/material.dart';

class NoRecordsFound extends StatelessWidget {
  final bool showFilters;

  const NoRecordsFound({
    Key? key,
    required this.showFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: showFilters ? 0.5 : 1.0,
          child: Image.asset(
            'assets/images/background.png',
            height: 200,
          ),
        ),
        const AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 300),
          style: TextStyle(fontSize: 16, color: Colors.black),
          child: Text('No Records Found'),
        ),
      ],
    );
  }
}
