import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mistpos/core/utils/toast.dart';

class ReceiptGuideModal extends StatefulWidget {
  final Function(String tag)? onInsertTag;

  const ReceiptGuideModal({super.key, this.onInsertTag});

  @override
  State<ReceiptGuideModal> createState() => _ReceiptGuideModalState();
}

class _ReceiptGuideModalState extends State<ReceiptGuideModal> {
  String _search = '';
  String _activeCategory = 'All';

  final List<Map<String, dynamic>> _allTags = [
    // Branding / Logo
    {
      'tag': '{logo}',
      'desc': 'Receipt logo uploaded in Settings or Designer (thermal bitmap)',
      'category': 'Formatting',
      'example': '[Thermal Logo Bitmap]',
    },

    // Staff / Till
    {
      'tag': '{cashier}',
      'desc': 'Name or username of the active cashier',
      'category': 'Staff',
      'example': 'Blessing Moyo',
    },
    {
      'tag': '{seller}',
      'desc': 'Full name of the sales representative',
      'category': 'Staff',
      'example': 'Blessing Moyo',
    },
    {
      'tag': '{till}',
      'desc': 'POS terminal / Till counter number',
      'category': 'Staff',
      'example': '1',
    },
    {
      'tag': '{role}',
      'desc': 'User role (admin, manager, cashier)',
      'category': 'Staff',
      'example': 'cashier',
    },

    // Customer
    {
      'tag': '{customer}',
      'desc': 'Customer full name or "Cash Sales"',
      'category': 'Customer',
      'example': 'Cash Sales',
    },
    {
      'tag': '{customer_phone}',
      'desc': 'Customer phone number',
      'category': 'Customer',
      'example': '+263770000000',
    },
    {
      'tag': '{customer_email}',
      'desc': 'Customer email address',
      'category': 'Customer',
      'example': 'customer@example.com',
    },
    {
      'tag': '{customer_address}',
      'desc': 'Customer delivery or billing address',
      'category': 'Customer',
      'example': 'Harare, Zimbabwe',
    },
    {
      'tag': '{customer_tin}',
      'desc': 'Customer TIN number for B2B tax invoicing',
      'category': 'Customer',
      'example': '000000000',
    },
    {
      'tag': '{customer_vat}',
      'desc': 'Customer VAT registration number',
      'category': 'Customer',
      'example': '000000000',
    },

    // Transaction & Totals
    {
      'tag': '{receipt_no}',
      'desc': 'Short receipt sequence number or hex ID',
      'category': 'Financials',
      'example': '17291',
    },
    {
      'tag': '{currency}',
      'desc': 'Currency symbol / ISO code (e.g. USD, \$, ZiG)',
      'category': 'Financials',
      'example': 'USD',
    },
    {
      'tag': '{total}',
      'desc': 'Net total payable amount formatted',
      'category': 'Financials',
      'example': '27.00',
    },
    {
      'tag': '{subtotal}',
      'desc': 'Total price before taxes & levies',
      'category': 'Financials',
      'example': '24.18',
    },
    {
      'tag': '{amount_charged}',
      'desc': 'Amount tendered / handed over by client',
      'category': 'Financials',
      'example': '27.00',
    },
    {
      'tag': '{change}',
      'desc': 'Change amount returned to client',
      'category': 'Financials',
      'example': '0.00',
    },
    {
      'tag': '{payment_method}',
      'desc': 'Payment method (CASH, CARD, ECOPAY, PAYNOW, CREDIT)',
      'category': 'Financials',
      'example': 'CASH',
    },
    {
      'tag': '{tax_amount}',
      'desc': 'Total tax / VAT amount charged',
      'category': 'Financials',
      'example': '2.82',
    },
    {
      'tag': '{vat_rate}',
      'desc': 'Current VAT percentage rate',
      'category': 'Financials',
      'example': '15.50',
    },
    {
      'tag': '{number_of_items}',
      'desc': 'Total count of units sold in receipt',
      'category': 'Financials',
      'example': '26',
    },

    // Dates & Times
    {
      'tag': '{date_formatted}',
      'desc': 'Standard local date formatted (DD-MM-YYYY)',
      'category': 'Date & Time',
      'example': '23-09-2026',
    },
    {
      'tag': '{time}',
      'desc': 'Standard 24h time formatted (HH:MM)',
      'category': 'Date & Time',
      'example': '14:50',
    },
    {
      'tag': '{time_hour}',
      'desc': 'Hour of transaction (00-23)',
      'category': 'Date & Time',
      'example': '14',
    },
    {
      'tag': '{time_minute}',
      'desc': 'Minute of transaction (00-59)',
      'category': 'Date & Time',
      'example': '50',
    },
    {
      'tag': '{time_second}',
      'desc': 'Second of transaction (00-59)',
      'category': 'Date & Time',
      'example': '12',
    },
    {
      'tag': '{day}',
      'desc': 'Day of month (01-31)',
      'category': 'Date & Time',
      'example': '23',
    },
    {
      'tag': '{month}',
      'desc': 'Month number (01-12)',
      'category': 'Date & Time',
      'example': '09',
    },
    {
      'tag': '{year}',
      'desc': 'Full 4-digit calendar year',
      'category': 'Date & Time',
      'example': '2026',
    },
    {
      'tag': '{day_of_week}',
      'desc': 'Numeric day of week (1=Mon ... 7=Sun)',
      'category': 'Date & Time',
      'example': '3',
    },
    {
      'tag': '{week_name}',
      'desc': 'Name of the day with custom mapping support',
      'category': 'Date & Time',
      'example': 'Wednesday (or custom mapping)',
    },
    {
      'tag': '{month_name}',
      'desc': 'Name of the month with custom mapping support',
      'category': 'Date & Time',
      'example': 'September (or custom mapping)',
    },
    {
      'tag': '{date_iso}',
      'desc': 'ISO-8601 formatted datetime string',
      'category': 'Date & Time',
      'example': '2026-09-23T14:50:00Z',
    },

    // List Loop
    {
      'tag': '{list}...{/list}',
      'desc': 'Repeat loop block for each item in the receipt',
      'category': 'Items List',
      'example': '{list}\n{item_row}\n{/list}',
    },
    {
      'tag': '{item_header}',
      'desc': 'Standard aligned 4-column header (ITEM, QTY, PRICE, TOTAL) fitted to paper width',
      'category': 'Items List',
      'example': 'ITEM                  QTY    PRICE    TOTAL',
    },
    {
      'tag': '{item_row}',
      'desc': 'Standard 4-column item row (Qty, Price, Total aligned on line 1, long name wrapped to line 2)',
      'category': 'Items List',
      'example': 'VINUT BASIL SE..       12    \$1.50   \$18.00\nED KIWI',
    },
    {
      'tag': '{itemname}',
      'desc': 'Name of the product in the loop',
      'category': 'Items List',
      'example': 'DENDAIRY MAAS 1L',
    },
    {
      'tag': '{itemcount}',
      'desc': 'Quantity of the item purchased',
      'category': 'Items List',
      'example': '12',
    },
    {
      'tag': '{itemprice}',
      'desc': 'Unit selling price of the item',
      'category': 'Items List',
      'example': '1.50',
    },
    {
      'tag': '{itemtotal}',
      'desc': 'Total price for this line item (qty * unit price)',
      'category': 'Items List',
      'example': '18.00',
    },
    {
      'tag': '{itemcode}',
      'desc': 'Product barcode or SKU identifier',
      'category': 'Items List',
      'example': 'SKU-00412',
    },

    // Lines & Dividers
    {
      'tag': '{line:-}',
      'desc': 'Full width divider line using dash character (-)',
      'category': 'Formatting',
      'example': '------------------------------------------',
    },
    {
      'tag': '{line:=}',
      'desc': 'Full width double-divider line (=)',
      'category': 'Formatting',
      'example': '==========================================',
    },
    {
      'tag': '{line:*}',
      'desc': 'Full width star-divider line (*)',
      'category': 'Formatting',
      'example': '******************************************',
    },
    {
      'tag': '{line:half}',
      'desc': 'Half width divider centered on receipt',
      'category': 'Formatting',
      'example': '---------------------',
    },
    {
      'tag': '{repeat:. 32}',
      'desc': 'Repeat custom character specified count times',
      'category': 'Formatting',
      'example': '................................',
    },

    // Barcodes & QR
    {
      'tag': '{zimra_qr}',
      'desc': 'Official ZIMRA FDMS fiscal verification QR code',
      'category': 'Fiscal & QR',
      'example': '[QR Code Image]',
    },
    {
      'tag': '{zimra_verification_code}',
      'desc': '8-digit verification code extracted from digital signature',
      'category': 'Fiscal & QR',
      'example': 'A1B2-C3D4',
    },
    {
      'tag': '{zimra_manual_url}',
      'desc': 'Official ZIMRA manual receipt verification URL',
      'category': 'Fiscal & QR',
      'example': 'https://fdms.zimra.co.zw',
    },
    {
      'tag': '{barcode}',
      'desc': 'Code128 barcode of receipt number',
      'category': 'Fiscal & QR',
      'example': '[Barcode Image]',
    },
    {
      'tag': '{qrcode}',
      'desc': 'Generic QR code with receipt URL or verification link',
      'category': 'Fiscal & QR',
      'example': '[QR Code Image]',
    },

    // Modifiers
    {
      'tag': '{align:center}',
      'desc': 'Align subsequent text in line to center',
      'category': 'Formatting',
      'example': '{align:center}FISCAL RECEIPT',
    },
    {
      'tag': '{align:right}',
      'desc': 'Align subsequent text in line to right margin',
      'category': 'Formatting',
      'example': '{align:right}TOTAL: \$27.00',
    },
    {
      'tag': '{bold}...{/bold}',
      'desc': 'Embolden enclosed text on thermal printer',
      'category': 'Formatting',
      'example': '{bold}TOTAL: \$27.00{/bold}',
    },
    {
      'tag': '{feed:2}',
      'desc': 'Feed blank thermal paper lines before cut',
      'category': 'Formatting',
      'example': '{feed:2}',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;
    final categories = ['All', 'Staff', 'Customer', 'Financials', 'Date & Time', 'Items List', 'Formatting', 'Fiscal & QR'];

    final filtered = _allTags.where((t) {
      final matchesCat = _activeCategory == 'All' || t['category'] == _activeCategory;
      final matchesSearch = _search.isEmpty ||
          t['tag'].toString().toLowerCase().contains(_search.toLowerCase()) ||
          t['desc'].toString().toLowerCase().contains(_search.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title & Close
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Receipt Template V2 Guide",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Learn tags, variables, modifiers and how to customize receipts",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search Bar
          TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: "Search tags (e.g. {total}, {list}, {cashier})...",
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          const SizedBox(height: 10),

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((c) {
                final isSel = _activeCategory == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(c, style: TextStyle(fontSize: 12, color: isSel ? Colors.white : null)),
                    selected: isSel,
                    selectedColor: themeColor,
                    showCheckmark: false,
                    onSelected: (val) => setState(() => _activeCategory = c),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 16),

          // Tutorial Quick Card
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: themeColor.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: themeColor.withAlpha(60)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: themeColor, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Tap any tag below to copy it or insert it directly into your template. Custom week & month names can be configured per template!",
                    style: TextStyle(fontSize: 11.5, color: themeColor.withAlpha(220), height: 1.3),
                  ),
                ),
              ],
            ),
          ),

          // Tags List
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      "No tags match your search query.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final tag = item['tag'] as String;
                      final desc = item['desc'] as String;
                      final example = item['example'] as String;
                      final cat = item['category'] as String;

                      return InkWell(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: tag));
                          Toaster.showSuccess("Copied $tag to clipboard!");
                          if (widget.onInsertTag != null) {
                            widget.onInsertTag!(tag);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withAlpha(40),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey.withAlpha(60)),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: themeColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      desc,
                                      style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Example: $example",
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withAlpha(20),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  cat,
                                  style: TextStyle(fontSize: 9.5, color: Colors.grey.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
