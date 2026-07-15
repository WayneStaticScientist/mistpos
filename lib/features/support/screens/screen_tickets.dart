import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:mistpos/features/support/controllers/support_controller.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/widgets/loaders/small_loader.dart';

class ScreenTickets extends StatelessWidget {
  ScreenTickets({super.key});

  final SupportController _controller = Get.put(SupportController());

  // ─── Status helpers ────────────────────────────────────────────────────────
  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'closed':
        return const Color(0xFF6B7280);
      case 'replied':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF10B981);
    }
  }

  static IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'closed':
        return Icons.check_circle_rounded;
      case 'replied':
        return Icons.reply_rounded;
      default:
        return Icons.radio_button_checked_rounded;
    }
  }

  // ─── New Ticket Dialog ─────────────────────────────────────────────────────
  static void showNewTicketDialog(BuildContext context) {
    final controller = Get.find<SupportController>();
    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1C1F2E) : Colors.white,
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primary, primary.withAlpha(200)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.support_agent, color: Colors.white, size: 22),
                    12.gapWidth,
                    const Expanded(
                      child: Text(
                        "New Support Ticket",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              // Form
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FormField(
                      controller: subjectCtrl,
                      label: "Subject",
                      hint: "What do you need help with?",
                      icon: Icons.title_rounded,
                      isDark: isDark,
                      primary: primary,
                    ),
                    16.gapHeight,
                    _FormField(
                      controller: messageCtrl,
                      label: "Describe your issue",
                      hint: "Provide as much detail as possible...",
                      icon: Icons.notes_rounded,
                      isDark: isDark,
                      primary: primary,
                      maxLines: 5,
                      alignLabelWithHint: true,
                    ),
                    24.gapHeight,
                    Obx(() => _SubmitButton(
                          isLoading: controller.isSubmitting.value,
                          primary: primary,
                          onPressed: () async {
                            final ok = await controller.createTicket(
                              subjectCtrl.text,
                              messageCtrl.text,
                            );
                            if (ok) Get.back();
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Ticket Chat Bottom Sheet ──────────────────────────────────────────────
  void _showTicketChat(BuildContext context, dynamic ticket) {
    final replyCtrl = TextEditingController();
    final scrollCtrl = ScrollController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final status = ticket['status'] ?? 'Open';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollCtrl.hasClients) {
        scrollCtrl.jumpTo(scrollCtrl.position.maxScrollExtent);
      }
    });

    Get.bottomSheet(
      Container(
        height: Get.height * 0.88,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1117) : const Color(0xFFF5F6FA),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 4),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(80),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F1117) : Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withAlpha(30)),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket['subject'] ?? 'Ticket',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        4.gapHeight,
                        Row(
                          children: [
                            Icon(_statusIcon(status), color: _statusColor(status), size: 12),
                            4.gapWidth,
                            Text(
                              status,
                              style: TextStyle(
                                color: _statusColor(status),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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
            // Messages
            Expanded(
              child: Obx(() {
                final current = _controller.tickets.firstWhere(
                  (t) => t['_id'] == ticket['_id'],
                  orElse: () => ticket,
                );
                final msgs = current['messages'] as List? ?? [];
                if (msgs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded,
                            size: 48, color: Colors.grey.withAlpha(80)),
                        12.gapHeight,
                        Text("No messages yet", style: TextStyle(color: Colors.grey.shade500)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: msgs.length,
                  itemBuilder: (ctx, i) {
                    final msg = msgs[i];
                    final isUser = msg['senderType'] == 'user';
                    final dateStr = msg['createdAt'];
                    final date = dateStr != null ? DateTime.parse(dateStr) : DateTime.now();
                    return _ChatBubble(
                      text: msg['text'] ?? '',
                      date: MistDateUtils.getInformalDate(date),
                      isUser: isUser,
                      primary: primary,
                      isDark: isDark,
                    );
                  },
                );
              }),
            ),
            // Input
            if (status.toLowerCase() != 'closed')
              _ChatInput(
                controller: replyCtrl,
                isDark: isDark,
                primary: primary,
                isSubmitting: _controller.isSubmitting,
                onSend: () async {
                  if (replyCtrl.text.trim().isEmpty) return;
                  final ok = await _controller.replyToTicket(
                    ticket['_id'],
                    replyCtrl.text.trim(),
                  );
                  if (ok) {
                    replyCtrl.clear();
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (scrollCtrl.hasClients) {
                        scrollCtrl.animateTo(
                          scrollCtrl.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    });
                  }
                },
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                color: isDark ? const Color(0xFF0F1117) : Colors.white,
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline_rounded, size: 16, color: Colors.grey.shade400),
                      8.gapWidth,
                      Text("This ticket is closed",
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(child: MistLoader1());
      }

      if (_controller.tickets.isEmpty) {
        return _EmptyState(primary: primary, onTap: () => showNewTicketDialog(context));
      }

      final open = _controller.tickets.where((t) => (t['status'] ?? '').toString().toLowerCase() == 'open').length;
      final replied = _controller.tickets.where((t) => (t['status'] ?? '').toString().toLowerCase() == 'replied').length;
      final closed = _controller.tickets.where((t) => (t['status'] ?? '').toString().toLowerCase() == 'closed').length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stats row
          Row(
            children: [
              _StatChip(label: "Open", count: open, color: const Color(0xFF10B981)),
              8.gapWidth,
              _StatChip(label: "Awaiting Reply", count: replied, color: const Color(0xFFF59E0B)),
              8.gapWidth,
              _StatChip(label: "Closed", count: closed, color: const Color(0xFF6B7280)),
            ],
          ),
          16.gapHeight,
          Expanded(
            child: ListView.separated(
              itemCount: _controller.tickets.length,
              separatorBuilder: (_, __) => 10.gapHeight,
              itemBuilder: (context, i) {
                final ticket = _controller.tickets[i];
                final status = ticket['status'] ?? 'Open';
                final sc = _statusColor(status);
                final updatedAtStr = ticket['updatedAt'];
                final updatedAt = updatedAtStr != null
                    ? DateTime.parse(updatedAtStr)
                    : DateTime.now();
                final msgCount = (ticket['messages'] as List?)?.length ?? 0;

                return _TicketCard(
                  ticket: ticket,
                  status: status,
                  statusColor: sc,
                  updatedAt: updatedAt,
                  msgCount: msgCount,
                  isDark: isDark,
                  primary: primary,
                  onTap: () => _showTicketChat(context, ticket),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _TicketCard extends StatelessWidget {
  final dynamic ticket;
  final String status;
  final Color statusColor;
  final DateTime updatedAt;
  final int msgCount;
  final bool isDark;
  final Color primary;
  final VoidCallback onTap;

  const _TicketCard({
    required this.ticket,
    required this.status,
    required this.statusColor,
    required this.updatedAt,
    required this.msgCount,
    required this.isDark,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1F2E) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(color: statusColor, width: 4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDark ? 40 : 8),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Row(
              children: [
                // Status dot
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: statusColor.withAlpha(100), blurRadius: 6),
                    ],
                  ),
                ),
                12.gapWidth,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket['subject'] ?? 'Support Ticket',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      6.gapHeight,
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded,
                              size: 12, color: Colors.grey.shade400),
                          4.gapWidth,
                          Text(
                            MistDateUtils.getInformalDate(updatedAt),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          if (msgCount > 0) ...[
                            12.gapWidth,
                            Icon(Icons.chat_bubble_outline_rounded,
                                size: 12, color: Colors.grey.shade400),
                            4.gapWidth,
                            Text(
                              "$msgCount",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                12.gapWidth,
                // Status pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withAlpha(60)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(ScreenTickets._statusIcon(status), color: statusColor, size: 10),
                      4.gapWidth,
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                8.gapWidth,
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withAlpha(15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withAlpha(40)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$count",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: color,
              ),
            ),
            Text(label, style: TextStyle(fontSize: 11, color: color.withAlpha(180))),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Color primary;
  final VoidCallback onTap;
  const _EmptyState({required this.primary, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: primary.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.support_agent_rounded, size: 64, color: primary),
          ),
          20.gapHeight,
          const Text("No Support Tickets",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          8.gapHeight,
          const Text(
            "Have a question or issue? Our team is here to help.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          24.gapHeight,
          ElevatedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.add_rounded),
            label: const Text("Open a Ticket"),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool isDark;
  final Color primary;
  final int maxLines;
  final bool alignLabelWithHint;

  const _FormField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.isDark,
    required this.primary,
    this.maxLines = 1,
    this.alignLabelWithHint = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: alignLabelWithHint,
        prefixIcon: Icon(icon, color: primary, size: 20),
        filled: true,
        fillColor: isDark ? Colors.white.withAlpha(8) : Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.withAlpha(60)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.withAlpha(50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final Color primary;
  final VoidCallback onPressed;
  const _SubmitButton({required this.isLoading, required this.primary, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text("Submit Ticket",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final String date;
  final bool isUser;
  final Color primary;
  final bool isDark;
  const _ChatBubble({
    required this.text,
    required this.date,
    required this.isUser,
    required this.primary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(maxWidth: Get.width * 0.72),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? primary : (isDark ? const Color(0xFF1C1F2E) : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: isUser ? null : Border.all(color: Colors.grey.withAlpha(30)),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(6), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "Support",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isUser ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                height: 1.4,
              ),
            ),
            6.gapHeight,
            Text(
              date,
              style: TextStyle(
                fontSize: 10,
                color: isUser ? Colors.white60 : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final Color primary;
  final RxBool isSubmitting;
  final VoidCallback onSend;

  const _ChatInput({
    required this.controller,
    required this.isDark,
    required this.primary,
    required this.isSubmitting,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F1117) : Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withAlpha(30))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: 3,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: "Write your message...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: isDark ? Colors.white.withAlpha(8) : Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.withAlpha(40)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.withAlpha(40)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: primary, width: 1.5),
                  ),
                ),
              ),
            ),
            10.gapWidth,
            Obx(() => GestureDetector(
                  onTap: isSubmitting.value ? null : onSend,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSubmitting.value ? Colors.grey.shade300 : primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primary.withAlpha(80),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isSubmitting.value
                        ? const Padding(
                            padding: EdgeInsets.all(14),
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
