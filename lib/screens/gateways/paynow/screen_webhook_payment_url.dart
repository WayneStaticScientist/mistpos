import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mistpos/controllers/devices_controller.dart';
import 'package:mistpos/controllers/items_controller.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/utils/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class ScreenWebhookPaymentUrl extends StatefulWidget {
  final double amount;
  final String pollUrl;
  final String returnUrl;
  final String webHookUrl;
  final String paymentInfo;
  const ScreenWebhookPaymentUrl({
    super.key,
    required this.amount,
    required this.pollUrl,
    required this.returnUrl,
    required this.webHookUrl,
    required this.paymentInfo,
  });

  @override
  State<ScreenWebhookPaymentUrl> createState() =>
      _ScreenWebhookPaymentUrlState();
}

class _ScreenWebhookPaymentUrlState extends State<ScreenWebhookPaymentUrl> {
  final _itemsController = Get.find<ItemsController>();
  final _printer = Get.find<DevicesController>();
  final _userController = Get.find<UserController>();
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
      appBar: AppBar(title: const Text("Online Payment")),
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
    final respone = await _itemsController.poll(widget.pollUrl);
    if (respone) {
      _itemsController.addReceitFromItemModel(
        widget.amount,
        widget.paymentInfo,
        allowOfflinePurchase:
            _userController.user.value != null &&
            _userController.user.value!.allowOfflinePurchase,
        user: _userController.user.value!,
        printReceits: _printer.isPrinterConnected(),
      );
      if (mounted) {
        Get.back();
      }
      Toaster.showSuccess("payment succesfully");
    }
  }
}
