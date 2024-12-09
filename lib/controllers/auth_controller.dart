import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class AuthController extends GetxController {
  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<bool> login(String username, String password) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await http.post(
        Uri.parse('http://192.168.1.8:8000/login.php'),
        body: {
          'username': username,
          'password': password,
        },
      );

      final data = json.decode(response.body);

      if (data['success']) {
        user.value = User.fromJson(data['user']);
        return true;
      } else {
        error.value = data['message'] ?? 'Login failed';
        return false;
      }
    } catch (e) {
      error.value = 'Network error occurred';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    user.value = null;
    Get.offAllNamed('/login');
  }
}