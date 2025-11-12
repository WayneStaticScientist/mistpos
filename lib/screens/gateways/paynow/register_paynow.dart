import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mistpos/screens/gateways/paynow/api_integration.dart';
import 'package:mistpos/utils/paypment_getways.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ScreenRegisterPaynow extends StatefulWidget {
  const ScreenRegisterPaynow({super.key});

  @override
  State<ScreenRegisterPaynow> createState() => _ScreenRegisterPaynowState();
}

class _ScreenRegisterPaynowState extends State<ScreenRegisterPaynow> {
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
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showProcessDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Paynow")),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            MistLoader1().center().decoratedBox(
              decoration: BoxDecoration(color: Colors.black.withAlpha(50)),
            ),
        ],
      ),
      bottomNavigationBar: _loading
          ? null
          : SafeArea(
              child:
                  [
                        MistFormButton(
                          label: "verified",
                          onTap: () =>
                              Get.off(() => ScreenAPiIntegrationPaypal()),
                        ),
                      ]
                      .row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                      )
                      .padding(EdgeInsets.all(3)),
            ),
    );
  }

  void _showProcessDialog() {
    Get.defaultDialog(
      title: "Notice",
      barrierDismissible: false,
      content:
          "You need to register your account with paynow and verify your information , after succesful verification you then click verified button to continue to the next setup process"
              .text(),
      actions: ["Understood".text().textButton(onPressed: _initiateLoader)],
    );
  }

  void _initiateLoader() {
    Get.back();
    _controller.loadRequest(Uri.parse(PaymentGatways.paynowRegistration));
  }
}
