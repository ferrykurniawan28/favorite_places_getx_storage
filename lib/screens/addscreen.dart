import 'package:favorite_places/controllers/addcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddScreen extends GetView<AddController> {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Place'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: controller.titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                controller.imageContainer(),
                const SizedBox(height: 10),
                controller.locationInput(),
                ElevatedButton.icon(
                  onPressed: controller.addPlace,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Place'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
