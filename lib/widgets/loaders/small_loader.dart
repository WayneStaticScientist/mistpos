import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MistLoader1 extends StatelessWidget {
  const MistLoader1({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: Get.theme.colorScheme.primary,
      size: 28,
    );
  }
}
