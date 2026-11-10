import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/features/auth/controllers/user_controller.dart';
import 'package:mistpos/features/devices/controllers/devices_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_universal_printer/pos_universal_printer.dart';

class ScreenBluetoothScan extends StatefulWidget {
  const ScreenBluetoothScan({super.key});

  @override
  State<ScreenBluetoothScan> createState() => _ScreenBluetoothScanState();
}

class _ScreenBluetoothScanState extends State<ScreenBluetoothScan>
    with SingleTickerProviderStateMixin {
  final PosUniversalPrinter printer = PosUniversalPrinter.instance;
  final _devicesController = Get.find<DevicesController>();
  final _userController = Get.find<UserController>();

  bool _isScanning = false;
  final List<PrinterDevice> _bluetoothDevices = [];
  StreamSubscription<PrinterDevice>? _scanSubscription;
  Timer? _scanTimeout;

  String? _connectingAddress;
  String? _connectedAddress;
  String? _failedAddress;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeBluetooth();
      await _scanBluetoothDevices();
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _scanTimeout?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _resetScanningState() {
    _scanTimeout?.cancel();
    if (mounted) {
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _scanBluetoothDevices() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _bluetoothDevices.clear();
      _failedAddress = null;
    });

    try {
      final scanStream = printer.scanBluetooth();

      // 1. Fetch System Paired/Known Devices
      try {
        final List<BluetoothDevice> systemDevices =
            await FlutterBluePlus.systemDevices([]);
        for (var device in systemDevices) {
          final pairedDevice = PrinterDevice(
            id: device.remoteId.str,
            type: PrinterType.bluetooth,
            name: device.platformName.isNotEmpty
                ? device.platformName
                : (device.advName.isNotEmpty ? device.advName : "Bluetooth Printer"),
            address: device.remoteId.str,
          );

          if (!_bluetoothDevices.any((d) => d.address == pairedDevice.address)) {
            _bluetoothDevices.add(pairedDevice);
          }
        }
        if (mounted) setState(() {});
      } catch (e) {
        log("System paired fetch notice: $e");
      }

      // 2. Start Live Scan for Discoverable Devices
      _scanTimeout = Timer(const Duration(seconds: 12), () async {
        if (_isScanning) {
          await FlutterBluePlus.stopScan();
          await _scanSubscription?.cancel();
          _resetScanningState();
        }
      });

      _scanSubscription = scanStream.listen(
        (device) {
          if (device.type == PrinterType.bluetooth) {
            if (!_bluetoothDevices.any((d) => d.address == device.address)) {
              if (mounted) {
                setState(() {
                  _bluetoothDevices.add(device);
                });
              }
            }
          }
        },
        onDone: () {
          _resetScanningState();
        },
        onError: (e) {
          log("Scan stream error: $e");
          _resetScanningState();
        },
        cancelOnError: true,
      );
    } catch (e) {
      Toaster.showError("Error starting scan: $e");
      _resetScanningState();
    }
  }

  Future<void> _connectDevice(PrinterDevice device) async {
    if (_connectingAddress != null) return; // Busy connecting

    final address = device.address ?? '';
    final name = device.name.isNotEmpty ? device.name : 'Thermal Printer';

    setState(() {
      _connectingAddress = address;
      _failedAddress = null;
    });

    try {
      await _scanSubscription?.cancel();
      _resetScanningState();

      final result = await _devicesController.connectToBluetooth(
        name,
        address,
        _userController.user.value,
      );

      if (result) {
        setState(() {
          _connectedAddress = address;
          _connectingAddress = null;
        });

        Toaster.showSuccess("'$name' connected & paired successfully!");

        // Smooth celebratory transition before popping back
        await Future.delayed(const Duration(milliseconds: 1100));
        if (mounted) {
          Get.back();
        }
      } else {
        setState(() {
          _connectingAddress = null;
          _failedAddress = address;
        });
        Toaster.showError("Failed to connect to device. Switch on printer and retry.");
      }
    } catch (e) {
      log('🚨 Bluetooth Connection Error: $e');
      setState(() {
        _connectingAddress = null;
        _failedAddress = address;
      });
      Toaster.showError(
        "Connection terminated: ${e.toString().split(':')[0]}",
      );
    }
  }

  Future<void> _initializeBluetooth() async {
    try {
      if (await FlutterBluePlus.isSupported == false) {
        Toaster.showError("Bluetooth not supported on this device.");
        return;
      }

      if (Platform.isAndroid) {
        var status = await Permission.bluetoothScan.request();
        if (status.isDenied) {
          Toaster.showError("Bluetooth Scan permission denied.");
          return;
        }

        status = await Permission.bluetoothConnect.request();
        if (status.isDenied) {
          Toaster.showError("Bluetooth Connect permission denied.");
          return;
        }

        if (await Permission.location.isDenied) {
          status = await Permission.location.request();
          if (status.isDenied) {
            Toaster.showError(
              "Location permission denied (required for scanning).",
            );
            return;
          }
        }
        await FlutterBluePlus.turnOn();
      }

      FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
        if (state != BluetoothAdapterState.on && mounted) {
          Toaster.showError("Bluetooth is currently turned off.");
        }
      });
    } catch (e) {
      Toaster.showError("Error initializing Bluetooth: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Connect Bluetooth Printer",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_isScanning)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: primary,
                ),
              ),
            )
          else
            IconButton(
              tooltip: "Rescan",
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _scanBluetoothDevices,
            ),
        ],
      ),
      body: Column(
        children: [
          // 1. Radar Scanning Hero Banner
          _buildHeroScannerBanner(primary),

          // Scanning linear indicator
          if (_isScanning)
            LinearProgressIndicator(
              minHeight: 2.5,
              backgroundColor: primary.withAlpha(30),
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),

          // 2. Devices List or Empty State
          Expanded(
            child: _bluetoothDevices.isEmpty && !_isScanning
                ? _buildEmptyState(primary)
                : _buildDeviceList(primary),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroScannerBanner(Color primary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isScanning ? primary.withAlpha(120) : Colors.grey.withAlpha(50),
          width: _isScanning ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: _isScanning
                ? primary.withAlpha(25)
                : Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Radar pulsating beacon
          Stack(
            alignment: Alignment.center,
            children: [
              if (_isScanning)
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary.withAlpha(35),
                    ),
                  ),
                ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isScanning ? primary : primary.withAlpha(30),
                ),
                child: Icon(
                  Icons.bluetooth_searching_rounded,
                  size: 24,
                  color: _isScanning ? Colors.white : primary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isScanning ? "Scanning Nearby Printers" : "Bluetooth Devices",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  _isScanning
                      ? "Listening for POS & thermal printers..."
                      : "${_bluetoothDevices.length} device(s) ready to pair",
                  style: TextStyle(
                    fontSize: 12,
                    color: _isScanning ? primary : Colors.grey,
                    fontWeight: _isScanning ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isScanning ? Colors.grey.shade700 : primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            onPressed: _isScanning ? null : _scanBluetoothDevices,
            icon: Icon(
              _isScanning ? Icons.sync_rounded : Icons.search_rounded,
              size: 16,
            ),
            label: Text(
              _isScanning ? "Scanning" : "Rescan",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList(Color primary) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: _bluetoothDevices.length,
      itemBuilder: (context, index) {
        final device = _bluetoothDevices[index];
        final address = device.address ?? '';
        final isConnecting = _connectingAddress == address;
        final isConnected = _connectedAddress == address;
        final isFailed = _failedAddress == address;
        final isOtherConnecting = _connectingAddress != null && !isConnecting;

        return _buildAnimatedDeviceCard(
          device: device,
          isConnecting: isConnecting,
          isConnected: isConnected,
          isFailed: isFailed,
          isDisabled: isOtherConnecting,
          primary: primary,
        );
      },
    );
  }

  Widget _buildAnimatedDeviceCard({
    required PrinterDevice device,
    required bool isConnecting,
    required bool isConnected,
    required bool isFailed,
    required bool isDisabled,
    required Color primary,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName = device.name.trim().isNotEmpty
        ? device.name.trim()
        : "Unknown Thermal Printer";

    Color borderColor;
    Color bgColor;

    if (isConnected) {
      borderColor = Colors.green;
      bgColor = Colors.green.withAlpha(isDark ? 30 : 15);
    } else if (isConnecting) {
      borderColor = primary;
      bgColor = primary.withAlpha(isDark ? 35 : 15);
    } else if (isFailed) {
      borderColor = Colors.redAccent;
      bgColor = Colors.redAccent.withAlpha(isDark ? 30 : 15);
    } else {
      borderColor = Colors.grey.withAlpha(isDark ? 40 : 50);
      bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: isConnecting || isConnected ? 2.0 : 1.0,
        ),
        boxShadow: [
          if (isConnecting || isConnected)
            BoxShadow(
              color: (isConnected ? Colors.green : primary).withAlpha(40),
              blurRadius: 14,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 20 : 8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isDisabled || isConnecting || isConnected
              ? null
              : () => _connectDevice(device),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Printer icon badge with animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isConnected
                        ? Colors.green.withAlpha(30)
                        : (isConnecting
                            ? primary.withAlpha(30)
                            : (isDark ? Colors.grey.shade800 : Colors.grey.shade100)),
                  ),
                  child: Center(
                    child: isConnected
                        ? const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28)
                        : (isConnecting
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: primary,
                                ),
                              )
                            : Icon(
                                Icons.print_rounded,
                                color: isDark ? Colors.white70 : primary,
                                size: 24,
                              )),
                  ),
                ),
                const SizedBox(width: 14),

                // Name and Address
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isConnected
                              ? Colors.green
                              : (isConnecting ? primary : null),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          device.address ?? 'NO MAC ADDRESS',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isConnecting) ...[
                        const SizedBox(height: 3),
                        Text(
                          "Pairing with POS...",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                      ] else if (isFailed) ...[
                        const SizedBox(height: 3),
                        const Text(
                          "Connection failed. Tap to retry.",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Right Status / Action pill
                _buildActionWidget(
                  isConnecting: isConnecting,
                  isConnected: isConnected,
                  isFailed: isFailed,
                  primary: primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionWidget({
    required bool isConnecting,
    required bool isConnected,
    required bool isFailed,
    required Color primary,
  }) {
    if (isConnected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 14, color: Colors.white),
            SizedBox(width: 4),
            Text(
              "Paired",
              style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    if (isConnecting) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 6),
            Text(
              "Connecting",
              style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    if (isFailed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.redAccent.withAlpha(40),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent),
        ),
        child: const Text(
          "Retry",
          style: TextStyle(fontSize: 11, color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: primary.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bluetooth_connected, size: 13, color: primary),
          const SizedBox(width: 4),
          Text(
            "Connect",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color primary) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withAlpha(20),
              ),
              child: Icon(Icons.print_disabled_outlined, size: 40, color: primary),
            ),
            const SizedBox(height: 20),
            const Text(
              "No Bluetooth Printers Found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Make sure your thermal printer is turned ON and within range.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Troubleshooting Guide:",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "• Ensure the printer's Bluetooth indicator is flashing.\n"
                    "• If on Android, pair the printer first in your Phone's Bluetooth settings (PIN is usually 0000 or 1234).\n"
                    "• Verify location & Bluetooth permissions are granted.",
                    style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _scanBluetoothDevices,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Scan for Devices Again", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
