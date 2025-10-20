import 'package:flutter/material.dart';

class NavModifiersList extends StatefulWidget {
  const NavModifiersList({super.key});

  @override
  State<NavModifiersList> createState() => _NavModifiersListState();
}

class _NavModifiersListState extends State<NavModifiersList> {
  @override
  Widget build(BuildContext context) {
    return SliverList.list(
      children: [
        ListTile(leading: Icon(Icons.edit), title: Text('Modifier 1')),
        ListTile(leading: Icon(Icons.edit), title: Text('Modifier 2')),
        ListTile(leading: Icon(Icons.edit), title: Text('Modifier 3')),
      ],
    );
  }
}
