import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/CourseController.dart';
import 'CourseDetailPage.dart';

class AllCoursesScreen extends StatefulWidget {
  final String deptName;
  const AllCoursesScreen({Key? key, required this.deptName}) : super(key: key);

  @override
  _AllCoursesScreenState createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  final TextEditingController searchController = TextEditingController();
  final CourseController controller = Get.find<CourseController>(); // GetX Controller
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      controller.updatePadding(scrollController.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          Obx(() => SliverAppBar(
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.only(bottom: controller.titlePadding.value),
              centerTitle: true,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Courses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Department of ${widget.deptName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                        controller: searchController,
                        onChanged: (query) {
                          controller.filterCourses(query);
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(2),
                          hintText: 'Search Courses...',
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
          )),

          // 📚 Course List
          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (controller.filteredAllCourseList.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No Courses Available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            } else {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    final course = controller.filteredAllCourseList[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          title: Text(
                            course.courseName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontFamily: 'Ubuntu',
                            ),
                          ),
                          subtitle: Text('Code: ${course.courseCode}, Credit Hours: ${course.courseCreditHours}'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Get.to(() => CourseDetailPage(
                            //   deptName: widget.deptName,
                            //   course: course,
                            // ));
                          },
                        ),
                      ),
                    );
                  },
                  childCount: controller.filteredAllCourseList.length,
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
