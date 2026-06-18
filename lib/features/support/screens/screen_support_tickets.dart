import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/core/widgets/layouts/centered_error.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';
import 'package:mistpos/features/settings/screens/screen_subscription.dart';
import 'package:mistpos/features/support/controllers/support_controller.dart';

class ScreenSupportTickets extends StatefulWidget {
  const ScreenSupportTickets({Key? key}) : super(key: key);

  @override
  State<ScreenSupportTickets> createState() => _ScreenSupportTicketsState();
}

class _ScreenSupportTicketsState extends State<ScreenSupportTickets> {
  final SupportController _controller = Get.find<SupportController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final surface = isDark ? const Color(0xFF0F1117) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        title: const Text('Support Tickets'),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (!_controller.canAccessSupport) {
          // Upgrade banner for free users
          return _upgradeBanner(primary);
        }
        if (_controller.isLoading.value) {
          return Center(child: MistLoader1().center());
        }
        if (_controller.tickets.isEmpty) {
          return const Center(
            child: Text(
              'No tickets yet. Tap the + button to create one.',
              style: TextStyle(fontSize: 16),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: _controller.fetchTickets,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: _controller.tickets.length,
            itemBuilder: (context, index) {
              final ticket = _controller.tickets[index];
              final subject = ticket['subject'] ?? 'No Subject';
              final message = ticket['message'] ?? '';
              final status = ticket['status'] ?? 'open';
              final createdAtStr = ticket['createdAt'];
              DateTime? createdAt;
              if (createdAtStr != null) {
                try {
                  createdAt = DateTime.parse(createdAtStr);
                } catch (_) {}
              }

              return _ticketCard(
                subject: subject,
                preview: message.length > 80
                    ? '${message.substring(0, 80)}...'
                    : message,
                status: status,
                date: createdAt != null
                    ? MistDateUtils.getInformalDate(createdAt)
                    : '',
                isDark: isDark,
                primary: primary,
                onTap: () => _showTicketDetail(ticket),
              );
            },
          ),
        );
      }),
      floatingActionButton: _controller.canAccessSupport
          ? FloatingActionButton.extended(
              backgroundColor: primary,
              icon: const Icon(Icons.add),
              label: const Text('New Ticket'),
              onPressed: _showCreateTicketDialog,
            )
          : null,
    );
  }

  Widget _upgradeBanner(Color primary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 64, color: Colors.amber.shade600),
            const SizedBox(height: 12),
            const Text(
              'Support tickets are a premium feature.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Upgrade your subscription to get unlimited support.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Get.to(() => const ScreenSubscription()),
              icon: const Icon(Icons.upgrade),
              label: const Text('Upgrade Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketCard({
    required String subject,
    required String preview,
    required String status,
    required String date,
    required bool isDark,
    required Color primary,
    required VoidCallback onTap,
  }) {
    final statusColor = status.toLowerCase() == 'closed'
        ? Colors.green.shade400
        : Colors.redAccent;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark ? Colors.white.withAlpha(15) : Colors.white.withAlpha(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Iconify(Carbon.ticket, color: primary, size: 28),
        title: Text(
          subject,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(preview, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Row(
              children: [
                Chip(
                  label: Text(status.toUpperCase()),
                  backgroundColor: statusColor.withAlpha(30),
                  labelStyle: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  void _showTicketDetail(dynamic ticket) {
    final subject = ticket['subject'] ?? '';
    final message = ticket['message'] ?? '';
    final status = ticket['status'] ?? 'open';
    final createdAtStr = ticket['createdAt'];
    DateTime? createdAt;
    if (createdAtStr != null) {
      try {
        createdAt = DateTime.parse(createdAtStr);
      } catch (_) {}
    }
    // Reply controller for the dialog
    final replyCtrl = TextEditingController();
    Get.defaultDialog(
      title: subject,
      barrierDismissible: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status: ${status.toUpperCase()}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (createdAt != null)
            Text(
              'Created: ${MistDateUtils.getInformalDate(createdAt)}',
              style: const TextStyle(color: Colors.grey),
            ),
          const SizedBox(height: 12),
          Text(message),
          const Divider(height: 24),
          TextField(
            controller: replyCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Add a reply...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      textCancel: 'Close',
      textConfirm: 'Send Reply',
      onConfirm: () async {
        final msg = replyCtrl.text.trim();
        if (msg.isNotEmpty) {
          final success = await _controller.replyToTicket(
            ticket['id'].toString(),
            msg,
          );
          if (success) {
            Toaster.showSuccess('Reply sent');
          }
        }
        Get.back();
      },
    );
  }

  void _showCreateTicketDialog() {
    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();
    Get.defaultDialog(
      title: 'Create New Ticket',
      barrierDismissible: false,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: subjectCtrl,
            decoration: const InputDecoration(labelText: 'Subject'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: messageCtrl,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Message'),
          ),
        ],
      ),
      textCancel: 'Cancel',
      textConfirm: 'Create',
      onConfirm: () async {
        final subject = subjectCtrl.text.trim();
        final message = messageCtrl.text.trim();
        if (subject.isEmpty || message.isEmpty) {
          Toaster.showError('Both fields are required');
          return;
        }
        final success = await _controller.createTicket(subject, message);
        if (success) {
          Toaster.showSuccess('Ticket created');
        }
        Get.back();
      },
    );
  }
}
