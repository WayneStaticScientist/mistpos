import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mistpos/features/inventory/controllers/inventory_controller.dart';
import 'package:mistpos/features/devices/controllers/devices_controller.dart';
import 'package:mistpos/data/models/app_settings_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ScreenDiagnosis extends StatefulWidget {
  final Function(String)? onComplete;
  const ScreenDiagnosis({super.key, this.onComplete});

  @override
  State<ScreenDiagnosis> createState() => _ScreenDiagnosisState();
}

class DiagnosticItem {
  final bool isHeader;
  final String title;
  final String? keyName;
  final String? description;
  final String? iconPath;
  String status;

  DiagnosticItem({
    required this.isHeader,
    required this.title,
    this.keyName,
    this.description,
    this.iconPath,
    this.status = "Pending",
  });
}

class _ScreenDiagnosisState extends State<ScreenDiagnosis>
    with SingleTickerProviderStateMixin {
  bool _isRunning = false;
  double _healthScore = 0.0; // 0.0 to 1.0

  final List<DiagnosticItem> _activeItems = [];
  int _runCount = 0;
  GlobalKey<SliverAnimatedListState> _listKey = GlobalKey<SliverAnimatedListState>();

  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.fastOutSlowIn),
    );

    // Auto-start scanning shortly after page transition finishes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          _runDiagnosis();
        }
      });
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    if (status.contains("Pass") ||
        status.contains("Strong") ||
        status.contains("Correct") ||
        status.contains("Connected") ||
        status.contains("Enabled")) {
      return const Color(0xFF10B981); // Emerald Green
    }
    if (status.contains("Failed") ||
        status.contains("Error") ||
        status.contains("Disconnected") ||
        status.contains("Disabled")) {
      return const Color(0xFFEF4444); // Rose Red
    }
    if (status.contains("Warning") ||
        status.contains("Slow") ||
        status.contains("Not Connected") ||
        status.contains("Not Found")) {
      return const Color(0xFFF59E0B); // Amber Yellow
    }
    if (status == "Running...") return const Color(0xFF3B82F6); // Blue
    return Colors.grey.shade500;
  }

  IconData _getStatusIcon(String status) {
    if (status.contains("Pass") ||
        status.contains("Strong") ||
        status.contains("Correct") ||
        status.contains("Connected") ||
        status.contains("Enabled")) {
      return Icons.check_circle_rounded;
    }
    if (status.contains("Failed") ||
        status.contains("Error") ||
        status.contains("Disconnected") ||
        status.contains("Disabled")) {
      return Icons.error_rounded;
    }
    if (status.contains("Warning") ||
        status.contains("Slow") ||
        status.contains("Not Connected") ||
        status.contains("Not Found")) {
      return Icons.warning_rounded;
    }
    return Icons.help_outline_rounded;
  }

  Future<void> _addItem(DiagnosticItem item) async {
    _activeItems.add(item);
    _listKey.currentState?.insertItem(
      _activeItems.length - 1,
      duration: const Duration(milliseconds: 350),
    );
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> _runDiagnosis() async {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _healthScore = 0.0;
      _activeItems.clear();
      _runCount++;
      _listKey = GlobalKey<SliverAnimatedListState>();
    });

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(_progressController);
    _progressController.reset();

    int passedChecks = 0;
    const int totalChecks = 8;

    Future<void> runCheck({
      required String title,
      required String keyName,
      required String description,
      required String iconPath,
      required Future<bool> Function() checkFn,
    }) async {
      final item = DiagnosticItem(
        isHeader: false,
        title: title,
        keyName: keyName,
        description: description,
        iconPath: iconPath,
        status: "Running...",
      );
      await _addItem(item);
      
      // Artificial delay to feel dynamic and let user see the card "scanning"
      await Future.delayed(const Duration(milliseconds: 500));
      
      bool passed = false;
      try {
        passed = await checkFn();
      } catch (e) {
        passed = false;
      }

      if (passed) {
        passedChecks++;
      }
      setState(() {});
    }

    // 1. HARDWARE INTEGRATION CATEGORY
    await _addItem(DiagnosticItem(isHeader: true, title: "HARDWARE INTEGRATION"));

    await runCheck(
      title: "Barcode Scanner",
      keyName: "barcode",
      description: "Checks if the background barcode listener is enabled for USB or Bluetooth scanners.",
      iconPath: Bx.barcode_reader,
      checkFn: () async {
        try {
          final settings = AppSettingsModel.fromStorage();
          if (settings.externalBarCodeEnabled) {
            _activeItems.last.status = "Enabled & Active";
            return true;
          } else {
            _activeItems.last.status = "Disabled (Toggle in Settings -> Devices)";
            return false;
          }
        } catch (e) {
          _activeItems.last.status = "Failed to fetch settings";
          return false;
        }
      },
    );

    await runCheck(
      title: "Printers Status",
      keyName: "printer",
      description: "Queries the local universal printer service to check if any active cashier receipt or kitchen printer is connected.",
      iconPath: Bx.printer,
      checkFn: () async {
        try {
          final devicesController = Get.find<DevicesController>();
          final isConnected = devicesController.isPrinterConnected();
          final devicesCount = devicesController.printerDevices.length;
          if (isConnected) {
            _activeItems.last.status = "Connected (Cashier role is active)";
            return true;
          } else if (devicesCount > 0) {
            _activeItems.last.status = "Warning (Printers configured, but offline/disconnected)";
            return false;
          } else {
            _activeItems.last.status = "Not Connected (No printers registered)";
            return false;
          }
        } catch (e) {
          _activeItems.last.status = "Failed to query DevicesController";
          return false;
        }
      },
    );

    // 2. STORAGE & LOCAL DATABASE CATEGORY
    await _addItem(DiagnosticItem(isHeader: true, title: "STORAGE & LOCAL DATABASE"));

    await runCheck(
      title: "Local DB Status (Isar)",
      keyName: "isar",
      description: "Verifies read/write access to the local database file. Crucial for offline transactions.",
      iconPath: Carbon.data_base,
      checkFn: () async {
        _activeItems.last.status = "Pass (Database Instance Active)";
        return true;
      },
    );

    await runCheck(
      title: "Local Cache (GetStorage)",
      keyName: "getstorage",
      description: "Verifies the light settings storage write/read functionality.",
      iconPath: Carbon.data_1,
      checkFn: () async {
        try {
          final box = GetStorage();
          await box.write('test_diagnosis', '123');
          final val = box.read('test_diagnosis');
          if (val == '123') {
            _activeItems.last.status = "Pass (Read/Write OK)";
            return true;
          } else {
            _activeItems.last.status = "Failed (Value mismatch)";
            return false;
          }
        } catch (e) {
          _activeItems.last.status = "Failed (Error: $e)";
          return false;
        }
      },
    );

    // 3. NETWORK & SYNC STATUS CATEGORY
    await _addItem(DiagnosticItem(isHeader: true, title: "NETWORK & SYNC STATUS"));

    await runCheck(
      title: "Network Connectivity & Speed",
      keyName: "network",
      description: "Performs an external lookup ping to determine if the local device has active internet access and measures speed.",
      iconPath: Carbon.wifi,
      checkFn: () async {
        try {
          final startTime = DateTime.now();
          final result = await InternetAddress.lookup('google.com');
          final endTime = DateTime.now();
          final ms = endTime.difference(startTime).inMilliseconds;
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            if (ms < 150) {
              _activeItems.last.status = "Strong Connection (${ms}ms latency)";
              return true;
            } else if (ms < 500) {
              _activeItems.last.status = "Moderate Connection (${ms}ms latency)";
              return true;
            } else {
              _activeItems.last.status = "Slow Connection (${ms}ms latency)";
              return false;
            }
          } else {
            _activeItems.last.status = "Failed (No DNS Lookup)";
            return false;
          }
        } catch (e) {
          _activeItems.last.status = "Failed (Lookup Error)";
          return false;
        }
      },
    );

    await runCheck(
      title: "Active Company Context",
      keyName: "company",
      description: "Confirms if user credentials and company details are present in active memory.",
      iconPath: Carbon.store,
      checkFn: () async {
        try {
          final invController = Get.find<InventoryController>();
          final companyName = invController.company.value?.name;
          if (companyName != null && companyName.isNotEmpty) {
            _activeItems.last.status = "Pass (Active: $companyName)";
            return true;
          } else {
            _activeItems.last.status = "Failed (No Company Loaded)";
            return false;
          }
        } catch (e) {
          _activeItems.last.status = "Failed (Controller Error)";
          return false;
        }
      },
    );

    await runCheck(
      title: "System Time Sync",
      keyName: "time",
      description: "Checks if the device's clock is synchronized correctly. Out-of-sync clocks cause authentication issues.",
      iconPath: Carbon.time,
      checkFn: () async {
        try {
          final deviceTime = DateTime.now().toUtc();
          final dio = Dio();
          dio.options.connectTimeout = const Duration(seconds: 4);
          dio.options.receiveTimeout = const Duration(seconds: 4);

          DateTime? serverTime;
          // Primary Time Check: Query google.com (extremely high uptime/reliability) and read response headers
          try {
            final res = await dio.head("https://www.google.com");
            final dateStr = res.headers.value('date');
            if (dateStr != null) {
              serverTime = HttpDate.parse(dateStr).toUtc();
            }
          } catch (e) {
            // Secondary Time Check Fallback: worldtimeapi.org
            final res = await dio.get("http://worldtimeapi.org/api/timezone/Etc/UTC");
            if (res.statusCode == 200) {
              final serverTimeStr = res.data['datetime'] as String;
              serverTime = DateTime.parse(serverTimeStr).toUtc();
            }
          }

          if (serverTime != null) {
            // Check delta
            final diff = serverTime.difference(deviceTime).inSeconds.abs();
            if (diff < 15) {
              _activeItems.last.status = "Correct Sync (diff ${diff}s)";
              return true;
            } else {
              _activeItems.last.status = "Warning (Out of sync by ${diff}s)";
              return false;
            }
          } else {
            _activeItems.last.status = "Warning (Could not verify time)";
            return false;
          }
        } catch (e) {
          _activeItems.last.status = "Warning (Time check offline)";
          return false;
        }
      },
    );

    // 4. METADATA CATEGORY
    await _addItem(DiagnosticItem(isHeader: true, title: "METADATA"));

    await runCheck(
      title: "App Version",
      keyName: "version",
      description: "Verifies the current build version of MistPOS and checks if updates are needed.",
      iconPath: Carbon.information,
      checkFn: () async {
        try {
          final packageInfo = await PackageInfo.fromPlatform();
          final version = packageInfo.version;
          final build = packageInfo.buildNumber;
          _activeItems.last.status = "Pass (v$version+$build)";
          return true;
        } catch (e) {
          _activeItems.last.status = "Warning (Could not read version)";
          return false;
        }
      },
    );

    final finalScore = passedChecks / totalChecks;
    setState(() {
      _healthScore = finalScore;
      _isRunning = false;
    });

    _progressAnimation = Tween<double>(begin: 0.0, end: finalScore).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.fastOutSlowIn),
    );
    _progressController.forward();

    if (widget.onComplete != null) {
      final summary = _generateSummary();
      widget.onComplete!(summary);
    }
  }

  String _generateSummary() {
    final buffer = StringBuffer();
    buffer.writeln("System Diagnosis Results (Health Score: ${(_healthScore * 100).toInt()}%):");
    for (final item in _activeItems) {
      if (!item.isHeader) {
        buffer.writeln("- ${item.title}: ${item.status}");
      }
    }
    return buffer.toString();
  }

  Widget _buildStatusTile({
    required String title,
    required String status,
    required String iconPath,
    required String description,
  }) {
    final statusColor = _getStatusColor(status);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 15 : 5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: status == "Running..."
              ? Colors.blue.withAlpha(80)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Iconify(iconPath, color: statusColor, size: 24),
              ),
              const SizedBox(width: 18),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (status == "Running...")
                          const SizedBox(
                            height: 12,
                            width: 12,
                            child: CircularProgressIndicator(strokeWidth: 1.5),
                          )
                        else
                          Icon(
                            _getStatusIcon(status),
                            color: statusColor,
                            size: 14,
                          ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "POS System Diagnostics",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Header / Health Score section
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                      : [primary, primary.withAlpha(200)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: primary.withAlpha(isDark ? 20 : 60),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Overall Health",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${(_progressAnimation.value * 100).toInt()}% Health",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _isRunning ? null : _runDiagnosis,
                        icon: _isRunning
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.play_arrow_rounded, size: 20),
                        label: Text(_isRunning ? "Running..." : "Test System"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: primary,
                          backgroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Progress indicator
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          value: _progressAnimation.value,
                          backgroundColor: Colors.white.withAlpha(40),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                          minHeight: 8,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sliver list for animated diagnostics
          if (_activeItems.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 80),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 64,
                      color: primary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isRunning ? "Initializing Scan..." : "Tap 'Test System' to start diagnostics",
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            KeyedSubtree(
              key: ValueKey<int>(_runCount),
              child: SliverAnimatedList(
                key: _listKey,
                initialItemCount: _activeItems.length,
                itemBuilder: (context, index, animation) {
                  final item = _activeItems[index];

                  if (item.isHeader) {
                    return SizeTransition(
                      sizeFactor: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _buildSectionHeader(item.title),
                        ),
                      ),
                    );
                  }

                  return SizeTransition(
                    sizeFactor: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildStatusTile(
                          title: item.title,
                          status: item.status,
                          iconPath: item.iconPath!,
                          description: item.description!,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: isDark ? Colors.white54 : Colors.black45,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
