import 'package:as_pass/controller/profile_controller.dart';
import 'package:as_pass/models/service_provider.dart';
import 'package:as_pass/utils/category_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditServicePage extends StatefulWidget {
  final ServiceProvider service;
  const EditServicePage({super.key, required this.service});

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  final ProfileController controller = Get.find();
  late TextEditingController _descController;
  late TextEditingController _expController;
  String? _selectedCategory;
  final List<String> _categories = [
    'Tutoring',
    'Tech Support',
    'Repairs',
    'Cleaning',
    'Gardening',
    'Carpanter',
    'Electrician',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill the fields with current data
    _selectedCategory = widget.service.role;
    _descController = TextEditingController(text: widget.service.description);
    _expController = TextEditingController(
      text: widget.service.experience.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Service")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Skill Category",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // You can use a Dropdown here for categories
              DropdownButtonFormField(
                value: _selectedCategory,
                decoration: customInputDecoration("Category", Icons.category),
                items: _categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selectedCategory = val as String),
              ),
              const SizedBox(height: 20),
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              const Text(
                "Experience (Years)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _expController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.updateService(
                            serviceId: widget.service.id,
                            category: _selectedCategory!,
                            description: _descController.text,
                            experience: int.parse(_expController.text),
                          ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Save Changes"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
