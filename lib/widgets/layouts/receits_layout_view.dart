import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/item_receit_model.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/utils/currence_converter.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/screens/basic/screen_receit_view.dart';

class ReceitsLayoutView extends StatefulWidget {
  const ReceitsLayoutView({super.key});

  @override
  State<ReceitsLayoutView> createState() => _ReceitsLayoutViewState();
}

class _ReceitsLayoutViewState extends State<ReceitsLayoutView> {
  final _itemsListController = Get.find<ItemsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _itemsListController.receits.isNotEmpty
          ? GroupedListView<ItemReceitModel, String>(
              elements: _itemsListController.receits,
              groupBy: (element) =>
                  element.createdAt.toIso8601String().substring(0, 10),
              groupSeparatorBuilder: (String groupByValue) =>
                  Text(groupByValue),
              itemBuilder: (context, ItemReceitModel element) =>
                  _buildItem(element),
              itemComparator: (item1, item2) =>
                  item1.createdAt.compareTo(item2.createdAt), // optional
              useStickyGroupSeparators: true, // optional
              floatingHeader: true, // optional
              order: GroupedListOrder.ASC, // optional
            )
          : [Iconify(Bx.receipt), "No Receits ".text()].column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
    );
  }

  _buildItem(ItemReceitModel receit) {
    return ListTile(
      tileColor: Colors.grey.withAlpha(20),
      leading: Iconify(Carbon.receipt, color: AppTheme.color(context)),
      title: CurrenceConverter.getCurrenceFloatInStrings(receit.total).text(),
      trailing: Text(receit.id.toString()),
      subtitle: Text("${receit.createdAt.hour}:${receit.createdAt.minute}"),
      onTap: () => Get.to(() => ScreenReceitView(receitModel: receit)),
    ).padding(EdgeInsets.symmetric(horizontal: 10));
  }
}
