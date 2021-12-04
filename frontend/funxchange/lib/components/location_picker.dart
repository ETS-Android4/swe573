import 'package:flutter/material.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/models/detailed_location.dart';
import 'package:funxchange/models/location.dart';
import 'package:funxchange/screens/map_picker.dart';
import 'package:latlong2/latlong.dart';

class LocationPicker extends StatefulWidget {

  final Function(DetailedLocation) onLocationPicked;

  const LocationPicker({Key? key, required this.onLocationPicked}) : super(key: key);

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Location? _currentLocation = null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _currentLocation?.region ?? "Pick A Location",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.navigate_next_sharp),
          ],
        ),
        onPressed: () async {
          final data = await Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => const MapPicker()),
          ) as DetailedLocation;

          setState(() {
            widget.onLocationPicked(data);
            _currentLocation = data.location;
          });
        },
      ),
    );
  }
}
