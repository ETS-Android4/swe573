import 'package:flutter/material.dart';
import 'package:funxchange/components/location_picker.dart';

class NewEventScreen extends StatelessWidget {
  const NewEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Event"),
      ),
      body: Column(
        children: [
          const LocationPicker(),
        ],
      ),
    );
  }
}
