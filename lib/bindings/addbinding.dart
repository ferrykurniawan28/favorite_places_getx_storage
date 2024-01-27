import 'package:favorite_places/controllers/addcontroller.dart';
import 'package:get/get.dart';

class AddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddController());
  }
}
