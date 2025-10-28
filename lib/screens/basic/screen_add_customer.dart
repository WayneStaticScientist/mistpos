import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/models/customer_model.dart';
import 'package:country_picker/country_picker.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';

class ScreenAddCustomer extends StatefulWidget {
  const ScreenAddCustomer({super.key});

  @override
  State<ScreenAddCustomer> createState() => _ScreenAddCustomerState();
}

class _ScreenAddCustomerState extends State<ScreenAddCustomer> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  final _addressController = TextEditingController();
  final _countryController = TextEditingController();
  final _itemsController = Get.find<ItemsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Get.theme.colorScheme.onPrimary,
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
                  18.gapHeight,
                  MistFormInput(
                    validateString: "Full Name is required",
                    label: "Full Name",
                    icon: Iconify(Bx.user, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _nameController,
                  ),
                  18.gapHeight,
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
                  18.gapHeight,
                  MistFormInput(
                    label: "Phone Number",
                    icon: Iconify(Bx.phone, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _phoneController,
                  ),
                  18.gapHeight,
                  MistFormInput(
                    label: 'Country',
                    controller: _countryController,
                    enabled: false,
                    icon: Iconify(Bx.flag, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    validateString: "Please select a country",
                  ).onTap(_selectCountry),
                  18.gapHeight,
                  MistFormInput(
                    label: "City",
                    icon: Iconify(
                      Bx.bxs_city,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _cityController,
                  ),
                  18.gapHeight,

                  MistFormInput(
                    label: "Address",
                    icon: Iconify(
                      Bx.street_view,
                      color: Colors.grey.withAlpha(200),
                    ),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _addressController,
                  ),
                  18.gapHeight,

                  MistFormInput(
                    label: "Notes",
                    icon: Iconify(Bx.note, color: Colors.grey.withAlpha(200)),
                    underLineColor: Colors.grey.withAlpha(200),
                    controller: _notesController,
                    maxLines: null,
                  ),

                  24.gapHeight,
                  MistFormButton(
                    icon: Icon(Icons.add),
                    label: "Add Customer",
                    onTap: _addCustomerCall,
                  ).sizedBox(width: double.infinity),
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

  void _selectCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          _countryController.text = country.name;
        });
      },
    );
  }

  _addCustomerCall() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_nameController.text.trim().split(" ").length < 2) {
      Toaster.showError("Full Name  is required e.g John Doe");
      return;
    }
    final customer = CustomerModel(
      email: _emailController.text.trim(),
      fullName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      city: _cityController.text.trim(),
      notes: _notesController.text.trim(),
      country: _countryController.text.trim(),
      points: 0,
      visits: 0,
      company: "",
      address: _addressController.text.trim(),
      purchaseValue: 0,
      inboundProfit: 0,
      hexId: "",
    );
    final response = await _itemsController.addCustomer(customer);
    if (response && mounted) {
      Get.back();
      Toaster.showSuccess("Customer added successfully");
    }
  }
}
