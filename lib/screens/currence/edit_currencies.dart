import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/models/exchange_rate_model.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';

class EditCurrencies extends StatefulWidget {
  const EditCurrencies({super.key});

  @override
  State<EditCurrencies> createState() => _EditCurrenciesState();
}

class _EditCurrenciesState extends State<EditCurrencies> {
  final _inventoryController = Get.find<InventoryController>();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inventoryController.loadCompany();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Currencies"),
        actions: [
          MistLoadIconButton(
            label: "save",
            onPressed: _save,
            isLoading: _isLoading,
          ),
        ],
      ),
      body: Obx(() {
        if (_inventoryController.loadingCompany.value) {
          return Center(child: MistLoader1());
        }
        if (_inventoryController.companyError.value.isNotEmpty) {
          return Center(child: Text(_inventoryController.companyError.value));
        }
        if (_inventoryController.company.value == null) {
          return Center(child: Text("No company found"));
        }
        return _buildCurrencySelector(
          _inventoryController.company.value!.exchangeRates,
        );
      }),
    );
  }

  Widget _buildCurrencySelector(ExchangeRateModel exchangeRates) {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        MistMordernLayout(
          label: "Edit Currency",
          children: [
            16.gapHeight,
            MistFormButton(
              label: "AddNew Currency",
              onTap: _addNewCurrency,
              icon: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        14.gapHeight,

        MistMordernLayout(
          label: "Exchange Rates",
          children: exchangeRates.rates.entries
              .map(
                (e) => ListTile(
                  title: Text(e.key),
                  onTap: () => _edit(e),
                  subtitle: Text(e.value.toString()),
                  trailing: IconButton(
                    onPressed: () => _delete(e),
                    icon: Icon(Icons.delete),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  _addNewCurrency() {
    final codeNameController = TextEditingController();
    final rateController = TextEditingController();
    Get.defaultDialog(
      title: "Add New Currency",
      content:
          [
            MistFormInput(
              label: "CurrencyCode",
              controller: codeNameController,
            ),
            MistFormInput(label: "Rate", controller: rateController),
          ].column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
      actions: [
        "close".text().textButton(onPressed: () => Get.back()),
        "add".text().textButton(
          onPressed: () {
            if (codeNameController.text.trim().isEmpty ||
                rateController.text.trim().isEmpty) {
              Toaster.showError("all fields are required");
              return;
            }
            final rate = double.tryParse(rateController.text.trim());
            if (rate == null) {
              Toaster.showError("Invalid rate");
              return;
            }
            if (codeNameController.text.trim().contains(" ")) {
              Toaster.showError("Currency code cannot contain spaces");
              return;
            }
            _inventoryController
                    .company
                    .value!
                    .exchangeRates
                    .rates[codeNameController.text.trim().toUpperCase()] =
                rate;
            _inventoryController.company.refresh();
            Get.back();
            Toaster.showSuccess("Currency added successfully");
          },
        ),
      ],
    );
  }

  _delete(MapEntry<String, double> e) {
    Get.defaultDialog(
      title: "Delete Currency",
      content: "Are you sure you want to delete ${e.key}".text(),
      actions: [
        "close".text().textButton(onPressed: () => Get.back()),
        "delete".text().textButton(
          onPressed: () {
            _inventoryController.company.value!.exchangeRates.rates.remove(
              e.key,
            );
            _inventoryController.company.refresh();
            Get.back();
            Toaster.showSuccess("Currency deleted successfully");
          },
        ),
      ],
    );
  }

  void _edit(MapEntry<String, double> e) {
    final rateController = TextEditingController(text: e.value.toString());
    Get.defaultDialog(
      title: "Add New Currency",
      content: [MistFormInput(label: "Rate", controller: rateController)]
          .column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
      actions: [
        "close".text().textButton(onPressed: () => Get.back()),
        "add".text().textButton(
          onPressed: () {
            if (rateController.text.trim().isEmpty) {
              Toaster.showError("all fields are required");
              return;
            }
            final rate = double.tryParse(rateController.text.trim());
            if (rate == null) {
              Toaster.showError("Invalid rate");
              return;
            }
            _inventoryController.company.value!.exchangeRates.rates[e.key] =
                rate;
            _inventoryController.company.refresh();
            Get.back();
            Toaster.showSuccess("Currency updated successfully");
          },
        ),
      ],
    );
  }

  _save() async {
    if (_inventoryController.company.value == null) {
      Toaster.showError("No company found");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final result = await _inventoryController.updateCurrency(
      _inventoryController.company.value!.exchangeRates,
    );
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (result) {
      Get.back();
      Toaster.showSuccess("Currency updated successfully");
    }
  }
}
