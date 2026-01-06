import 'package:flutter/material.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _expController = TextEditingController();
  String _selectedCategory = 'Tutoring';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Your Skill",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1877F2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What can you help with?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Category Dropdown
              DropdownButtonFormField(
                value: _selectedCategory,
                decoration: _inputDecoration("Category", Icons.category),
                items: _categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) =>
                    setState(() => _selectedCategory = val as String),
              ),
              const SizedBox(height: 20),

              // Age & Experience Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Your Age", Icons.person),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormField(
                      controller: _expController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Years Exp.", Icons.work),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Description
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: _inputDecoration(
                  "Describe your service...",
                  Icons.description,
                ),
                validator: (val) =>
                    val!.length < 10 ? "Please provide more detail" : null,
              ),
              const SizedBox(height: 30),

              // Location Status Card (Visual Placeholder)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1877F2).withOpacity(0.2),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF1877F2)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Location will be set to your current GPS position for neighbors to find you.",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Submit Button
              ElevatedButton(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Publish Service",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: const Color(0xFF1877F2)),
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      // Logic to call Controller and save to Supabase
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Processing...")));
    }
  }
}
