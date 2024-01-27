import 'package:favorite_places/routes/pages.dart';
import 'package:favorite_places/screens/addscreen.dart';
import 'package:favorite_places/screens/place.dart';
import 'package:get/get.dart';

import '../bindings/addbinding.dart';
import '../bindings/homebinding.dart';
import '../screens/home.dart';

class Routes {
  static final pages = [
    GetPage(
      name: Pages.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Pages.add,
      page: () => const AddScreen(),
      binding: AddBinding(),
    ),
    GetPage(
      name: Pages.placedetail,
      page: () => const PlaceDetail(),
      arguments: Get.arguments,
    ),
  ];
}
