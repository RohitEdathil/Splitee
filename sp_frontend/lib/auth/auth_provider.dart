import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_frontend/util/api_client.dart';

class AuthProvider {
  late SharedPreferences _prefs;
  String? _token;
  bool get isAuthenticated => _token != null;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    _token = _prefs.getString('token');

    if (_token != null) {
      client.setToken(_token!);
    }
  }

  Future<String?> login(String userId, String password) async {
    final response = await client.post('auth/signin', {
      'userId': userId,
      'password': password,
    });

    if (response['token'] != null) {
      _token = response['token'];
      _prefs.setString('token', _token!);
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

    if (response['token'] != null) {
      _token = response['token'];
      _prefs.setString('token', _token!);
      client.setToken(_token!);
    }

    return response['error'];
  }

  void logOut() {
    _token = null;
    _prefs.remove('token');
    client.setToken('');
  }
}
