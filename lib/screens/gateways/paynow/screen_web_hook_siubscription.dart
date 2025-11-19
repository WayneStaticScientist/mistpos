import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/controllers/inventory_controller.dart';

class ScreenWebHookSubscription extends StatefulWidget {
  final double amount;
  final String pollUrl;
  final String subKey;
  final String returnUrl;
  final String webHookUrl;
  final String paymentInfo;
  const ScreenWebHookSubscription({
    super.key,
    required this.amount,
    required this.pollUrl,
    required this.subKey,
    required this.returnUrl,
    required this.webHookUrl,
    required this.paymentInfo,
  });

  @override
  State<ScreenWebHookSubscription> createState() =>
      _ScreenWebHookSubscriptionState();
}

class _ScreenWebHookSubscriptionState extends State<ScreenWebHookSubscription> {
  final _inventoryController = Get.find<InventoryController>();
  late WebViewController _controller;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            setState(() {
              _loading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _loading = false;
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.toLowerCase().trim().startsWith(
              widget.returnUrl.toLowerCase().trim(),
            )) {
              _processReceit();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    WidgetsBinding.instance.addPostFrameCallback((e) {
      _controller.loadRequest(Uri.parse(widget.webHookUrl));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subscribe")),
      body: Stack(
        children: [
          Positioned.fill(child: WebViewWidget(controller: _controller)),
          if (_loading)
            MistLoader1().center().decoratedBox(
              decoration: BoxDecoration(color: Colors.black.withAlpha(50)),
            ),
        ],
      ),
    );
  }

  void _processReceit() async {
    setState(() {
      _loading = true;
    });
    final respone = await _inventoryController.poll(
      widget.pollUrl,
      widget.subKey,
    );
    if (respone) {
      Get.back();
      Toaster.showSuccess("payment succesfully");
    }
  }
}
