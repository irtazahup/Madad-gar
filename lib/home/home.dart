import 'package:as_pass/controller/home_controller.dart';
import 'package:as_pass/models/service_category.dart';
import 'package:as_pass/models/service_provider.dart';
import 'package:as_pass/widgets/service_providercard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:as_pass/widgets/add_service.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  // Sample data - Replace with your database fetch

  final List<ServiceCategory> categories = [
    ServiceCategory(
      name: 'Education',
      icon: Icons.school,
      color: Color(0xFF1877F2),
    ),
    ServiceCategory(
      name: 'Electrician',
      icon: Icons.electrical_services,
      color: Color(0xFFFF9800),
    ),
    ServiceCategory(
      name: 'Plumber',
      icon: Icons.plumbing,
      color: Color(0xFF2196F3),
    ),
    ServiceCategory(
      name: 'Carpenter',
      icon: Icons.construction,
      color: Color(0xFF4CAF50),
    ),
    ServiceCategory(
      name: 'Other Skills',
      icon: Icons.handyman,
      color: Color(0xFF9C27B0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   onPressed: () {
        //     // Handle back navigation
        //   },
        //   icon: const Icon(Icons.arrow_back, color: Color(0xFFFF5722)),
        // ),
        title: const Text(
          "Maddad'gar",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          SafeArea(
            child: Container(
              height: 35,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 31, 135, 245),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () => Get.to(() => AddServicePage()),
                    child: Text(
                      "Add Your Skills",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle notifications
            },
            icon: Icon(
              size: 35,
              Icons.person,
              color: Color.fromARGB(255, 58, 151, 244),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            height: Get.height * 0.1,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search the worker you want.....',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 40, 140, 234),
                  size: 28,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
              onChanged: (value) {
                // Implement search functionality
                print('Search: $value');
              },
            ),
          ),

          // Categories Section (Optional - you can remove if not needed)
          // Categories Section (Responsive Update)
          Stack(
            alignment:
                Alignment.centerRight, // Align children to the right center
            children: [
              // 1. The Main Category List (your existing code)
              Container(
                height: 110,
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final category = categories[index];

                      // Retaining the original width calculation (e.g., to fit 4 items)
                      // since the arrow now handles the scroll hint.
                      const double visibleItems =
                          4.5; // Adjusted to show 4 items cleanly
                      final double itemWidth = screenWidth / visibleItems;

                      return GestureDetector(
                        onTap: () {
                          print('Selected: ${category.name}');
                        },
                        child: Container(
                          width: itemWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 55,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: category.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  category.icon,
                                  color: category.color,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                category.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // 2. The Indicator Arrow (Overlay)
              Positioned(
                right: 0,
                // The arrow height will align with the ListView content
                child: Container(
                  height: 110, // Match the height of the ListView container
                  width: 30, // Small width for the fade/arrow area
                  decoration: BoxDecoration(
                    // Gradient creates a subtle fade effect over the right edge
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.white.withOpacity(
                          0.1,
                        ), // Starts mostly transparent
                        Colors.white, // Ends as the background color
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.grey, // Faded grey to look like a hint
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Service Providers List
          Expanded(
            child: FutureBuilder<List<ServiceProvider>>(
              future: HomeController()
                  .fetchServices(), // Your new fetch function
              builder: (context, snapshot) {
                // 1. Handle Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1877F2)),
                  );
                }

                // 2. Handle Error State
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // 3. Handle Empty State
                final providers = snapshot.data ?? [];
                if (providers.isEmpty) {
                  return const Center(
                    child: Text("No neighbors offering services nearby yet."),
                  );
                }

                // 4. Handle Data Ready State (Your existing ListView)
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    final provider = providers[index];
                    return ServiceProviderCard(provider: provider);
                  },
                );
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // Navigate to add service page
      //   },
      //   backgroundColor: const Color(0xFFFF5722),
      //   icon: const Icon(Icons.add, color: Colors.white),
      //   label: const Text(
      //     'Add Service',
      //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      //   ),
      // ),
    );
  }
}
