import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/screens/basic/screen_add_customer.dart';

class ScreensListCustomers extends StatefulWidget {
  const ScreensListCustomers({super.key});

  @override
  State<ScreensListCustomers> createState() => _ScreensListCustomersState();
}

class _ScreensListCustomersState extends State<ScreensListCustomers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addCustomer,
        child: Iconify(Bx.plus, color: Colors.white),
      ),
    );
  }

  void _addCustomer() {
    Get.to(() => ScreenAddCustomer());
  }
}
