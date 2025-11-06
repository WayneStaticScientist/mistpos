import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';

class ScreenAddStore extends StatefulWidget {
  const ScreenAddStore({super.key});

  @override
  State<ScreenAddStore> createState() => _ScreenAddStoreState();
}

class _ScreenAddStoreState extends State<ScreenAddStore> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final _adminController = Get.find<AdminController>();
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: "Add Store".text()),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            MistMordernLayout(
              label: "Store Details",
              children: [
                MistFormInput(
                  label: "Store Name",
                  validateString: "Store Name is required",
                  underLineColor: Colors.grey.withAlpha(200),
                  controller: _nameController,
                ),
                32.gapHeight,
                MistFormButton(
                  label: "Create Store",
                  icon: Icon(Icons.add),
                  onTap: _createStore,
                  isLoading: _loading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _createStore() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _loading = true;
    });
    final result = await _adminController.addCompany({
      "name": _nameController.text,
    });
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
    if (result) {
      Get.back();
      Toaster.showSuccess("Company Created Successfully");
    }
  }
}
