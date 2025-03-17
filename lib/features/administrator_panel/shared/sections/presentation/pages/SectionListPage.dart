import 'package:digital_academic_portal/features/administrator_panel/shared/sections/presentation/pages/SectionDetailScreen.dart';
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
  final SectionController controller = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.showAllSections(widget.deptName, widget.semester);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150.0,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 70),
              centerTitle: true,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sections',
                    style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text('${widget.deptName.trim()} ${widget.semester}',
                      style: const TextStyle(color: Colors.white, fontSize: 12.0, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 2),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      const Color(0xFF1B7660),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 55,
                      child: TextField(
                        onChanged: (query) {
                          controller.filterSections(query);  // Add this method in your controller to filter sections
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(2),
                          hintText: 'Search Sections...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Obx(() {
            if (controller.isLoading.value) {
              return SliverFillRemaining(
                child: Center(
                  child: Lottie.asset(
                    'assets/animations/loading_animation4.json',
                    width: 120,
                    height: 120,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              );
            } else {
              if (controller.filteredSectionList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No Sections available")),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      final section = controller.filteredSectionList[index];  // Assuming filteredSectionList is populated based on the search
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),

                          child: ListTile(
                            title: Text(
                              'Section: ${section.sectionID}, Shift: ${section.shift}',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                            ),
                            subtitle: Text('Total Students: ${section.totalStudents}'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () => Get.to(()=> SectionDetailPage(deptName: widget.deptName, semester: widget.semester, section: section)),
                          ),
                        ),
                      );
                    },
                    childCount: controller.filteredSectionList.length,  // Use filtered list here
                  ),
                );
              }
            }
          }),
        ],
      ),
    );
  }

}
