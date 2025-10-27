import 'package:flutter/material.dart';

class NavDiscountsList extends StatefulWidget {
  const NavDiscountsList({super.key});

  @override
  State<NavDiscountsList> createState() => _NavDiscountsListState();
}

class _NavDiscountsListState extends State<NavDiscountsList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(leading: Icon(Icons.discount), title: Text('Discount 1')),
        ListTile(leading: Icon(Icons.discount), title: Text('Discount 2')),
        ListTile(leading: Icon(Icons.discount), title: Text('Discount 3')),
      ],
    );
  }
}
