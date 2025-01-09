import 'package:flutter/material.dart';

class ReceiverTextField extends StatelessWidget {
  final TextEditingController receiverController;

  const ReceiverTextField({
    Key? key,
    required this.receiverController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: receiverController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Name of Receiver (Owner/Assistant)",
      ),
    );
  }
}