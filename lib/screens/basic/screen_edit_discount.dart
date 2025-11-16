import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:mistpos/models/discount_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/widgets/buttons/mist_loaded_icon_button.dart';

class ScreenEditDiscount extends StatefulWidget {
  final DiscountModel model;
  const ScreenEditDiscount({super.key, required this.model});
  @override
  State<ScreenEditDiscount> createState() => _ScreenEditDiscountState();
}

class _ScreenEditDiscountState extends State<ScreenEditDiscount> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.model.name);
  late final _valueController = TextEditingController(
    text: widget.model.percentage
        ? widget.model.value.toString()
        : CurrenceConverter.selectedCurrency(
            widget.model.value,
          ).toStringAsFixed(4),
  );
  bool _loading = false;
  final _itemController = Get.find<ItemsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Edit Discount".text(),
        actions: [
          MistLoadIconButton(
            label: "update",
            onPressed: _update,
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
                  label: "Value ${!widget.model.percentage ? '' : '0-99%'}",
                  underLineColor: Colors.grey,
                  controller: _valueController,
                  validateString: "Value is required",
                  keyboardType: TextInputType.number,
                ),
                18.gapHeight,
                ListTile(
                  onTap: () => {
                    setState(() {
                      widget.model.percentage = !widget.model.percentage;
                    }),
                  },
                  title: "Summation Discount".text(),
                  subtitle: "subtract amount from total".text(
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  contentPadding: EdgeInsets.all(0),
                  trailing: Switch(
                    value: !widget.model.percentage,
                    onChanged: (e) {
                      setState(() {
                        widget.model.percentage = e;
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

  _update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
    });
    widget.model.name = _nameController.text;
    widget.model.value = CurrenceConverter.baseCurrency(
      double.parse(_valueController.text),
    );
    final response = await _itemController.updateDiscount(
      widget.model.toJson(),
      widget.model.hexId,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
    if (response) {
      Get.back();
      Toaster.showSuccess("Updated Succeffuly");
    }
  }
}
