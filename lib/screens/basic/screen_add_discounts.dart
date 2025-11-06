import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/models/discount_model.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';

class ScreenAddDiscounts extends StatefulWidget {
  const ScreenAddDiscounts({super.key});

  @override
  State<ScreenAddDiscounts> createState() => _ScreenAddDiscountsState();
}

class _ScreenAddDiscountsState extends State<ScreenAddDiscounts> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final _itemController = Get.find<ItemsController>();
  bool _summation = false;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Discounts".text(),
        actions: [
          MistLoadIconButton(
            label: "Save",
            onPressed: _saveItem,
            isLoading: _loading,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            MistMordernLayout(
              label: "info",
              children: [
                MistFormInput(
                  label: "Name ",
                  validateString: "Name is required",
                  controller: _nameController,
                  underLineColor: Colors.grey,
                ),
                18.gapHeight,
                MistFormInput(
                  label: "Value ${_summation ? '' : '0-99%'}",
                  underLineColor: Colors.grey,
                  controller: _valueController,
                  validateString: "Value is required",
                  keyboardType: TextInputType.number,
                ),
                18.gapHeight,
                ListTile(
                  onTap: () => {
                    setState(() {
                      _summation = !_summation;
                    }),
                  },
                  title: "Summation Discount".text(),
                  subtitle: "subtract amount from total".text(
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  contentPadding: EdgeInsets.all(0),
                  trailing: Switch(
                    value: _summation,
                    onChanged: (e) {
                      setState(() {
                        _summation = e;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _saveItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final name = _nameController.text;
    final value = double.tryParse(_valueController.text);
    if (value == null) {
      Toaster.showError("invalid value");
      return;
    }
    if (!_summation && (value > 99 || value < 0)) {
      Toaster.showError("invalid discount range 0-99");
      return;
    }
    setState(() {
      _loading = true;
    });
    final response = await _itemController.addDiscount(
      DiscountModel(
        name: name,
        value: value,
        company: "",
        percentage: !_summation,
      ).toJson(),
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
    if (response) {
      Get.back();
      Toaster.showSuccess("discount added");
    }
  }
}
