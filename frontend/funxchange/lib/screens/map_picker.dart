import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/framework/di.dart';
import 'package:latlong2/latlong.dart';

class MapPicker extends StatefulWidget {
  const MapPicker({Key? key}) : super(key: key);

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  final MapController _controller = MapController();
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick A Location"),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _controller,
                  options: MapOptions(
                    center: LatLng(51.5, -0.09),
                    zoom: 13.0,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                      attributionBuilder: (_) {
                        return const Text("© OpenStreetMap contributors");
                      },
                    ),
                  ],
                ),
                const Center(child: Icon(Icons.tag_rounded)),
              ],
            ),
          ),
          MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              color: FunColor.fulvous,
              child: (_isLoading)
                  ? const CupertinoActivityIndicator()
                  : const Text("Select this location"),
              onPressed: () async {
                final center = _controller.center;
                setState(() {
                  _isLoading = true;
                });
                final location = await DIContainer.singleton.geocodingRepo
                    .reverseGeocode(center.latitude, center.longitude);
                Navigator.pop(context, location);
              })
        ],
      ),
    );
  }
}
