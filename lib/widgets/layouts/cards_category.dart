import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';

class CardsCategory extends StatelessWidget {
  final String category;
  final bool? isSelected;
  final Function()? onTap;
  const CardsCategory({
    super.key,
    required this.category,
    this.isSelected,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: isSelected == true ? Get.theme.colorScheme.primary : null,
        child:
            [
                  category.text(
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected == true ? Colors.white : null,
                    ),
                  ),
                ]
                .column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                )
                .padding(EdgeInsets.all(2))
                .sizedBox(height: 10, width: 50),
      ),
    );
  }
}
