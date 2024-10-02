import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/SectionController.dart';

class MainSectionsListPage extends StatefulWidget {
  final String deptName;
  final String semester;
  const MainSectionsListPage({super.key, required this.deptName, required this.semester});

  @override
  State<MainSectionsListPage> createState() => _MainSectionsListPageState();
}

class _MainSectionsListPageState extends State<MainSectionsListPage> {
  @override
  Widget build(BuildContext context) {
    final SectionController controller = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sections'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {

            return Lottie.asset(
              'assets/animations/loading_animation4.json',
              width: 100,
              height: 100,
              fit: BoxFit.scaleDown,
            );
          }
          else {
            if (controller.sectionList.isEmpty) {
              return const Center(child: Text("No Sections available"));
            } else {
              return ListView.builder(
                itemCount: controller.sectionList.length,
                itemBuilder: (context, index) {
                  final section = controller.sectionList[index];
                  return ListTile(
                    title: Text(section.sectionName),
                    subtitle: const Text(''),
                    onTap: () {
                      // Handle tap, e.g., navigate to Section details or edit
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
