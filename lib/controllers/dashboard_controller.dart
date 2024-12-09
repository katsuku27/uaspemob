import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardController extends GetxController {
  final RxDouble todaySales = 0.0.obs;
  final RxInt transactionCount = 0.obs;
  final RxList<Map<String, dynamic>> weeklySales = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('http://192.168.1.8:8000/dashboard.php'),
      );

      print('Response: ${response.body}');

      final data = json.decode(response.body);
      
      if (data['success']) {
        if (data['today_stats'] != null) {
          var totalSales = data['today_stats']['total_sales'];
          todaySales.value = totalSales != null ? double.parse(totalSales.toString()) : 0.0;
          
          var count = data['today_stats']['transaction_count'];
          transactionCount.value = count != null ? int.parse(count.toString()) : 0;
          
          print('Transaction Count: ${transactionCount.value}'); 
        }

        if (data['weekly_sales'] != null) {
          weeklySales.value = List<Map<String, dynamic>>.from(data['weekly_sales']);
        }
      }
    } catch (e) {
      print('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    fetchDashboardData();
  }
}