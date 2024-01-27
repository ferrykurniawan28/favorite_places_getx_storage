// import 'dart:io';

import 'package:favorite_places/models/places.dart';
import 'package:favorite_places/screens/mapscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';

class PlaceDetail extends StatelessWidget {
  const PlaceDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final place = Get.arguments as Places;
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
        actions: [
          IconButton(
            onPressed: () async {
              String locationLink =
                  'https://maps.google.com/?q=${place.location.latitude},${place.location.longitude}';
              await Share.share(
                locationLink,
                subject: 'Share Place Location',
              );
            },
            icon: const Icon(Icons.share),
          )
        ],
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(
                      () => MapScreen(
                        lat: place.location.latitude,
                        lng: place.location.longitude,
                        isSelecting: false,
                      ),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: ClipOval(
                      child: Stack(
                        children: [
                          FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                place.location.latitude,
                                place.location.longitude,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 80,
                                    height: 80,
                                    point: LatLng(
                                      place.location.latitude,
                                      place.location.longitude,
                                    ),
                                    child: const Icon(Icons.location_on),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.transparent,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    place.location.address,
                    textAlign: TextAlign.center,
                    style: Get.textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
