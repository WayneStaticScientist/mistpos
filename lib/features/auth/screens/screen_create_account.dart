import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/icons/lucide.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/data/models/user_model.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';

class ScreenCreateAccount extends StatefulWidget {
  const ScreenCreateAccount({super.key});

  @override
  State<ScreenCreateAccount> createState() => _ScreenCreateAccountState();
}

class _ScreenCreateAccountState extends State<ScreenCreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _userController = Get.find<UserController>();
  final _countryController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _countryController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Get.theme.colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withAlpha(10)
                            : Colors.black.withAlpha(6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withAlpha(14)
                              : Colors.black.withAlpha(10),
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: isDark
                            ? Colors.white.withAlpha(180)
                            : Colors.black.withAlpha(150),
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 36),

                  // Header icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withAlpha(60),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/launcher.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      .animate(delay: 50.ms)
                      .fadeIn()
                      .scale(begin: const Offset(0.8, 0.8)),
                  const SizedBox(height: 20),
                  Text(
                    'Create account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 6),
                  Text(
                    'Set up your MistPos business account',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  )
                      .animate(delay: 150.ms)
                      .fadeIn()
                      .slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 36),

                  // Full Name
                  _buildLabel('Full Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _fullNameController,
                    hint: 'John Doe',
                    icon: Lucide.user,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter your full name' : null,
                    isDark: isDark,
                    primary: primary,
                  ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 18),

                  // Email
                  _buildLabel('Email Address'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailController,
                    hint: 'you@business.com',
                    icon: Lucide.mail,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v == null || v.length < 5 ? 'Enter a valid email' : null,
                    isDark: isDark,
                    primary: primary,
                  ).animate(delay: 240.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 18),

                  // Business Name
                  _buildLabel('Business Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _businessNameController,
                    hint: 'Acme Store',
                    icon: Bx.store,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter your business name' : null,
                    isDark: isDark,
                    primary: primary,
                  ).animate(delay: 280.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 18),

                  // Country
                  _buildLabel('Country'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectCountry,
                    child: AbsorbPointer(
                      child: _buildTextField(
                        controller: _countryController,
                        hint: 'Select your country',
                        icon: Bx.flag,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Select a country' : null,
                        isDark: isDark,
                        primary: primary,
                        suffix: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Iconify(
                            Bx.chevron_down,
                            size: 20,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ).animate(delay: 320.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 18),

                  // Password
                  _buildLabel('Password'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _passwordController,
                    hint: '••••••••',
                    icon: Lucide.lock,
                    obscureText: !_passwordVisible,
                    validator: (v) =>
                        v == null || v.length < 5 ? 'Min 5 characters' : null,
                    isDark: isDark,
                    primary: primary,
                    suffix: GestureDetector(
                      onTap: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: Iconify(
                          _passwordVisible ? Lucide.eye_off : Lucide.eye,
                          size: 18,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ).animate(delay: 360.ms).fadeIn().slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 36),

                  // Create Account button
                  Obx(
                    () => _PrimaryButton(
                      label: 'Create Account',
                      isLoading: _userController.loading.value,
                      onTap: _createAccount,
                      primary: primary,
                    ),
                  ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3, end: 0),
                  const SizedBox(height: 28),

                  // Sign in link
                  Center(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          children: [
                            const TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate(delay: 450.ms).fadeIn(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade500,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String icon,
    required bool isDark,
    required Color primary,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor:
            isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(4),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Iconify(icon, size: 18, color: Colors.grey.shade400),
        ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 48, minHeight: 48),
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withAlpha(14)
                : Colors.black.withAlpha(10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withAlpha(14)
                : Colors.black.withAlpha(10),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary.withAlpha(180), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() => _countryController.text = country.name);
      },
    );
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;
    if (_fullNameController.text.trim().split(" ").length < 2) {
      Toaster.showError("Please enter your full name e.g John Doe");
      return;
    }
    final user = User(
      till: 1,
      role: 'admin',
      companies: [],
      pinnedInput: false,
      permissions: [],
      subscriptions: [],
      email: _emailController.text,
      country: _countryController.text,
      fullName: _fullNameController.text,
      password: _passwordController.text,
      company: _businessNameController.text,
    );
    _userController.registerUser(user);
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onTap;
  final Color primary;
  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: isLoading ? primary.withAlpha(150) : primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: primary.withAlpha(80),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: 0.2,
                  ),
                ),
        ),
      ),
    );
  }
}
