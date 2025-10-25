import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_receit_view.dart';

class NavReceits extends StatefulWidget {
  const NavReceits({super.key});

  @override
  State<NavReceits> createState() => _NavReceitsState();
}

class _NavReceitsState extends State<NavReceits> {
  final _itemsListController = Get.find<ItemsController>();

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
        SliverFillRemaining(
          child: GroupedListView<ItemReceitModel, String>(
            elements: _itemsListController.receits,
            groupBy: (element) =>
                element.createdAt.toIso8601String().substring(0, 10),
            groupSeparatorBuilder: (String groupByValue) => Text(groupByValue),
            itemBuilder: (context, ItemReceitModel element) =>
                _buildItem(element),
            itemComparator: (item1, item2) =>
                item1.createdAt.compareTo(item2.createdAt), // optional
            useStickyGroupSeparators: true, // optional
            floatingHeader: true, // optional
            order: GroupedListOrder.ASC, // optional
          ),
        ),
      ],
    );
  }

  _buildItem(ItemReceitModel receit) {
    return Card(
      child: ListTile(
        leading: Iconify(Carbon.receipt),
        title: CurrenceConverter.getCurrenceFloatInStrings(receit.total).text(),
        trailing: Text(receit.id.toString()),
        subtitle: Text("${receit.createdAt.hour}:${receit.createdAt.minute}"),
        onTap: () => Get.to(() => ScreenReceitView(receitModel: receit)),
      ),
    ).padding(EdgeInsets.symmetric(horizontal: 10));
  }
}
