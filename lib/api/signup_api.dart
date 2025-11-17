import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpApi {
  final SupabaseClient supabaseClient;

  SignUpApi(this.supabaseClient);

  Future<AuthResponse> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      // Temporarily remove custom data to test if that's causing the database error
      final AuthResponse response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: ({"full_name": name}),
      );

      return response;
    } catch (e) {
      throw Exception("Sign Up failed: $e");
    }
  }
}
