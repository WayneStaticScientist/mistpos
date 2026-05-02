import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/utils/toast.dart';

class AutomatedPhoneVerificationScreen extends StatefulWidget {
  final String phone;
  final String type;
  const AutomatedPhoneVerificationScreen({
    super.key,
    required this.phone,
    this.type = 'daily',
  });

  @override
  State<AutomatedPhoneVerificationScreen> createState() =>
      _AutomatedPhoneVerificationScreenState();
}

class _AutomatedPhoneVerificationScreenState
    extends State<AutomatedPhoneVerificationScreen> {
  final _codeController = TextEditingController();
  final _inventoryController = Get.find<InventoryController>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Phone"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter verification code",
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "A code was sent to ${widget.phone}. Enter it below to verify your phone number.",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 28),
            Pinput(
              length: 6,
              controller: _codeController,
              defaultPinTheme: PinTheme(
                width: 56,
                height: 56,
                textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.primary.withAlpha(102),
                    width: 1.5,
                  ),
                ),
              ),
              onCompleted: _verifyCode,
            ),
            const SizedBox(height: 32),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _inventoryController.verifyingAutomatedSyncPhone.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("VERIFY CODE"),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn’t receive a code? "),
                TextButton(onPressed: _resendCode, child: const Text("Resend")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _verifyCode([String? code]) async {
    final verificationCode = (code ?? _codeController.text).trim();
    if (verificationCode.isEmpty) {
      Toaster.showError("Please enter the verification code");
      return;
    }

    final success = await _inventoryController.verifyAutomatedSyncPhone(
      widget.phone,
      verificationCode,
      type: widget.type,
    );
    if (!success || !mounted) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Phone Verified'),
        content: Text(
          'Your phone number ${widget.phone} has been successfully verified.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    Get.back(result: true);
  }

  void _resendCode() async {
    await _inventoryController.requestAutomatedSyncPhoneChange(
      widget.phone,
      type: widget.type,
    );
  }
}
