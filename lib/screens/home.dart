import 'package:favorite_places/controllers/homecontroller.dart';
import 'package:favorite_places/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Great Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.toNamed(Pages.add);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.data.isEmpty) {
          return const Center(
            child: Text(
              'No places yet, start adding some!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: controller.data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Dismissible(
                  key: Key(controller.data[index].id),
                  onDismissed: (direction) {
                    controller.deletePlace(controller.data[index].id);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(
                        controller.data[index].image,
                      ),
                    ),
                    title: Text(controller.data[index].title),
                    onTap: () {
                      Get.toNamed(
                        Pages.placedetail,
                        arguments: controller.data[index],
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
