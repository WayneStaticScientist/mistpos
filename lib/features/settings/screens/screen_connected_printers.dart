import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mistpos/core/utils/printer_role_helper.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/data/models/app_settings_model.dart';
import 'package:mistpos/data/models/printer_device_model.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/devices/controllers/devices_controller.dart';
import 'package:mistpos/features/settings/screens/screen_bluetooth_scan.dart';

class ScreenConnectedPrinters extends StatefulWidget {
  const ScreenConnectedPrinters({super.key});

  @override
  State<ScreenConnectedPrinters> createState() =>
      _ScreenConnectedPrintersState();
}

class _ScreenConnectedPrintersState extends State<ScreenConnectedPrinters>
    with SingleTickerProviderStateMixin {
  final _devicesController = Get.find<DevicesController>();
  final _userController = Get.find<UserController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final model = AppSettingsModel.fromStorage();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: model.printToMultiplePrinters ? 1 : 0,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final currentModel = AppSettingsModel.fromStorage();
        currentModel.printToMultiplePrinters = _tabController.index == 1;
        currentModel.saveToStorage();
        _devicesController.connectLastDevice();
        setState(() {});
      }
    });
    _devicesController.getConnectedDevices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _isDeviceConnected(PrinterDeviceModel device) {
    final role = PosRoleHelper.fromString(device.role);
    return _devicesController.printer.isRoleConnected(role) || device.isConnected;
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hardware Printers",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Thermal ESC/POS receipt & ticket printers",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          // Reconnect All action
          Obx(() {
            final isReconnecting = _devicesController.connectingToDevice.value;
            return IconButton(
              tooltip: "Reconnect all configured printers",
              icon: isReconnecting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync_rounded),
              onPressed: isReconnecting
                  ? null
                  : () {
                      try {
                        HapticFeedback.lightImpact();
                      } catch (_) {}
                      _devicesController.reconnectAllDevices();
                    },
            );
          }),
          // Add Printer action
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: themeColor.withAlpha(25),
                foregroundColor: themeColor,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _showAddPrinterModal,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text(
                "Add",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withAlpha(70),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? Colors.white70 : Colors.black87,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12.5),
              tabs: const [
                Tab(
                  iconMargin: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.print_outlined, size: 16),
                      SizedBox(width: 6),
                      Text("Single Point"),
                    ],
                  ),
                ),
                Tab(
                  iconMargin: EdgeInsets.zero,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.hub_outlined, size: 16),
                      SizedBox(width: 6),
                      Text("Multiple Point"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPrinterView(isMultiple: false, themeColor: themeColor),
          _buildPrinterView(isMultiple: true, themeColor: themeColor),
        ],
      ),
    );
  }

  Widget _buildPrinterView({required bool isMultiple, required Color themeColor}) {
    return Obx(() {
      final devices = _devicesController.printerDevices;
      final isConnectingGlobal = _devicesController.connectingToDevice.value;

      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          // Mode Description & Status Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: _buildModeInfoCard(isMultiple: isMultiple, themeColor: themeColor),
            ),
          ),

          // Loading bar if connecting globally
          if (isConnectingGlobal)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: LinearProgressIndicator(minHeight: 2),
              ),
            ),

          // Empty State
          if (devices.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(themeColor),
            )
          else ...[
            // Printer count summary
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "CONFIGURED PRINTERS (${devices.length})",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () => _devicesController.reconnectAllDevices(),
                      child: Row(
                        children: [
                          Icon(Icons.refresh, size: 13, color: themeColor),
                          const SizedBox(width: 3),
                          Text(
                            "Sync All",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Printer Cards List
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final device = devices[index];
                    return _buildPrinterCard(
                      device: device,
                      isMultiple: isMultiple,
                      themeColor: themeColor,
                      isPrimary: !isMultiple && index == 0,
                    );
                  },
                  childCount: devices.length,
                ),
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildModeInfoCard({required bool isMultiple, required Color themeColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withAlpha(8) : Colors.black.withAlpha(6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMultiple
              ? Colors.teal.withAlpha(80)
              : themeColor.withAlpha(80),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isMultiple
                  ? Colors.teal.withAlpha(25)
                  : themeColor.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isMultiple ? Icons.hub_rounded : Icons.point_of_sale_rounded,
              size: 20,
              color: isMultiple ? Colors.teal : themeColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isMultiple
                          ? "Multiple Point Printing Active"
                          : "Single Point Printing Active",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: isMultiple
                            ? Colors.teal.withAlpha(20)
                            : themeColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isMultiple ? "MULTI" : "STANDARD",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: isMultiple ? Colors.teal : themeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  isMultiple
                      ? "Automatically sends customer receipts to Cashier, kitchen tickets to Kitchen, and price stickers to Sticker printer."
                      : "Prints all sales receipts and shift reports to the primary cashier thermal printer.",
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrinterCard({
    required PrinterDeviceModel device,
    required bool isMultiple,
    required Color themeColor,
    required bool isPrimary,
  }) {
    final isConnected = _isDeviceConnected(device);
    final isBluetooth = device.port == 0;
    final isReconnecting = _devicesController.reconnectingDeviceAddress.value == device.address;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isConnected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isConnected
              ? (isPrimary ? themeColor.withAlpha(140) : Colors.green.withAlpha(90))
              : Colors.grey.withAlpha(60),
          width: isConnected ? 1.4 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Type Avatar + Name + Online Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Device Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isBluetooth
                        ? Colors.blue.withAlpha(isDark ? 35 : 20)
                        : Colors.teal.withAlpha(isDark ? 35 : 20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isBluetooth ? Icons.bluetooth_rounded : Icons.wifi_rounded,
                    color: isBluetooth ? Colors.blue : Colors.teal,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Name and Address
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              device.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isPrimary && !isMultiple) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: themeColor.withAlpha(25),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: themeColor.withAlpha(120), width: 0.8),
                              ),
                              child: Text(
                                "PRIMARY",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: themeColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isBluetooth
                            ? "Bluetooth • ${device.address}"
                            : "TCP Network • ${device.address}:${device.port}",
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Live Connection Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isConnected
                        ? Colors.green.withAlpha(25)
                        : Colors.orange.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isConnected ? Colors.green : Colors.orange,
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isConnected ? Colors.green : Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isConnected ? "ONLINE" : "OFFLINE",
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: isConnected ? Colors.green : Colors.orange,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Middle: Role Tag + Hardware Badges
            Row(
              children: [
                // Assigned Role Pill (tap to change in Multiple Point)
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: isMultiple
                      ? () => _showChangeRoleSheet(device, themeColor)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(10),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getRoleIcon(device.role),
                          size: 13,
                          color: themeColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "ROLE: ${device.role.toUpperCase()}",
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                        if (isMultiple) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down, size: 14, color: Colors.grey),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Interface Type badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(20),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isBluetooth ? "BT SPP" : "ETHERNET/LAN",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Spacer(),

                // Remove device icon button
                IconButton(
                  tooltip: "Forget device",
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                  onPressed: () => _confirmForgetDevice(device),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Action Buttons Row: [ Reconnect ] & [ Test Print ]
            Row(
              children: [
                // RECONNECT BUTTON (The user specifically asked for this)
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isConnected
                          ? (isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(10))
                          : themeColor,
                      foregroundColor: isConnected
                          ? (isDark ? Colors.white : Colors.black87)
                          : Colors.white,
                      elevation: isConnected ? 0 : 2,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isConnected
                              ? Colors.grey.withAlpha(50)
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    onPressed: isReconnecting
                        ? null
                        : () => _devicesController.reconnectDevice(device),
                    icon: isReconnecting
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(
                            isConnected ? Icons.check_circle_outline : Icons.sync_rounded,
                            size: 16,
                            color: isConnected ? Colors.green : Colors.white,
                          ),
                    label: Text(
                      isReconnecting
                          ? "Connecting..."
                          : (isConnected ? "Re-sync Printer" : "Reconnect Printer"),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isConnected && !isDark ? Colors.black87 : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // TEST PRINT BUTTON
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _devicesController.testPrintDevice(device),
                    icon: const Icon(Icons.print_outlined, size: 16),
                    label: const Text(
                      "Test Print",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'kitchen':
        return Icons.restaurant_menu_rounded;
      case 'sticker':
      case 'label':
        return Icons.label_important_outline_rounded;
      case 'cashier':
      default:
        return Icons.point_of_sale_rounded;
    }
  }

  Widget _buildEmptyState(Color themeColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: themeColor.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.print_disabled_outlined, size: 40, color: themeColor),
            ),
            const SizedBox(height: 18),
            const Text(
              "No Printers Configured Yet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Connect thermal receipt printers via Bluetooth wireless or local network (Ethernet / Wi-Fi) to enable receipt and kitchen printing.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: Colors.grey, height: 1.4),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Get.to(() => const ScreenBluetoothScan()),
                  icon: const Icon(Icons.bluetooth_searching, size: 18),
                  label: const Text(
                    "Scan Bluetooth",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _showAddNetworkPrinterDialog,
                  icon: const Icon(Icons.wifi, size: 18),
                  label: const Text(
                    "Add Network",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPrinterModal() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Hardware Printer",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                "Choose connection interface to pair with your POS thermal printer",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 18),

              // Bluetooth Option
              Card(
                elevation: 0,
                color: Colors.blue.withAlpha(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blue.withAlpha(60)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.bluetooth_rounded),
                  ),
                  title: const Text(
                    "Bluetooth Thermal Printer",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: const Text(
                    "Scan and pair wireless 58mm / 80mm mobile Bluetooth printers",
                    style: TextStyle(fontSize: 11),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.back();
                    Get.to(() => const ScreenBluetoothScan());
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Network (Wi-Fi / Ethernet) Option
              Card(
                elevation: 0,
                color: Colors.teal.withAlpha(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.teal.withAlpha(60)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.wifi_rounded),
                  ),
                  title: const Text(
                    "Network Printer (Wi-Fi / Ethernet LAN)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: const Text(
                    "Connect directly via IP address and TCP port (e.g. 9100)",
                    style: TextStyle(fontSize: 11),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.back();
                    _showAddNetworkPrinterDialog();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showAddNetworkPrinterDialog() {
    final themeColor = Theme.of(context).colorScheme.primary;
    final ipCtrl = TextEditingController();
    final portCtrl = TextEditingController(text: "9100");
    final nameCtrl = TextEditingController(text: "LAN Thermal Printer");
    String selectedRole = 'cashier';

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.teal.withAlpha(25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.wifi, color: Colors.teal, size: 20),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Add Network Printer",
                                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: "Printer Nickname",
                          hintText: "e.g. Counter 1 Thermal or Kitchen EPSON",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.edit_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: ipCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "IP Address",
                          hintText: "e.g. 192.168.1.100",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.settings_ethernet_rounded),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: portCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "TCP Port (default 9100)",
                          hintText: "9100",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.numbers_rounded),
                        ),
                      ),
                      const SizedBox(height: 14),

                      const Text(
                        "Printer Station Role",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: ['cashier', 'kitchen', 'sticker'].map((role) {
                          final isSel = selectedRole == role;
                          return ChoiceChip(
                            label: Text(role.toUpperCase()),
                            selected: isSel,
                            onSelected: (_) => setDialogState(() => selectedRole = role),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final ip = ipCtrl.text.trim();
                          final port = int.tryParse(portCtrl.text.trim()) ?? 9100;
                          final name = nameCtrl.text.trim().isNotEmpty
                              ? nameCtrl.text.trim()
                              : ip;

                          if (ip.isEmpty) {
                            Toaster.showError("Please enter a valid IP address");
                            return;
                          }

                          Get.back();
                          await _devicesController.connectToNetwork(
                            ip,
                            port,
                            _userController.user.value,
                            deviceName: name,
                            role: selectedRole,
                          );
                        },
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text(
                          "Test & Connect Printer",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  void _showChangeRoleSheet(PrinterDeviceModel device, Color themeColor) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assign Role for ${device.name}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Determines what tickets get sent to this printer in Multi-Point mode",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.point_of_sale_rounded, color: Colors.green),
                title: const Text("Cashier (Sales Receipts)"),
                subtitle: const Text("Customer checkout bills and receipts"),
                trailing: device.role.toLowerCase() == 'cashier'
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  Get.back();
                  _devicesController.updateDeviceRole(device, 'cashier');
                },
              ),
              ListTile(
                leading: const Icon(Icons.restaurant_menu_rounded, color: Colors.orange),
                title: const Text("Kitchen (Order Prep Tickets)"),
                subtitle: const Text("Kitchen food and bar drink preparation slips"),
                trailing: device.role.toLowerCase() == 'kitchen'
                    ? const Icon(Icons.check, color: Colors.orange)
                    : null,
                onTap: () {
                  Get.back();
                  _devicesController.updateDeviceRole(device, 'kitchen');
                },
              ),
              ListTile(
                leading: const Icon(Icons.label_important_outline_rounded, color: Colors.blue),
                title: const Text("Sticker (Barcode & Labels)"),
                subtitle: const Text("Product barcode tags and packaging stickers"),
                trailing: device.role.toLowerCase() == 'sticker'
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  Get.back();
                  _devicesController.updateDeviceRole(device, 'sticker');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmForgetDevice(PrinterDeviceModel device) {
    Get.defaultDialog(
      title: "Forget Printer",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            const Icon(Icons.warning_amber_rounded, size: 40, color: Colors.orange),
            const SizedBox(height: 10),
            Text(
              "Are you sure you want to forget '${device.name}' (${device.address})?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Get.back();
            _devicesController.forgetDevice(device);
          },
          child: const Text("Forget Device"),
        ),
      ],
    );
  }
}
