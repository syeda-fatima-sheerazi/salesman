import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  SessionService._();
  static final SessionService instance = SessionService._();

  static const String _emailKey = 'logged_in_email';

  Future<void> saveSession(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<bool> hasSession() async {
    final email = await getSavedEmail();
    return email != null && email.isNotEmpty;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
  }
}
