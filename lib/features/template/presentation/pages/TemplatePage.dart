import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/TemplateController.dart';


class TemplatePage extends StatefulWidget {
  const TemplatePage({super.key});

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  @override
  Widget build(BuildContext context) {
    final TemplateController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Text('Templates'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const CircularProgressIndicator();
          }
          else {
            if (controller.TemplateList.isEmpty) {
              return Center(child: Text("No Templates available"));
            } else {
              return ListView.builder(
                itemCount: controller.TemplateList.length,
                itemBuilder: (context, index) {
                  final Template = controller.TemplateList[index];
                  return ListTile(
                    title: Text(''),
                    subtitle: Text(''),
                    onTap: () {
                      // Handle tap, e.g., navigate to Template details or edit
                    },
                  );
                },
              );
            }
          }
        }),
      ),
    );
  }
}
