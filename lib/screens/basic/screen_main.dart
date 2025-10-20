import 'package:flutter/material.dart';
import 'package:mistpos/navs/nav_items.dart';
import 'package:mistpos/navs/nav_receits.dart';
import 'package:mistpos/navs/nav_sales.dart';
import 'package:mistpos/widgets/layouts/mist_navigation_drawer.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key});

  @override
  State<ScreenMain> createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final _listNavs = {
    'sales': NavSale(),
    "receipts": NavReceits(),
    "items": NavItems(scaffoldKey: _scaffoldKey),
  };

  String _currentNav = 'sales';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _listNavs[_currentNav] ?? SizedBox.shrink(),
      drawer: MistMainNavigationView(
        selectedNav: _currentNav,
        onTap: (value) {
          setState(() {
            _currentNav = value;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}
