import 'package:favorite_places/controllers/addcontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
    required this.lat,
    required this.lng,
    this.onTap,
    this.isSelecting = false,
  });
  final double? lat;
  final double? lng;
  final void Function(TapPosition tapPosition, LatLng point)? onTap;
  final bool isSelecting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FlutterMap(
        // key: addC.mapKey,
        options: MapOptions(
          initialCenter: LatLng(lat ?? 51.509865, lng ?? -0.118092),
          initialZoom: 13.0,
          onTap: onTap,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          if (!isSelecting)
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(lat!, lng!),
                  child: const Icon(Icons.location_on),
                ),
              ],
            ),
          if (isSelecting)
            Obx(
              () {
                final addC = Get.put(AddController());
                if (addC.getonMap.value) {
                  return MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(
                          addC.pickedLocation!.latitude,
                          addC.pickedLocation!.longitude,
                        ),
                        child: const Icon(Icons.location_on),
                      ),
                    ],
                  );
                } else {
                  return const MarkerLayer(
                    markers: [],
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
