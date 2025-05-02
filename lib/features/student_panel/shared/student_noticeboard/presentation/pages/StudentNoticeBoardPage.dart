import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/shared/domain/entities/MainNotice.dart';
import 'package:digital_academic_portal/shared/presentation/widgets/ImageView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/StudentNoticeBoardController.dart';

class StudentNoticeBoardPage extends StatefulWidget {
  const StudentNoticeBoardPage({super.key});

  @override
  State<StudentNoticeBoardPage> createState() => _StudentNoticeBoardPageState();
}

class _StudentNoticeBoardPageState extends State<StudentNoticeBoardPage> {
  final StudentNoticeBoardController controller = Get.find();
  final addNoticeKey = GlobalKey<FormState>();
  final editNoticeKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          Obx(() {
            return SliverAppBar(
              expandedHeight: 150.0,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(bottom: controller.titlePadding.value),
                centerTitle: true,
                title: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Notice Board', style: TextStyle(color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                  ],
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Get.theme.primaryColor,
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
                            controller.filterNotices(query);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(2),
                            hintText: 'Search Notices...',
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

              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/noticeboard_icon.png',
                    height: 40,
                    width: 40,
                  ),
                ),
              ],
            );
          }),
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
              if (controller.filteredNoticeList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No notices available")),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final notice = controller.filteredNoticeList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,
                          vertical: 5.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Get.theme.primaryColor),
                        ),
                        child: ListTile(
                          title: Text(notice.title, style: TextStyle(fontWeight: FontWeight.bold, color: Get.theme.primaryColor, fontFamily: 'Ubuntu', fontSize: 21)),
                          subtitle: Column(
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    Get.to(() => const ImageView(image: AssetImage('assets/images/demo_notice.jpg')));
                                  },
                                  child: Image.asset('assets/images/demo_notice.jpg')
                              ),
                              const SizedBox(height: 20),

                              Text(notice.description, style: const TextStyle(fontFamily: 'Ubuntu')),
                            ],
                          ),

                          onTap: () {
                            // Additional functionality if needed
                          },
                        ),
                      ),
                    );
                  }, childCount: controller.filteredNoticeList.length),
                );
              }
            }
          }),
        ],
      ),
    );
  }

  Widget buildNoticeForm(BuildContext context, GlobalKey<FormState> formKey,
      String title, VoidCallback onSave) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom,
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$title Notice',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Get.theme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Obx(() {
                          if (controller.imageFile.value != null) {
                            return Image.file(
                              controller.imageFile.value!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.photo,
                                    color: Colors.grey.shade700, size: 30),
                                const Text('Click to select Image\nOptional',
                                    style: TextStyle(fontFamily: 'Ubuntu')),
                              ],
                            );
                          }
                        }),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: controller.noticeTitleController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      labelText: 'Title'
                  ),
                  validator: (value) =>
                  value!.isEmpty
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: controller.noticeDescriptionController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  maxLines: 4,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      labelText: 'Description'
                  ),
                  validator: (value) =>
                  value!.isEmpty
                      ? 'Description is required'
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onSave,
            child: Text(
              title,
              style: const TextStyle(
                  fontFamily: 'Ubuntu', fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
