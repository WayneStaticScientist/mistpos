import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/responsive/screen_sizes.dart';
import 'package:mistpos/screens/basic/modern_layout.dart';

class SalesHelp extends StatefulWidget {
  const SalesHelp({super.key});

  @override
  State<SalesHelp> createState() => _SalesHelpState();
}

class _SalesHelpState extends State<SalesHelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sales Help & Support')),
      body:
          SingleChildScrollView(
                child: [
                  MistMordernLayout(
                    label: "Adjust Cart Count",
                    children: [
                      12.gapHeight,
                      Image.asset('assets/tutorials/adjust.jpg'),
                      12.gapHeight,
                      "Single tap on the item to add it to the invoice cart list , To adjust the quantity of an item in the cart, simply long-press on the item within the cart section.A new screen will appear, allowing you to modify the quantity as needed as well as to either apply discounts or modifiers to that specific item."
                          .text(),
                    ],
                  ).sizedBox(width: double.infinity),
                  24.gapHeight,
                  MistMordernLayout(
                    label: "Viewing invoice Cart",
                    children: [
                      12.gapHeight,
                      Image.asset('assets/tutorials/invoice.jpg'),
                      12.gapHeight,
                      "To view the invoice cart,Tap on the highlighted button , it will open up the invoice cart where you can see all the items added to the cart before proceeding to checkout.You can edit quantities, apply discounts, or remove items from this view."
                          .text(),
                    ],
                  ).sizedBox(width: double.infinity),
                  24.gapHeight,
                  MistMordernLayout(
                    label: "Checkout Items",
                    children: [
                      12.gapHeight,
                      Image.asset('assets/tutorials/export.jpg'),
                      12.gapHeight,
                      "To Checkout selected items in the cart,Tap on the checkout button located at the bottom of the invoice cart screen.This will take you to the payment screen where you can select the payment method and complete the transaction."
                          .text(),
                    ],
                  ).sizedBox(width: double.infinity),
                ].column(),
              )
              .sizedBox(height: double.infinity)
              .constrained(maxHeight: ScreenSizes.maxWidth)
              .center()
              .padding(EdgeInsets.all(16)),
    );
  }
}
