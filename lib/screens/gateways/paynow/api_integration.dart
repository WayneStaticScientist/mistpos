import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/screens/gateways/paynow/setup_paynow.dart';
import 'package:mistpos/utils/paypment_getways.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';

class ScreenAPiIntegrationPaypal extends StatefulWidget {
  const ScreenAPiIntegrationPaypal({super.key});

  @override
  State<ScreenAPiIntegrationPaypal> createState() =>
      _ScreenAPiIntegrationPaypalState();
}

class _ScreenAPiIntegrationPaypalState
    extends State<ScreenAPiIntegrationPaypal> {
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
      appBar: AppBar(title: const Text("Integration Keys")),
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
                          label: "Done",
                          onTap: () => Get.off(() => ScreenSetupPaynow()),
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
          "Register also on this screen to get Integration ID and Integration Key and save them at safe place , This are needed for authentication , and do not share those keys! Remember to click Request Set to be Live button to enable your account to work ,"
              .text(),

      actions: ["Understood".text().textButton(onPressed: _initiateLoader)],
    );
  }

  void _initiateLoader() {
    Get.back();
    _controller.loadRequest(
      Uri.parse(PaymentGatways.paynowCreateApiIntegrations),
    );
  }
}
