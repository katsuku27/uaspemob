import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'views/login_view.dart';
import 'views/dashboard_view.dart';
import 'views/cashier_view.dart';
import 'views/add_product_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'POS System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginView(),
          transition: Transition.fade,
        ),
        GetPage(
          name: '/dashboard',
          page: () => DashboardView(),
          transition: Transition.fadeIn,
          middlewares: [
            AuthMiddleware(),
          ],
        ),
        GetPage(
          name: '/cashier',
          page: () => CashierView(),
          transition: Transition.fadeIn,
          middlewares: [
            AuthMiddleware(),
          ],
        ),
        GetPage(
          name: '/add-product',
          page: () => AddProductView(),
          transition: Transition.rightToLeft,
          middlewares: [
            AuthMiddleware(),
          ],
        ),
      ],
    );
  }
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return Get.find<AuthController>().user.value == null
        ? RouteSettings(name: '/login')
        : null;
  }
}
