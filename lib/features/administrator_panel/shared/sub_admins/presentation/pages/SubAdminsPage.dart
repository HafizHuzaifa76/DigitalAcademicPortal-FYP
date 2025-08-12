import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/SubAdminController.dart';
import '../bindings/SubAdminBinding.dart';
import '../../domain/entities/SubAdmin.dart';

class SubAdminsPage extends StatelessWidget {
  SubAdminsPage({Key? key}) : super(key: key) {
    SubAdminBinding().dependencies();
  }

  final SubAdminController controller = Get.find<SubAdminController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sub Admins'),
        flexibleSpace: Container(
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Get.theme.primaryColor,
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.subAdmins.isEmpty) {
          return const Center(
            child: Text('No sub admins found.'),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.subAdmins.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final subAdmin = controller.subAdmins[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings, size: 32),
                title: Text(
                  subAdmin.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: 'Ubuntu'),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(subAdmin.email),
                    Text('Department: ${subAdmin.department}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, subAdmin),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String? selectedDept; // for dropdown selection

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Sub Admin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            Obx(() => DropdownButtonFormField<String>(
                  value: selectedDept,
                  decoration: const InputDecoration(labelText: 'Department'),
                  items: controller.departments
                      .map((dept) => DropdownMenuItem(
                            value: dept,
                            child: Text(dept),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedDept = value;
                  },
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final email = emailController.text.trim();
              final dept = selectedDept?.trim() ?? '';
              if (name.isNotEmpty && email.isNotEmpty && dept.isNotEmpty) {
                await controller.addSubAdmin(SubAdmin(
                  id: '', // Firestore will auto-generate
                  name: name,
                  email: email,
                  department: dept,
                ));
                Navigator.of(context).pop();
                Get.snackbar('Success', 'Sub admin added!',
                    backgroundColor: Colors.green, colorText: Colors.white);
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, SubAdmin subAdmin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Sub Admin'),
        content: Text('Are you sure you want to delete ${subAdmin.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.deleteSubAdmin(subAdmin.id);
              Navigator.of(context).pop();
              Get.snackbar('Deleted', 'Sub admin deleted.',
                  backgroundColor: Colors.red, colorText: Colors.white);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
