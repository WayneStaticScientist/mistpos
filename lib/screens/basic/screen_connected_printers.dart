import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/controllers/devices_controller.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/models/printer_device_model.dart';
import 'package:mistpos/screens/basic/screen_bluetooth_scan.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:mistpos/widgets/buttons/card_buttons.dart';
import 'package:mistpos/widgets/inputs/input_form.dart';
import 'package:mistpos/widgets/loaders/small_loader.dart';

class ScreenConnectedPrinters extends StatefulWidget {
  const ScreenConnectedPrinters({super.key});

  @override
  State<ScreenConnectedPrinters> createState() =>
      _ScreenConnectedPrintersState();
}

class _ScreenConnectedPrintersState extends State<ScreenConnectedPrinters> {
  final _devicesController = Get.find<DevicesController>();
  final _userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _devicesController.getConnectedDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final surfaceColor = AppTheme.surface(context);

    return Scaffold(
      appBar: AppBar(title: Text("Connected Printers")),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: _addDevice,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(
        () => ListView(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          children: [
            // ─── Printing Mode Toggle Card ──────────────────────
            _buildModeToggleCard(primaryColor, surfaceColor),

            16.gapHeight,

            // ─── Mode Description ───────────────────────────────
            _buildModeDescription(surfaceColor),

            16.gapHeight,

            // ─── Connecting Loader ──────────────────────────────
            if (_devicesController.connectingToDevice.value)
              MistLoader1()
                  .center()
                  .sizedBox(height: 120)
                  .padding(EdgeInsets.only(top: 24)),

            // ─── Empty State ────────────────────────────────────
            if (!_devicesController.connectingToDevice.value &&
                _devicesController.printerDevices.isEmpty)
              _buildEmptyState(),

            // ─── Multi-Point Summary ────────────────────────────
            if (_devicesController.printingMode.value == "multi" &&
                _devicesController.printerDevices.isNotEmpty)
              _buildMultiPointSummary(primaryColor, surfaceColor),

            // ─── Printer List ───────────────────────────────────
            if (!_devicesController.connectingToDevice.value &&
                _devicesController.printerDevices.isNotEmpty)
              ..._devicesController.printerDevices.map(
                (device) => _buildPrinterTile(device, surfaceColor, primaryColor),
              ),
          ],
        ),
      ),
    );
  }

  // ─── Printing Mode Toggle ──────────────────────────────────
  Widget _buildModeToggleCard(Color primaryColor, Color surfaceColor) {
    final isMulti = _devicesController.printingMode.value == "multi";
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withAlpha(30),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(6),
      child: Row(
        children: [
          // Single Point Button
          Expanded(
            child: GestureDetector(
              onTap: () => _devicesController.togglePrintingMode("single"),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: !isMulti
                      ? primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.print_rounded,
                      color: !isMulti ? Colors.white : AppTheme.color(context),
                      size: 22,
                    ),
                    6.gapHeight,
                    Text(
                      "Single Point",
                      style: TextStyle(
                        color: !isMulti ? Colors.white : AppTheme.color(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          8.gapWidth,
          // Multi Point Button
          Expanded(
            child: GestureDetector(
              onTap: () => _devicesController.togglePrintingMode("multi"),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isMulti
                      ? primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.print_rounded,
                          color: isMulti ? Colors.white : AppTheme.color(context),
                          size: 18,
                        ),
                        Icon(
                          Icons.print_rounded,
                          color: isMulti
                              ? Colors.white.withAlpha(180)
                              : AppTheme.color(context).withAlpha(150),
                          size: 18,
                        ),
                      ],
                    ),
                    6.gapHeight,
                    Text(
                      "Multi Point",
                      style: TextStyle(
                        color: isMulti ? Colors.white : AppTheme.color(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Mode Description ──────────────────────────────────────
  Widget _buildModeDescription(Color surfaceColor) {
    final isMulti = _devicesController.printingMode.value == "multi";
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isMulti
            ? Colors.orange.withAlpha(20)
            : Theme.of(context).colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMulti
              ? Colors.orange.withAlpha(60)
              : Theme.of(context).colorScheme.primary.withAlpha(40),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isMulti ? Icons.info_outline_rounded : Icons.print_rounded,
            color: isMulti ? Colors.orange : Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          10.gapWidth,
          Expanded(
            child: Text(
              isMulti
                  ? "Multi Point — Every selected printer will print receipts simultaneously. Connect printers via Bluetooth, WiFi, or USB and toggle them below."
                  : "Single Point — Only one printer is active. Receipts are sent to the connected printer only.",
              style: TextStyle(
                fontSize: 12.5,
                color: AppTheme.color(context).withAlpha(180),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Empty State ───────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Iconify(Bx.wifi, color: AppTheme.color(context).withAlpha(100), size: 42),
          16.gapHeight,
          Text(
            "No connected devices",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppTheme.color(context),
            ),
          ),
          8.gapHeight,
          Text(
            "Tap + to add a printer via Bluetooth or WiFi",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.color(context).withAlpha(120),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Multi-Point Summary Badge ──────────────────────────────
  Widget _buildMultiPointSummary(Color primaryColor, Color surfaceColor) {
    final selectedCount = _devicesController.multiPointSelectedCount;
    final totalCount = _devicesController.printerDevices.length;
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.withAlpha(50)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 18),
          8.gapWidth,
          Text(
            "$selectedCount of $totalCount printers selected for multi-point printing",
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.green.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Printer Tile ──────────────────────────────────────────
  Widget _buildPrinterTile(
    PrinterDeviceModel device,
    Color surfaceColor,
    Color primaryColor,
  ) {
    final isMulti = _devicesController.printingMode.value == "multi";
    final connectionIcon = _getConnectionIcon(device.connectionType);
    final connectionLabel = _getConnectionLabel(device.connectionType);
    final connectionColor = _getConnectionColor(device.connectionType);

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isMulti && device.isSelectedForMultiPrint
              ? primaryColor.withAlpha(80)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        onTap: () {
          if (isMulti) {
            _devicesController.toggleMultiPrintSelection(device);
          } else {
            _forgetDevice(device);
          }
        },
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: connectionColor.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(connectionIcon, color: connectionColor, size: 22),
        ),
        title: Text(
          device.name,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            4.gapHeight,
            Text(
              device.address,
              style: TextStyle(
                color: AppTheme.color(context).withAlpha(100),
                fontSize: 12,
              ),
            ),
            6.gapHeight,
            // Connection type badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: connectionColor.withAlpha(20),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                connectionLabel,
                style: TextStyle(
                  fontSize: 10.5,
                  color: connectionColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        trailing: isMulti
            ? Checkbox(
                value: device.isSelectedForMultiPrint,
                activeColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (_) =>
                    _devicesController.toggleMultiPrintSelection(device),
              )
            : IconButton(
                onPressed: () => _forgetDevice(device),
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red.withAlpha(180),
                  size: 20,
                ),
              ),
      ),
    );
  }

  // ─── Connection Type Helpers ───────────────────────────────

  IconData _getConnectionIcon(String connectionType) {
    switch (connectionType) {
      case "network":
        return Icons.wifi_rounded;
      case "usb":
        return Icons.usb_rounded;
      case "bluetooth":
      default:
        return Icons.bluetooth_rounded;
    }
  }

  String _getConnectionLabel(String connectionType) {
    switch (connectionType) {
      case "network":
        return "WiFi / Network";
      case "usb":
        return "USB";
      case "bluetooth":
      default:
        return "Bluetooth";
    }
  }

  Color _getConnectionColor(String connectionType) {
    switch (connectionType) {
      case "network":
        return Colors.teal;
      case "usb":
        return Colors.deepPurple;
      case "bluetooth":
      default:
        return Colors.blue;
    }
  }

  // ─── Add Device Bottom Sheet ───────────────────────────────

  void _addDevice() {
    Get.bottomSheet(
      [
        CardButtons(
          onTap: _connectWithNetwork,
          icon: Iconify(Bx.wifi, color: AppTheme.color(context)),
          label: "On Network",
          color: Get.theme.colorScheme.primary.withAlpha(50),
        ).expanded1,
        CardButtons(
          onTap: () => {Get.back(), Get.to(() => ScreenBluetoothScan())},
          icon: Iconify(Bx.bluetooth, color: AppTheme.color(context)),
          label: "BlueTooth",
          color: Get.theme.colorScheme.secondary.withAlpha(50),
        ).expanded1,
      ].row().padding(EdgeInsets.only(top: 18)).safeArea(),
      backgroundColor: Get.theme.colorScheme.surface,
    );
  }

  void _connectWithNetwork() {
    Get.back();
    final ipAddress = TextEditingController();
    final port = TextEditingController(text: "9100");
    Get.defaultDialog(
      title: "Connect to Device",
      content: Obx(
        () => _devicesController.connectingToDevice.value
            ? MistLoader1()
            : (_devicesController.cashierConnected.value
                  ? "The device was succefully connected ".text()
                  : [
                      "Enter Device Ip Address".text(),
                      18.gapHeight,
                      MistFormInput(label: "Ip Address", controller: ipAddress),
                      18.gapHeight,
                      MistFormInput(label: "Port", controller: port),
                    ].column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    )),
      ),
      actions: [
        "close".text().textButton(
          onPressed: () {
            Get.back();
          },
        ),
        Obx(
          () => "ok"
              .text()
              .textButton(
                onPressed: () {
                  _devicesController.connectToNetwork(
                    ipAddress.text,
                    int.tryParse(port.text) ?? 9100,
                    _userController.user.value,
                  );
                },
              )
              .visibleIf(
                !_devicesController.cashierConnected.value &&
                    !_devicesController.connectingToDevice.value,
              ),
        ),
      ],
    );
  }

  void _forgetDevice(PrinterDeviceModel printerDevic) {
    Get.defaultDialog(
      title: "Forget Device",
      content: "do you want to forget this device ?".text(),
      actions: [
        "close".text().textButton(
          onPressed: () {
            Get.back();
          },
        ),
        'forget'.text().textButton(
          onPressed: () {
            _devicesController.forgetDevice(printerDevic);
            Get.back();
          },
        ),
      ],
    );
  }
}
