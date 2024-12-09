import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class Sidebar extends StatelessWidget {
  final String currentRoute;

  const Sidebar({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'POS System',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Selamat Datang, ${authController.user.value?.username ?? ""}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            selected: currentRoute == '/dashboard',
            onTap: () => Get.offNamed('/dashboard'),
          ),
          ListTile(
            leading: Icon(Icons.point_of_sale),
            title: Text('Kasir'),
            selected: currentRoute == '/cashier',
            onTap: () => Get.offNamed('/cashier'),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Tambah Produk'),
            selected: currentRoute == '/add-product',
            onTap: () => Get.offNamed('/add-product'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => authController.logout(),
          ),
        ],
      ),
    );
  }
}
