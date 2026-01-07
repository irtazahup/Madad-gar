class ServiceProvider {
  final String id; // service_id
  final String userId;
  final String name; // from users.full_name
  final String role; // from services.skill_category
  final String address; // from users.location
  final String description; // from services.description
  final int experience; // from services.experience_years
  final String imageUrl; // placeholder for now

  ServiceProvider({
    required this.id,
    required this.userId,
    required this.name,
    required this.role,
    required this.address,
    required this.description,
    required this.experience,
    this.imageUrl = "https://ui-avatars.com/api/?background=random",
  });

  // Factory to create from Supabase Join query
  // Check this in your model file
  factory ServiceProvider.fromMap(Map<String, dynamic> map) {
    // Supabase returns the joined table as a nested Map
    final userData = map['users'] as Map<String, dynamic>;

    return ServiceProvider(
      id: map['id'],
      userId: map['user_id'],
      role: map['skill_category'],
      description: map['description'],
      experience: map['experience_years'],
      name: userData['full_name'], // Accessing the joined data
      address: userData['location'] ?? "Area unknown",
    );
  }
}
