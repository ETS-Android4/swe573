import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:funxchange/components/location_picker.dart';
import 'package:funxchange/framework/utils.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({Key? key}) : super(key: key);

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Event"),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter title',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some details';
                      }
                      return null;
                    },
                    maxLines: 4,
                    minLines: 4,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter details',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter participant count';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter participant count',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const LocationPicker(),
          MaterialButton(
            child: Text(_startDateTime != null
                ? Utils.formatDateTime(_startDateTime!)
                : "Pick Start Time"),
            onPressed: () {
              DatePicker.showDateTimePicker(context,
                  minTime: DateTime.now(),
                  maxTime: DateTime.now().add(const Duration(days: 364)),
                  currentTime: DateTime.now(), onConfirm: (d) {
                setState(() {
                  _startDateTime = d;
                });
              });
            },
          ),
          MaterialButton(
            child: Text(_endDateTime != null
                ? Utils.formatDateTime(_endDateTime!)
                : "Pick End Time"),
            onPressed: () {
              DatePicker.showDateTimePicker(context,
                  minTime: _startDateTime ?? DateTime.now(),
                  maxTime: DateTime.now().add(const Duration(days: 365)),
                  currentTime: _startDateTime ?? DateTime.now(),
                  onConfirm: (d) {
                setState(() {
                  _endDateTime = d;
                });
              });
            },
          )
        ],
      ),
    );
  }
}
