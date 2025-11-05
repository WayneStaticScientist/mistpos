import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/models/exchange_rate_model.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/screens/currence/edit_currencies.dart';
import 'package:mistpos/controllers/inventory_controller.dart';

class ScreenCurrency extends StatefulWidget {
  const ScreenCurrency({super.key});

  @override
  State<ScreenCurrency> createState() => _ScreenCurrencyState();
}

class _ScreenCurrencyState extends State<ScreenCurrency> {
  final _userController = Get.find<UserController>();
  final _inventoryController = Get.find<InventoryController>();
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
        title: Text("Currencies"),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () {},
              icon: CircularProgressIndicator(
                color: Get.theme.colorScheme.primary,
              ),
            ).visibleIf(_userController.switchingCurrency.value),
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
      }).constrained(maxWidth: ScreenSizes.maxWidth).center(),
      floatingActionButton: Obx(() {
        if (_inventoryController.loadingCompany.value) {
          return SizedBox.shrink();
        }
        if (_inventoryController.company.value == null) {
          return SizedBox.shrink();
        }
        if (_inventoryController.company.value!.owner !=
            _userController.user.value!.hexId) {
          return SizedBox.shrink();
        }
        return FloatingActionButton(
          onPressed: _editCompany,
          child: Icon(Icons.edit, color: Colors.white),
        );
      }),
    );
  }

  Widget _buildCurrencySelector(ExchangeRateModel exchangeRates) {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        MistMordernLayout(
          label: "Current User Currency Notation",
          children: [
            _userController.user.value!.baseCurrence.text(
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            18.gapHeight,
            MistFormButton(
              label: "Revert to Base Currency",
              icon: Iconify(Bx.history, color: Colors.white),
              onTap: () => _userController.switchCurrency("USD"),
            ),
          ],
        ),
        14.gapHeight,
        "Tap currency to switch to that currency".text(
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        MistMordernLayout(
          label: "Exchange Rates",
          children: exchangeRates.rates.entries
              .map(
                (e) => ListTile(
                  tileColor: e.key == _userController.user.value!.baseCurrence
                      ? Get.theme.colorScheme.primary.withAlpha(100)
                      : null,
                  onTap: () => _userController.switchCurrency(e.key),
                  title: Text(e.key),
                  subtitle: Text(
                    e.value.toString(),
                    style: TextStyle(
                      color: e.value > 1 ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  void _editCompany() {
    Get.to(() => EditCurrencies());
  }
}
