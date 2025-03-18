
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../shared/presentation/widgets/ImageView.dart';
import '../../domain/entities/Template.dart';
import '../controllers/TemplateController.dart';

class MainTemplatePage extends StatefulWidget {
  const MainTemplatePage({super.key});

  @override
  State<MainTemplatePage> createState() => _MainTemplatePageState();
}

class _MainTemplatePageState extends State<MainTemplatePage> {
  final TemplateController controller = Get.find();
  final addTemplateKey = GlobalKey<FormState>();
  final editTemplateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.theme.primaryColor,
        onPressed: () => addTemplateBottomSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
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
                    Text('Template Board', style: TextStyle(color: Colors.white,
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
                            controller.filterTemplates(query);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(2),
                            hintText: 'Search Templates...',
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
              if (controller.filteredTemplateList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text("No templates available")),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final template = controller.filteredTemplateList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,
                          vertical: 5.0),
                    );
                  }, childCount: controller.filteredTemplateList.length),
                );
              }
            }
          }),
        ],
      ),
    );
  }

  Future addTemplateBottomSheet(BuildContext context) {
    controller.clearFields();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return buildTemplateForm(context, addTemplateKey, "Add", () {
          if (addTemplateKey.currentState!.validate()) {
            controller.addTemplate();
            Get.back();
          }
        });
      },
    );
  }

  Future editTemplateBottomSheet(BuildContext context, MainTemplate template) {
    controller.updateTemplateDetails(template);
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return buildTemplateForm(context, editTemplateKey, "Edit", () {
          if (editTemplateKey.currentState!.validate()) {
            controller.editTemplate(template);
            Get.back();
          }
        });
      },
    );
  }

  Widget buildTemplateForm(BuildContext context, GlobalKey<FormState> formKey,
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
            '$title Template',
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
                  controller: controller.templateTitleController,
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
                  controller: controller.templateDescriptionController,
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
