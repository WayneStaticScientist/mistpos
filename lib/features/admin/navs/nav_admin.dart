import 'package:flutter/material.dart';
import 'package:mistpos/features/settings/screens/screen_dashboard.dart';

class NavAdmin extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const NavAdmin({super.key, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return const ScreenDashboard();
  }
}
