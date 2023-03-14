import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  late SharedPreferences _prefs;
  String? _token;
  bool get isAuthenticated => _token != null;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _token = _prefs.getString('token');
  }
}
