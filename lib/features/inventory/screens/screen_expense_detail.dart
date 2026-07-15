import 'package:flutter/material.dart';
import 'package:mistpos/core/utils/date_utils.dart';
import 'package:mistpos/core/utils/currence_converter.dart';
import 'package:mistpos/data/models/expense_model.dart';

class ScreenExpenseDetail extends StatelessWidget {
  final ExpenseModel expense;
  const ScreenExpenseDetail({super.key, required this.expense});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return const Color(0xFF00C896);
      case 'rejected':
        return const Color(0xFFFF4C6A);
      default:
        return const Color(0xFFFFA726);
    }
  }

  IconData _paymentIcon(String type) {
    switch (type.toLowerCase()) {
      case 'bank':
        return Icons.account_balance;
      case 'card':
        return Icons.credit_card;
      default:
        return Icons.payments_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final bg = isDark ? const Color(0xFF0F1117) : const Color(0xFFF4F6FB);
    final cardBg = isDark ? const Color(0xFF1C1F2E) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1D2E);
    final textSecondary = isDark ? Colors.white54 : const Color(0xFF7B8099);
    final statusColor = _statusColor(expense.status);

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // — Hero App Bar —
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primary, primary.withBlue((primary.blue + 60).clamp(0, 255))],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),
                      // Amount
                      Text(
                        CurrenceConverter.selectedCurrencyInString(expense.amount),
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Category pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withAlpha(60)),
                        ),
                        child: Text(
                          expense.category['label'] ?? '—',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor.withAlpha(120)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 8, color: statusColor),
                            const SizedBox(width: 6),
                            Text(
                              expense.status.toUpperCase(),
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // — Body —
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date & Time card
                  _SectionCard(
                    cardBg: cardBg,
                    child: Row(
                      children: [
                        _IconBox(icon: Icons.calendar_month_rounded, color: primary),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MistDateUtils.formatNormalDate(expense.date),
                              style: TextStyle(
                                color: textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              MistDateUtils.formatTime(expense.date),
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Details card
                  _SectionCard(
                    cardBg: cardBg,
                    child: Column(
                      children: [
                        _DetailRow(
                          icon: Icons.receipt_long_rounded,
                          label: 'Expense For',
                          value: expense.expenseFor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          iconColor: primary,
                        ),
                        _Divider(),
                        _DetailRow(
                          icon: _paymentIcon(expense.paymentType),
                          label: 'Payment Method',
                          value: expense.paymentType,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          iconColor: primary,
                        ),
                        if (expense.referenceNumber.isNotEmpty) ...[
                          _Divider(),
                          _DetailRow(
                            icon: Icons.tag_rounded,
                            label: 'Reference #',
                            value: expense.referenceNumber,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary,
                            iconColor: primary,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Notes card
                  if (expense.notes.isNotEmpty) ...[
                    _SectionCard(
                      cardBg: cardBg,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _IconBox(icon: Icons.notes_rounded, color: primary),
                              const SizedBox(width: 12),
                              Text(
                                'Notes',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            expense.notes,
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Submitted by card
                  if (expense.senderId != null && expense.senderId.toString().isNotEmpty)
                    _SectionCard(
                      cardBg: cardBg,
                      child: _DetailRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Submitted By',
                        value: _parseSender(expense.senderId),
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                        iconColor: primary,
                      ),
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _parseSender(dynamic sender) {
    if (sender is Map) {
      return sender['fullName'] ?? sender['email'] ?? sender['role'] ?? 'Unknown';
    }
    return sender.toString();
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  final Color cardBg;
  const _SectionCard({required this.child, required this.cardBg});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _IconBox({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color textPrimary;
  final Color textSecondary;
  final Color iconColor;
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.textPrimary,
    required this.textSecondary,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBox(icon: icon, color: iconColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: textSecondary, fontSize: 12)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, color: Colors.grey.withAlpha(40)),
    );
  }
}
