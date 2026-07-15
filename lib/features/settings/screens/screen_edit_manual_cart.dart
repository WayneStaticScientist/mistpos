import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/data/models/item_model.dart';
import 'package:mistpos/core/responsive/screen_sizes.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/core/widgets/inputs/input_form.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/inventory/controllers/items_controller.dart';
import 'package:mistpos/core/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/features/settings/screens/screen_select_discount.dart';

class ScreenEditManualCart extends StatefulWidget {
  final Map<String, dynamic> map;
  const ScreenEditManualCart({super.key, required this.map});

  @override
  State<ScreenEditManualCart> createState() => _ScreenEditManualCartState();
}

class _ScreenEditManualCartState extends State<ScreenEditManualCart> {
  final _itemsListController = Get.find<ItemsController>();
  final _userController = Get.find<UserController>();

  late final _countController = TextEditingController(
    text: (widget.map['count'] as num).toDouble().toString(),
  );
  late double track = (widget.map['count'] as num).toDouble();
  late String? discountId = widget.map['discountId'] as String?;
  late bool percentageDiscount =
      widget.map['percentageDiscount'] as bool? ?? true;
  late double discount = (widget.map['discount'] as num?)?.toDouble() ?? 0.0;
  double price = 0;
  late double floatAmount = widget.map['qouted'] as double? ?? 0.0;
  late final Map<String, bool> dataMap =
      widget.map['dataMap'] as Map<String, bool>? ?? {};
  late final item = widget.map['item'] as ItemModel;

