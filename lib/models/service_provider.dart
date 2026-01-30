class ServiceProvider {
  final String id; // service_id
  final String userId;
  final String name; // from users.full_name
  final String role; // from services.skill_category
  final String address; // from users.location
  final String description; // from services.description
  final int experience; // from services.experience_years
  final String imageUrl; // placeholder for now
  final double? distance; // in kilometers
  final double rating;
  final int totalReviews;

  ServiceProvider({
    required this.id,
    required this.userId,
    required this.name,
    required this.role,
    required this.address,
    required this.description,
    required this.experience,
    this.imageUrl = "https://ui-avatars.com/api/?background=random",
    required this.distance,
    required this.rating,
    required this.totalReviews,
  });

  // Factory to create from Supabase Join query
  // Check this in your model file
  factory ServiceProvider.fromMap(Map<String, dynamic> map) {
    final String displayName =
        map['provider_name'] ??
        (map['users'] != null ? map['users']['full_name'] : 'Neighbor');

    return ServiceProvider(
      id: map['id'] ?? map['service_id'],
      userId: map['user_id'] ?? map['provider_id'] ?? '',
      role: map['skill_category'] ?? '',
      description: map['description'] ?? '',
      experience: map['experience_years'] ?? 0,
      address: map['location_name'] ?? 'Local Area',
      name: displayName,
      distance: map['distance_km']?.toDouble(),
      // Read the new rating data
      rating: (map['avg_rating'] ?? 0.0).toDouble(),
      totalReviews: map['total_reviews'] ?? 0,
    );
  }
}
