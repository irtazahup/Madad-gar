import 'package:supabase_flutter/supabase_flutter.dart';

class LoginApi {
  final SupabaseClient supabaseClient;

  LoginApi(this.supabaseClient);

  Future<AuthResponse> login(String email, String password) async {
    try {
      return await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}
