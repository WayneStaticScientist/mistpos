import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:mistpos/utils/permissions.dart';
import 'package:mistpos/widgets/layouts/chips.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/admin_controller.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';

class ScreenAddEmployee extends StatefulWidget {
  const ScreenAddEmployee({super.key});

  @override
  State<ScreenAddEmployee> createState() => _ScreenAddEmployeeState();
}

class _ScreenAddEmployeeState extends State<ScreenAddEmployee> {
  String _pin = "";
  String _role = "cashier";
  final _formKey = GlobalKey<FormState>();
  final _roles = ['cashier', 'manager', 'admin'];
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _adminController = Get.find<AdminController>();
  final _tillNumberController = TextEditingController();
  final _selectedPermissions = <String>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text("Add Employee"),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.chevron_left),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(5),
          children: [
            [
                  "User Information".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  14.gapHeight,
                  MistFormInput(
                    validateString: "Full Name is required",
                    label: "Full Name",
                    icon: Iconify(Bx.user, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _nameController,
                  ),
                  14.gapHeight,
                  MistFormInput(
                    validateString: "Email is required",
                    label: "Email",
                    icon: Iconify(
                      Bx.envelope,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _emailController,
                  ),
                  24.gapHeight,
                  "User role".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  14.gapHeight,
                  DropdownButton(
                    value: _role,
                    isDense: true,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        _role = value ?? _roles.first;
                      });
                    },
                    items: List.generate(
                      _roles.length,
                      (index) => DropdownMenuItem(
                        value: _roles[index],
                        child: _roles[index].text(
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ).sizedBox(width: double.infinity),
                  if (_role == "cashier") ...[
                    14.gapHeight,
                    MistFormInput(
                      validateString: "Till Number is required",
                      label: "Cashier Till Number",
                      keyboardType: TextInputType.number,
                      icon: Iconify(
                        Bx.user_pin,
                        color: Colors.grey.withAlpha(200),
                      ),
                      underLineColor: Colors.grey.withAlpha(200),
                      controller: _tillNumberController,
                    ),
                  ],
                  if (_role == "manager") ...[
                    32.gapHeight,
                    "Select Manager Permissions".text(),
                    Wrap(
                      children: UserPermissions.permissions.map((e) {
                        final selected = _selectedPermissions.contains(e.value);
                        return MistChip(
                          label: e.name,
                          selected: selected,
                        ).onTap(() {
                          setState(() {
                            if (selected) {
                              _selectedPermissions.remove(e.value);
                            } else {
                              _selectedPermissions.add(e.value);
                            }
                          });
                        });
                      }).toList(),
                    ),
                  ],
                  24.gapHeight,
                  "User Pin".text(
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  14.gapHeight,
                  Pinput(
                    onCompleted: (pin) => setState(() {
                      _pin = pin;
                    }),
                  ),
                  24.gapHeight,
                  Obx(
                    () => MistFormButton(
                      icon: Icon(Icons.add),
                      isLoading: _adminController.addingEmployee.value,
                      label: "Add Employee",
                      onTap: _addEmployCall,
                    ).sizedBox(width: double.infinity),
                  ),
                ]
                .column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                )
                .padding(EdgeInsets.all(12))
                .decoratedBox(
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
          ],
        ),
      ).constrained(maxWidth: 600).center(),
    );
  }

  _addEmployCall() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_pin.trim().isEmpty) {
      Toaster.showError("pin is required");
      return;
    }
    if (_role.trim().isEmpty) {
      Toaster.showError("role is required");
      return;
    }
    int tillNumber = 0;
    if (_role == "cashier") {
      if (_tillNumberController.text.trim().isEmpty) {
        Toaster.showError("till number is required");
        return;
      }
      try {
        tillNumber = int.parse(_tillNumberController.text);
        if (tillNumber <= 0) {
          Toaster.showError("invalid till number");
          return;
        }
      } catch (e) {
        Toaster.showError("invalid till number");
      }
    }
    if (_nameController.text.trim().split(" ").length < 2) {
      Toaster.showError("Full Name  is required e.g John Doe");
      return;
    }
    final result = await _adminController.addEmployee({
      "user": {
        "fullName": _nameController.text.trim(),
        "email": _emailController.text,
        "role": _role,
        "pin": _pin,
        "till": tillNumber,
        'permissions': _selectedPermissions,
      },
    });
    if (result) {
      Get.back();
      Toaster.showSuccess("employee added succesfully");
    }
  }
}
