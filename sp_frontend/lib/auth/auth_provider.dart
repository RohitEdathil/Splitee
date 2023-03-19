import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_frontend/util/api_client.dart';

class AuthProvider {
  late SharedPreferences _prefs;
  String? _token;
  String? userId;
  bool get isAuthenticated => _token != null && userId != null;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    // Attempts to load saved credentials
    _token = _prefs.getString('token');
    userId = _prefs.getString('userId');

    if (_token != null) {
      // Passes token to API client
      client.setToken(_token!);
    }
  }

  Future<String?> login(String userId, String password) async {
    final response = await client.post('auth/signin', {
      'userId': userId,
      'password': password,
    });

    // Sets and saves credentials on success
    if (response['token'] != null) {
      _token = response['token'];
      this.userId = response['userId'];
      _prefs.setString('token', _token!);
      _prefs.setString('userId', userId);
      client.setToken(_token!);
    }

    return response['error'];
  }

  Future<String?> signUp(
      String userId, String password, String name, String email) async {
    final response = await client.post('auth/signup', {
      'userId': userId,
      'password': password,
      'name': name,
      'email': email,
    });

    // Sets and saves credentials on success
    if (response['token'] != null) {
      _token = response['token'];
      _prefs.setString('token', _token!);
      client.setToken(_token!);
    }

    return response['error'];
  }

  void logOut() {
    // Removes and deletes credentials
    _token = null;
    _prefs.remove('token');
    userId = null;
    _prefs.remove('userId');
    client.setToken('');
  }
}
