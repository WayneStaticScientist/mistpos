import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';

class ScreenPaymentGetway extends StatefulWidget {
  const ScreenPaymentGetway({super.key});

  @override
  State<ScreenPaymentGetway> createState() => _ScreenPaymentGetwayState();
}

class _ScreenPaymentGetwayState extends State<ScreenPaymentGetway> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment Getways")),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          24.gapColumn,
          MistMordernLayout(
            label: "Payment Getways",
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: "Paynow(Zimbabwe) ".text(),
                subtitle: "setup paynow account".text(
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                leading: Iconify(
                  Bx.bxs_package,
                  color: AppTheme.color(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
