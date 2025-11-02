import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/lucide.dart';
import 'package:mistpos/themes/app_theme.dart';

class MistFormInput extends StatefulWidget {
  final String label;
  final Widget? icon;
  final bool? isPasswordField;
  final int? maxLines;
  final bool? enabled;
  final Color? underLineColor;
  final String? validateString;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final int? validLength;
  final Widget? suffixIcon;
  const MistFormInput({
    super.key,
    required this.label,
    this.icon,
    this.isPasswordField,
    this.underLineColor,
    this.controller,
    this.validateString,
    this.validLength,
    this.keyboardType,
    this.enabled,
    this.maxLines = 1,
    this.suffixIcon,
  });

  @override
  State<MistFormInput> createState() => _MistFormInputState();
}

class _MistFormInputState extends State<MistFormInput> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      validator: (value) =>
          widget.validateString != null && (value == null || value.isEmpty)
          ? (widget.validLength == null
                ? widget.validateString
                : 'Minimum ${widget.validLength} characters required')
          : null,
      controller: widget.controller,
      enabled: widget.enabled,
      obscureText: (widget.isPasswordField != null && widget.isPasswordField!)
          ? !_isVisible
          : false,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        prefixIcon: widget.icon != null
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 8.0,
                ), // Adjust padding for a smaller icon
                child: SizedBox(
                  width: 16, // Set the intended width for the smaller icon
                  height: 16, // Set the intended height for the smaller icon
                  child: Center(
                    child: widget.icon,
                  ), // Use Center to keep the small icon centered
                ),
              )
            : null,
        label: widget.label.text(
          style: TextStyle(
            color: widget.underLineColor ?? Get.theme.colorScheme.primary,
          ),
        ),
        suffixIcon:
            widget.suffixIcon ??
            Iconify(
                  _isVisible ? Lucide.eye_off : Lucide.eye,
                  color: AppTheme.color(context),
                )
                .center()
                .sizedBox(width: 12, height: 12)
                .onTap(
                  () => setState(() {
                    _isVisible = !_isVisible;
                  }),
                )
                .visibleIf(widget.isPasswordField == true),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.underLineColor ?? Get.theme.colorScheme.primary,
          ),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: widget.underLineColor ?? Get.theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
