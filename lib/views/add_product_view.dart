import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cashier_controller.dart';
import '../widgets/sidebar.dart';
import '../widgets/custom_input.dart';

class AddProductView extends StatelessWidget {
  final CashierController controller = Get.put(CashierController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk'),
      ),
      drawer: Sidebar(currentRoute: '/add-product'),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomInput(
                label: 'Nama Produk',
                controller: controller.productNameController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Masukkan nama produk';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomInput(
                label: 'Harga Produk',
                controller: controller.productPriceController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Masukkan harga';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'Masukkan harga yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await controller.addNewProduct();
                    if (success) {
                      Get.snackbar(
                        'Sukses',
                        'Produk berhasil ditambahkan',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'Gagal menambahkan produk',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  }
                },
                child: Text('Tambah Produk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
