import 'package:as_pass/controller/service_controller.dart';
import 'package:as_pass/widgets/map_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

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
  bool _isLoading = false;

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
              // Replace your existing blue Container with this:
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1877F2).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.home_work, color: Color(0xFF1877F2)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            confirmedLat == null
                                ? "Where is your service located?"
                                : "Location Set: ($confirmedLat, $confirmedLng)",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Button to fetch current location (shortcut)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _getCurrentLocation,
                            icon: const Icon(Icons.my_location, size: 18),
                            label: const Text("Use Current"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF1877F2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Button to pick on a map (The Expert Way)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickOnMap,

                            icon: const Icon(Icons.map, size: 18),
                            label: const Text("Pick on Map"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                // If loading is true, we disable the button by passing null
                onPressed: _isLoading ? null : _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Publish Service",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ), // Submit Button
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

  // New State variables to hold the confirmed location
  double? confirmedLat;
  double? confirmedLng;
  String locationStatus = "No location selected";

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    // Expert Check: Ensure location is set before publishing
    if (confirmedLat == null || confirmedLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please set your Home/Shop location first"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ServiceController().uploadService(
        category: _selectedCategory,
        description: _descController.text,
        age: int.parse(_ageController.text),
        experience: int.parse(_expController.text),
        lat: confirmedLat!,
        lng: confirmedLng!,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Skill listed successfully!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        confirmedLat = position.latitude;
        confirmedLng = position.longitude;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Location captured! This will be your fixed service area.",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not get location. Try picking on map."),
        ),
      );
    }
  }

  // Function to launch the Map Picker
  Future<void> _pickOnMap() async {
    // Use current coordinates as a starting point, or default to (0,0)
    LatLng startPoint = LatLng(confirmedLat ?? 0.0, confirmedLng ?? 0.0);

    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(initialPosition: startPoint),
      ),
    );

    if (result != null) {
      setState(() {
        confirmedLat = result.latitude;
        confirmedLng = result.longitude;
      });
      _showSuccessSnackBar("Location selected from map!");
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