  late final priceTextController = TextEditingController(
    text: (CurrenceConverter.selectedCurrency(item.price)).toString(),
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Get.theme.colorScheme.primary;

    // Fixed math precedence bug: wrap with parentheses so count * item.price is evaluated first
    price =
        ((double.tryParse(_countController.text) ?? 0.0) * item.price) +
        floatAmount;
    if (discountId != null) {
      price = !percentageDiscount
          ? (price - discount)
          : (price - (discount * price / 100));
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF14161F)
          : const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Edit Item Details",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: -0.5,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          // Premium Price Badge
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary, primary.withAlpha(200)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primary.withAlpha(40),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sell_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 8),
                  Text(
                    CurrenceConverter.getCurrenceFloatInStrings(
                      price,
                      _userController.user.value?.baseCurrence ?? '',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            children: [
              // Card 1: Item Header & Stepper
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E202C) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withAlpha(10)
                        : Colors.grey.shade200,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 30 : 8),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: primary.withAlpha(15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.shopping_bag_rounded,
                              color: primary,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.category.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                  color: isDark
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "QUANTITY",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                        Row(
                          children: [
                            _buildStepperButton(
                              icon: Icons.remove_rounded,
                              onPressed: () {
                                double val =
                                    double.tryParse(_countController.text) ?? 1;
                                if (val > 1) {
                                  _countController.text = (val - 1).toString();
                                  setState(() {});
                                }
                              },
                              isDark: isDark,
                            ),
                            Container(
                              width: 80,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                controller: _countController,
                                onChanged: (e) => setState(() {}),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: isDark
                                          ? Colors.white.withAlpha(20)
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: isDark
                                          ? Colors.white.withAlpha(10)
                                          : Colors.grey.shade200,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: primary,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: isDark
                                      ? Colors.white.withAlpha(5)
                                      : Colors.black.withAlpha(3),
                                ),
                              ),
                            ),
                            _buildStepperButton(
                              icon: Icons.add_rounded,
                              onPressed: () {
                                double val =
                                    double.tryParse(_countController.text) ?? 0;
                                _countController.text = (val + 1).toString();
                                setState(() {});
                              },
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Card 2: Custom variable pricing (if price is 0)
              if (item.price == 0) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E202C) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withAlpha(10)
                          : Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDark ? 30 : 8),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "VARIABLE PRICE",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      MistFormInput(
                        label: "Price Value",
                        icon: Text(
                          _userController.user.value?.baseCurrence ?? 'USD',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: priceTextController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Card 3: Modifiers Section (renders dynamically below via _generatedModifiers)
              if (item.modifiers != null && item.modifiers!.isNotEmpty) ...[
                _generatedModifiers(isDark, primary),
                const SizedBox(height: 20),
              ],

              // Card 4: Discount Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E202C) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withAlpha(10)
                        : Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(isDark ? 30 : 8),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.percent_rounded, color: primary, size: 18),
                        const SizedBox(width: 12),
                        Text(
                          "DISCOUNT",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (discountId != null) ...[
                      // Active Discount Display
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.red.withAlpha(40),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.withAlpha(30),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.label_important_rounded,
                                color: Colors.redAccent,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Discount Applied",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    percentageDiscount
                                        ? "Save $discount% off item total"
                                        : "Flat discount of ${CurrenceConverter.getCurrenceFloatInStrings(discount, _userController.user.value?.baseCurrence ?? '')}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _removeDiscount,
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.redAccent,
                              ),
                              tooltip: "Remove Discount",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Apply / Edit Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: Icon(
                          discountId == null
                              ? Icons.add_rounded
                              : Icons.edit_rounded,
                          size: 18,
                        ),
                        label: Text(
                          discountId == null
                              ? "Add Discount"
                              : "Change Discount",
                        ),
                        onPressed: _addDiscount,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: primary.withAlpha(120),
                            width: 1.5,
                          ),
                          foregroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E202C) : Colors.white,
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withAlpha(10)
                    : Colors.grey.shade200,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _addToCart,
                  icon: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    "UPDATE CART",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white.withAlpha(10) : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _generatedModifiers(bool isDark, Color primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E202C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withAlpha(10) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Item Modifiers",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          ...item.modifiers!.map<Widget>(
            (e) => _makeModifierTab(e, isDark, primary),
          ),
        ],
      ),
    );
  }

  Widget _makeModifierTab(String id, bool isDark, Color primary) {
    try {
      final modifier = _itemsListController.modifiers.firstWhere(
        (element) => element.hexId == id,
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          modifier.name.text(
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          // Wrap modifier choices in premium grid chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: modifier.list.map<Widget>((e) {
              final activeKey = "$id-${e.key}${e.value}";
              final isActive = dataMap.containsKey(activeKey);

              return InkWell(
                onTap: () => _addToMap(activeKey, e.value),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? primary.withAlpha(20)
                        : (isDark
                              ? Colors.white.withAlpha(5)
                              : Colors.black.withAlpha(3)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive
                          ? primary
                          : (isDark
                                ? Colors.white.withAlpha(10)
                                : Colors.grey.shade200),
                      width: isActive ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isActive) ...[
                        Icon(
                          Icons.check_circle_rounded,
                          color: primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        e.key,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isActive
                              ? primary
                              : (isDark
                                    ? Colors.grey.shade300
                                    : Colors.black87),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "(+${CurrenceConverter.getCurrenceFloatInStrings(e.value, _userController.user.value?.baseCurrence ?? '')})",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? primary.withAlpha(180)
                              : (isDark
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade500),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      );
    } catch (e) {
      return const SizedBox();
    }
  }

  void _addToMap(String s, double amount) {
    if (dataMap.containsKey(s)) {
      dataMap.remove(s);
      setState(() {
        floatAmount -= amount;
      });
    } else {
      dataMap[s] = true;
      setState(() {
        floatAmount += amount;
      });
    }
  }

  void _addToCart() {
    double? addenum = 0.0;
    if (item.price == 0 && priceTextController.text.isEmpty) {
      Toaster.showError("price is required for non price items");
      return;
    }
    if (item.price == 0) {
      double? val = double.tryParse(priceTextController.text);
      if (val == null || val <= 0) {
        Toaster.showError("invalid price");
        return;
      }
      item.price = CurrenceConverter.baseCurrency(val);
    }
    if (item.soldBy == "Each") {
      final int? projected = double.tryParse(_countController.text)?.toInt();
      if (projected == null || projected <= 0) {
        Toaster.showError(
          "Invalid descrete number for non weighted items , valids numbers are only  1 , 2 , 3 and so on",
        );
        return;
      }
    } else {
      double? projected = double.tryParse(_countController.text);
      if (projected == null) {
        Toaster.showError("Invalid quantity number");
        return;
      }
    }

    _itemsListController.addSelectedItem(
      item,
      count: double.tryParse(_countController.text) ?? 1,
      dataMap: dataMap,
      addenum: addenum,
      qouted: floatAmount,
      restoreAmount: track - (double.tryParse(_countController.text) ?? 1),
      discountId: discountId,
      discount: discount,
      percentageDiscount: percentageDiscount,
    );
    Get.back();
  }

  Future<void> _addDiscount() async {
    final result = await Get.to(() => ScreenSelectDiscount());
    if (result == null) return;
    setState(() {
      discount = result.value;
      discountId = result.hexId;
      percentageDiscount = result.percentage;
    });
  }

  void _removeDiscount() {
    setState(() {
      discount = 0.0;
      discountId = null;
    });
  }
}
