import 'package:flutter/material.dart';
import 'package:mistpos/widgets/layouts/receits_layout_view.dart';

class NavReceits extends StatefulWidget {
  const NavReceits({super.key});

  @override
  State<NavReceits> createState() => _NavReceitsState();
}

class _NavReceitsState extends State<NavReceits> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          floating: true,
          snap: true,
          title: Text('Receipts'),
        ),
        SliverPadding(padding: EdgeInsetsGeometry.all(10)),
        SliverFillRemaining(child: ReceitsLayoutView()),
      ],
    );
  }
}
