import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/shared/domain/entities/MainNotice.dart';
import 'package:digital_academic_portal/shared/presentation/widgets/ImageView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/NoticeBoardController.dart';

class MainNoticeBoardPage extends StatefulWidget {
  const MainNoticeBoardPage({super.key});

  @override
  State<MainNoticeBoardPage> createState() => _MainNoticeBoardPageState();
}

class _MainNoticeBoardPageState extends State<MainNoticeBoardPage> {
  final NoticeBoardController controller = Get.find();
  final addNoticeKey = GlobalKey<FormState>();
  final editNoticeKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Get.theme.primaryColor,
              const Color(0xFF1B7660),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Get.theme.primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
        onPressed: () => addNoticeBottomSheet(context),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
      body: CustomScrollView(
        controller: controller.scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern SliverAppBar with gradient
          Obx(() {
            return SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Get.theme.primaryColor,
                        const Color(0xFF1B7660),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative elements
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      // Content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Notice Board',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Ubuntu',
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Modern search bar
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                        child: TextField(
                          onChanged: (query) {
                            controller.filterNotices(query);
                          },
                                decoration: const InputDecoration(
                                  hintText: 'Search notices...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Ubuntu',
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () => Get.back(),
              ),
            );
          }),

          // Notices List
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
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No notices available",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontFamily: 'Ubuntu',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final notice = controller.filteredNoticeList[index];
                    return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildModernNoticeCard(notice),
                    );
                  }, childCount: controller.filteredNoticeList.length),
                  ),
                );
              }
            }
          }),
        ],
      ),
    );
  }

  Widget _buildModernNoticeCard(MainNotice notice) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Get.theme.primaryColor.withOpacity(0.1),
                  const Color(0xFF1B7660).withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    notice.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Get.theme.primaryColor,
                      fontFamily: 'Ubuntu',
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () => editNoticeBottomSheet(context, notice),
                    icon: Icon(
                      Icons.edit,
                      color: Get.theme.primaryColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: () => controller.deleteNotice(notice),
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notice image
          GestureDetector(
            onTap: () {
              Get.to(() => const ImageView(
                  image: AssetImage('assets/images/demo_notice.jpg')));
            },
            child: Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/images/demo_notice.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Notice description
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(
              notice.description,
              style: const TextStyle(
                fontFamily: 'Ubuntu',
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future addNoticeBottomSheet(BuildContext context) {
    controller.clearFields();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          child: buildNoticeForm(context, addNoticeKey, "Add", () {
          if (addNoticeKey.currentState!.validate()) {
            controller.addNotice();
            Get.back();
          }
          }),
        );
      },
    );
  }

  Future editNoticeBottomSheet(BuildContext context, MainNotice notice) {
    controller.updateNoticeDetails(notice);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          child: buildNoticeForm(context, editNoticeKey, "Edit", () {
          if (editNoticeKey.currentState!.validate()) {
            controller.editNotice(notice);
            Get.back();
          }
          }),
        );
      },
    );
  }

  Widget buildNoticeForm(BuildContext context, GlobalKey<FormState> formKey,
      String title, VoidCallback onSave) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.0,
        right: 20.0,
        top: 20.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            '$title Notice',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Get.theme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),

          Form(
            key: formKey,
            child: Column(
              children: [
                // Image picker
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                        height: 200,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                        ),
                        child: Obx(() {
                          if (controller.imageFile.value != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                              controller.imageFile.value!,
                              fit: BoxFit.cover,
                          ),
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                            Icon(
                              CupertinoIcons.photo,
                              color: Colors.grey[600],
                              size: 40,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Click to select Image\n(Optional)',
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                              ],
                            );
                          }
                        }),
                  ),
                ),
                const SizedBox(height: 20),

                // Title field
                TextFormField(
                  controller: controller.noticeTitleController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Get.theme.primaryColor, width: 2),
                    ),
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'Ubuntu',
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 16),

                // Description field
                TextFormField(
                  controller: controller.noticeDescriptionController,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 4,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Get.theme.primaryColor, width: 2),
                    ),
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                      fontFamily: 'Ubuntu',
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    alignLabelWithHint: true,
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Description is required' : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Save button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Get.theme.primaryColor,
                  const Color(0xFF1B7660),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Get.theme.primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: onSave,
                child: Center(
            child: Text(
              title,
              style: const TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
