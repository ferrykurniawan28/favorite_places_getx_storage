import 'dart:convert';
import 'dart:io';

import 'package:favorite_places/models/places.dart';
import 'package:favorite_places/routes/pages.dart';
import 'package:favorite_places/screens/mapscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class AddController extends GetxController {
  TextEditingController titleController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final imagepicker = ImagePicker();
  File? image;
  RxBool isImage = false.obs;
  PlaceLocation? pickedLocation;
  RxBool isgettingLocation = false.obs;
  double? lat;
  double? lng;
  String? address;
  RxBool getonMap = false.obs;
  Key mapKey = UniqueKey();
  final box = GetStorage();

  // final homeC = Get.put(HomeController());

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void addPlace() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (formKey.currentState!.validate()) {
      final data = Places(
        title: titleController.text,
        image: image!,
        location: pickedLocation!,
      );
      final List<Map<String, dynamic>> dataList =
          (box.read('places') as List?)?.cast<Map<String, dynamic>>() ?? [];

      dataList.add(data.toJson());

      box.write('places', dataList);

      Get.offAllNamed(Pages.home);
    }
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    isgettingLocation.value = true;

    locationData = await location.getLocation();

    lat = locationData.latitude;
    lng = locationData.longitude;
    address = await getAddress(lat!, lng!);

    // pickedLocation = location;
    pickedLocation = PlaceLocation(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
      address: address!,
    );

    isgettingLocation.value = false;

    // print(locationData.latitude);
    // print(locationData.longitude);
    // getonMap.value = true;
    update();
  }

  Future<void> _gettemplocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    isgettingLocation.value = true;

    locationData = await location.getLocation();

    isgettingLocation.value = false;

    lat = locationData.latitude;
    lng = locationData.longitude;
  }

  Future<String> getAddress(double lat, double lng) async {
    // final url =
    //     'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=$lat&longitude=$lng&localityLanguage=en';
    // final response = await http.get(Uri.parse(url));
    // final data = json.decode(response.body);
    // print(data['city']);
    // return data['city'];
    final url =
        'https://api.geoapify.com/v1/geocode/reverse?lat=$lat&lon=$lng&apiKey=0a9c872fa8d54f53bdbfd2db50bf11e0';

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    // print(data['features'][0]['properties']['city']);
    // return data['features'][0]['properties']['city'];
    return data['features'][0]['properties']['address_line2'];
  }

  void addImage() async {
    final pickedImage =
        await imagepicker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    image = File(pickedImage.path);
    isImage.value = true;
  }

  void removeImage() {
    image = null;
    isImage.value = false;
  }

  // void selectOnMap() {
  //   Get.to(() => mapScreen());
  // }

  // void get locationImage() {

  // }

  void tapOnMap(tapPosition, point) async {
    // print(point.latitude);
    // print(point.longitude);
    lat = point.latitude;
    lng = point.longitude;
    address = await getAddress(lat!, lng!);
    pickedLocation = PlaceLocation(
      latitude: point.latitude,
      longitude: point.longitude,
      address: address!,
    );
    update();
    getonMap.value = true;
  }

  Widget fullscreenImage() {
    return PageView(children: [
      GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Image.file(
          image!,
          fit: BoxFit.contain,
        ),
      ),
    ]);
  }

  Widget mapScreen() {
    return Scaffold(
      appBar: AppBar(),
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: LatLng(lat!, lng!),
          initialZoom: 10,
          interactionOptions: const InteractionOptions(),
          onTap: tapOnMap,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          Obx(() {
            if (getonMap.value) {
              return MarkerLayer(markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(
                      pickedLocation!.latitude, pickedLocation!.longitude),
                  child: const Icon(Icons.location_on),
                ),
              ]);
            }
            return const MarkerLayer(markers: []);
          }),
        ],
      ),
    );
  }

  Widget imageContainer() {
    return Obx(() {
      if (isImage.value) {
        return GestureDetector(
          onTap: () {
            Get.to(() => fullscreenImage());
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                child: Image.file(
                  image!,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  width: double.infinity,
                  // height: 250,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: () {
                    removeImage();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          width: double.infinity,
          height: 250,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: TextButton.icon(
            onPressed: () {
              addImage();
            },
            icon: const Icon(Icons.camera),
            label: const Text('Take Picture'),
          ),
        );
      }
    });
  }

  Widget locationInput() {
    return Obx(() {
      Widget previewContent;

      if (isgettingLocation.value) {
        previewContent = const Center(
          child: CircularProgressIndicator(),
        );
      } else if (pickedLocation != null || getonMap.value) {
        previewContent = FlutterMap(
          mapController: MapController(),
          options: MapOptions(
            initialCenter:
                LatLng(pickedLocation!.latitude, pickedLocation!.longitude),
            initialZoom: 10,
            interactionOptions: const InteractionOptions(),
            // onTap: (tapPosition, point) {
            //   print(point.latitude);
            //   print(point.longitude);
            // },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              // userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              // Plenty of other options available!
            ),
            // TileLayer(
            //   urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            //   // subdomains: ['a', 'b', 'c'],
            // ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(
                    pickedLocation!.latitude,
                    pickedLocation!.longitude,
                  ),
                  child: const Icon(Icons.location_on),
                  // builder: (ctx) => Icon(Icons.location_on),
                ),
                // Marker(
                //   width: 80.0,
                //   height: 80.0,
                //   point: LatLng(lat!, lng!),
                //   child: const Icon(Icons.location_on),
                //   // builder: (ctx) => Icon(Icons.location_on),
                // ),
              ],
            ),
          ],
        );
      } else {
        previewContent = Text(
          'No Location Chosen',
          textAlign: TextAlign.center,
          style: Get.theme.textTheme.bodyLarge!.copyWith(
            color: Colors.white,
          ),
        );
      }
      return Column(
        children: [
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            child: Center(
              child: previewContent,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  _getCurrentLocation();
                },
                icon: const Icon(Icons.location_on),
                label: const Text('Get Current Location'),
              ),
              TextButton.icon(
                onPressed: () async {
                  if (pickedLocation == null) {
                    await _gettemplocation();
                    Get.to(() => MapScreen(
                          lat: lat!,
                          lng: lng!,
                          onTap: tapOnMap,
                          isSelecting: true,
                          // location: pickedLocation,
                        ));
                  }
                },
                icon: const Icon(Icons.map),
                label: const Text('Select on Map'),
              ),
            ],
          )
        ],
      );
    });
  }
}
