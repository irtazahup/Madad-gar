import 'package:as_pass/controller/home_controller.dart';
import 'package:as_pass/models/service_category.dart';
import 'package:as_pass/models/service_provider.dart';
import 'package:as_pass/widgets/service_providercard.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:as_pass/widgets/add_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  double _currentSearchRadius = 1000.0;
  // Starts at 5km
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
              future: _getHyperlocalServices(), // Use the new helper method
              builder: (context, snapshot) {
                // 1. Handle Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1877F2)),
                  );
                }

                // 2. Handle Error State
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_off,
                          size: 40,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "${snapshot.error}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // This re-triggers the build and the permission request
                            (context as Element).markNeedsBuild();
                            // Or better: call Geolocator.openAppSettings();
                          },
                          child: const Text("Grant Permission"),
                        ),
                      ],
                    ),
                  );
                }

                // 3. Handle Empty State
                final providers = snapshot.data ?? [];
                if (providers.isEmpty) {
                  // Calculate what the next step would be
                  final int currentKm = (_currentSearchRadius / 1000).toInt();
                  final int nextKm = currentKm + 5;
                  final bool canExpand = nextKm <= 50; // Cap at 50km

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_searching,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "No neighbors within ${currentKm}km",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            canExpand
                                ? "Try expanding your search to find providers in nearby neighborhoods."
                                : "We couldn't find anyone within 50km. Try checking back later or inviting neighbors!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 25),

                          if (canExpand)
                            SizedBox(
                              width: 220,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _currentSearchRadius +=
                                        5000.0; // Increment by 5km
                                  });
                                },
                                icon: const Icon(
                                  Icons.add_location_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                label: Text(
                                  "Search up to ${nextKm}km",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1877F2),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            )
                          else
                            // Reset button if they want to go back to 5km
                            TextButton.icon(
                              onPressed: () =>
                                  setState(() => _currentSearchRadius = 5000.0),
                              icon: const Icon(Icons.refresh),
                              label: const Text("Reset to 5km"),
                            ),
                        ],
                      ),
                    ),
                  );
                }

                // 4. Handle Data Ready State
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

  // 1. Define a helper method to handle the location-based fetch
  Future<List<ServiceProvider>> _getHyperlocalServices() async {
    LocationPermission permission;

    // 1. Check if the user has already given permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // 2. This is what triggers the "Allow Maddad'gar to access location?" popup
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // User tapped "Deny" again
        return Future.error(
          'Location permissions are denied. We need them to find nearby workers.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // User tapped "Don't ask again"
      return Future.error(
        'Location permissions are permanently denied. Please enable them in App Settings.',
      );
    }

    // 3. If we reach here, we have permission!
    Position position = await Geolocator.getCurrentPosition();

    return HomeController().fetchServices(
      userLat: position.latitude,
      userLng: position.longitude,
      radiusInMeters: _currentSearchRadius,
    );
  }
}
