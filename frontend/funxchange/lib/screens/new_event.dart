import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:funxchange/components/location_picker.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/framework/utils.dart';
import 'package:funxchange/models/event.dart';
import 'package:funxchange/models/interest.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({Key? key}) : super(key: key);

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  Interest _currentCategory = Interest.golf;

  var isSelected = [true, false];

  EventType _currentEventType = EventType.service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final formValidation = _formKey.currentState!.validate();
          final dateValidation = _validateDates();

          if (!dateValidation) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Picked dates must be valid')),
            );
            return;
          }

          if (formValidation) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
          }
        },
      ),
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
                  padding: const EdgeInsets.all(8.0),
                  child: ToggleButtons(
                    children: const [
                      Text("        Service        "),
                      Text("        Meetup        "),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        isSelected[0] = !isSelected[0];
                        isSelected[1] = !isSelected[1];
                        if (index == 0) {
                          _currentEventType = EventType.service;
                        } else {
                          _currentEventType = EventType.meetup;
                        }
                      });
                    },
                    isSelected: isSelected,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }

                      if (value.length > 255) {
                        return 'Title must contain at most 255 characters.';
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

                      const limit = 255 * 8;

                      if (value.length > limit) {
                        return 'Title must contain at most ' +
                            limit.toString() +
                            ' characters.';
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
                      int? intVal = int.tryParse(value);
                      if (intVal == null) {
                        return 'Please enter a number.';
                      }

                      if (intVal < 1 || intVal > 12) {
                        return 'Participant count must be between 1 and 12.';
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("Category: "),
              DropdownButton<String>(
                value: _currentCategory.prettyName,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: FunColor.fulvous),
                underline: Container(
                  height: 2,
                  color: FunColor.fulvous,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _currentCategory = Interest.values.firstWhere(
                        (element) => element.prettyName == newValue!);
                  });
                },
                items: Interest.values
                    .map((e) => e.prettyName)
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          const LocationPicker(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Start Time: ",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              MaterialButton(
                child: Text(
                  _startDateTime != null
                      ? Utils.formatDateTime(_startDateTime!)
                      : "Pick Start Time",
                ),
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
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "End Time: ",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              ),
            ],
          )
        ],
      ),
    );
  }

  bool _validateDates() {
    return false;
  }
}
