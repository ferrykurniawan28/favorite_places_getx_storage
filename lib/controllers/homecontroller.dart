import 'package:favorite_places/models/places.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  RxList<Places> data = <Places>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    final List<Map<String, dynamic>> dataList =
        (box.read('places') as List?)?.cast<Map<String, dynamic>>() ?? [];

    data.value = dataList.map((map) => Places.fromJson(map)).toList().obs;

    super.onInit();
  }

  void deletePlace(String id) {
    data.removeWhere((element) => element.id == id);
    box.write('places', data);
  }
}
