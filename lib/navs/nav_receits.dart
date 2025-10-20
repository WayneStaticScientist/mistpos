import 'package:flutter/material.dart';

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
        SliverFillRemaining(child: Center(child: Text('Receipts Navigation'))),
      ],
    );
  }
}
