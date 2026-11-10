import '../models/receipt_template_v2_model.dart';

class DefaultV2Templates {
  /// Prebuilt Template 1: Standard ZIMRA Fiscal Thermal Receipt
  static ReceiptTemplateV2Model get zimraFiscal => ReceiptTemplateV2Model(
        id: 'preset_zimra_fiscal',
        name: 'ZIMRA Fiscal Thermal (Standard)',
        description:
            'Zimbabwean FDMS Fiscal thermal receipt with TIN, VAT, itemized columns, subtotal, 15.5% VAT, and large verification QR code.',
        category: 'fiscal',
        author: 'MistPOS Official',
        paperWidth: 42,
        tags: ['zimra', 'fiscal', 'standard', 'retail', 'zimbabwe'],
        templateContent:
            '''{align:center}{logo}

{align:left}Date: {date_formatted} {time}
{align:left}Receipt #: {receipt_no}
{align:left}Customer: {customer}
{align:left}Phone: {customer_phone}
{align:left}Email: {customer_email}

{align:center}{bold}FISCAL RECEIPT{/bold}
{line:-}
{item_header}
{line:-}
{list}
{item_row}
{/list}
{line:-}
{align:right}Subtotal: {subtotal}
{align:right}VAT (Standard) {vat_rate}%: {tax_amount}
{line:-}
{align:right}{bold}TOTAL: {currency} {total}{/bold}
{line:-}
{align:left}Payment Method: {payment_method}

{align:center}{zimra_qr}
{align:center}Verification code: {zimra_verification_code}
{align:center}You can verify this receipt manually at
{align:center}{zimra_manual_url}
{feed:2}''',
        blocks: [
          ReceiptBlockV2(
            id: 'b_logo',
            type: ReceiptBlockType.logo,
            align: 'center',
          ),
          ReceiptBlockV2(
            id: 'b2',
            type: ReceiptBlockType.text,
            content: 'Date: {date_formatted} {time}\nReceipt #: {receipt_no}',
            align: 'left',
            isBold: false,
          ),
          ReceiptBlockV2(
            id: 'b3_cust',
            type: ReceiptBlockType.customerInfo,
            content: 'Customer: {customer}\nPhone: {customer_phone}\nEmail: {customer_email}',
            align: 'left',
            isBold: false,
          ),
          ReceiptBlockV2(
            id: 'b4',
            type: ReceiptBlockType.fiscalHeader,
            align: 'center',
            isBold: true,
          ),
          ReceiptBlockV2(
            id: 'b5',
            type: ReceiptBlockType.line,
            char: '-',
            length: 'full',
          ),
          ReceiptBlockV2(
            id: 'b6',
            type: ReceiptBlockType.text,
            content: '{item_header}',
            align: 'left',
            isBold: false,
          ),
          ReceiptBlockV2(
            id: 'b7',
            type: ReceiptBlockType.line,
            char: '-',
            length: 'full',
          ),
          ReceiptBlockV2(
            id: 'b8',
            type: ReceiptBlockType.list,
            listFormat: '{item_row}',
          ),
          ReceiptBlockV2(
            id: 'b9',
            type: ReceiptBlockType.line,
            char: '-',
            length: 'full',
          ),
          ReceiptBlockV2(
            id: 'b10',
            type: ReceiptBlockType.text,
            content:
                'Subtotal: {subtotal}\nVAT (Standard) {vat_rate}%: {tax_amount}',
            align: 'right',
            isBold: false,
          ),
          ReceiptBlockV2(
            id: 'b11',
            type: ReceiptBlockType.line,
            char: '-',
            length: 'full',
          ),
          ReceiptBlockV2(
            id: 'b12',
            type: ReceiptBlockType.text,
            content: 'TOTAL: {currency} {total}',
            align: 'right',
            isBold: true,
          ),
          ReceiptBlockV2(
            id: 'b13',
            type: ReceiptBlockType.line,
            char: '-',
            length: 'full',
          ),
          ReceiptBlockV2(
            id: 'b14',
            type: ReceiptBlockType.text,
            content: 'Payment Method: {payment_method}',
            align: 'left',
            isBold: false,
          ),
          ReceiptBlockV2(
            id: 'b15',
            type: ReceiptBlockType.zimraQr,
            align: 'center',
          ),
          ReceiptBlockV2(
            id: 'b16',
            type: ReceiptBlockType.spacer,
            lines: 2,
          ),
        ],
      );

  /// Prebuilt Template 2: Modern Retail & Boutique
  static ReceiptTemplateV2Model get modernRetail => ReceiptTemplateV2Model(
        id: 'preset_modern_retail',
        name: 'Modern Retail & Fashion',
        description:
            'Sophisticated modern layout with clean borderlines, cashier terminal badges, and bottom barcode.',
        category: 'retail',
        author: 'MistPOS Studio',
        paperWidth: 42,
        tags: ['retail', 'modern', 'fashion', 'barcode'],
        templateContent:
            '''{align:center}{logo}
{line:=}
{align:left}Cashier: {cashier} | Till: {till}
{align:left}Receipt: #{receipt_no} | {date_formatted} {time}
{align:left}Client: {customer}
{line:-}
{list}
{itemname}
  Qty: {itemcount} @ {itemprice}      Total: {itemtotal}
{/list}
{line:-}
{align:right}Subtotal: {subtotal}
{align:right}Tax: {tax_amount}
{align:right}{bold}NET TOTAL: {currency} {total}{/bold}
{align:right}Tendered ({payment_method}): {amount_charged}
{align:right}Change Due: {change}
{line:=}
{align:center}{barcode}
{align:center}Thank you for shopping with us!
{align:center}Goods exchangeable within 7 days.
{feed:2}''',
      );

  /// Prebuilt Template 3: Express Grocery & Supermarket
  static ReceiptTemplateV2Model get expressGrocery => ReceiptTemplateV2Model(
        id: 'preset_express_grocery',
        name: 'Supermarket & Grocery Express',
        description:
            'High-density layout tailored for grocery checkouts with unit pricing, items count, and loyalty info.',
        category: 'grocery',
        author: 'MistPOS Team',
        paperWidth: 42,
        tags: ['grocery', 'supermarket', 'quick', 'dense'],
        templateContent:
            '''{align:center}{logo}
{line:*}
Date: {date_formatted} {time_hour}:{time_minute}
Cashier: {cashier} | Terminal: {till}
Order: #{receipt_no}
{line:*}
{item_header}
{line:-}
{list}
{item_row}
{/list}
{line:-}
{align:right}Items Count: {number_of_items}
{align:right}Subtotal: {subtotal}
{align:right}Sales Tax: {tax_amount}
{align:right}{bold}TOTAL PAYABLE: {currency} {total}{/bold}
{align:right}Paid ({payment_method}): {amount_charged}
{align:right}Change: {change}
{line:*}
{align:center}{qrcode}
{align:center}Keep slip for warranty & returns.
{feed:2}''',
      );

  /// Prebuilt Template 4: Cafe, Bistro & Bakery
  static ReceiptTemplateV2Model get cafeBistro => ReceiptTemplateV2Model(
        id: 'preset_cafe_bistro',
        name: 'Cafe & Bistro Bakery',
        description:
            'Cozy format designed for restaurants and cafes with server name, table notes, and guest Wi-Fi details.',
        category: 'restaurant',
        author: 'MistPOS Artisan',
        paperWidth: 32,
        tags: ['cafe', 'bakery', 'bistro', 'restaurant'],
        templateContent:
            '''{align:center}Freshly Brewed & Baked Daily
{line:~}
Server: {cashier}
Order #{receipt_no} - {time_hour}:{time_minute}
{line:~}
{list}
{itemcount}x {itemname}
                  {itemtotal}
{/list}
{line:-}
Subtotal:          {subtotal}
VAT (Included):    {tax_amount}
{bold}TOTAL DUE:         {currency} {total}{/bold}
Paid ({payment_method}):      {amount_charged}
Change:            {change}
{line:~}
{align:center}Have a wonderful day!
{align:center}Wi-Fi: MistCoffee / Guest2026
{feed:2}''',
      );

  /// Prebuilt Template 5: Compact 58mm Minimalist
  static ReceiptTemplateV2Model get compactMinimal => ReceiptTemplateV2Model(
        id: 'preset_compact_minimal',
        name: 'Compact 58mm Minimalist',
        description:
            'Ultra tight, paper-saving design specifically formatted for 58mm mobile Bluetooth thermal printers.',
        category: 'minimal',
        author: 'MistPOS Lite',
        paperWidth: 32,
        tags: ['58mm', 'minimal', 'compact', 'bluetooth', 'paper-saver'],
        templateContent:
            '''{align:center}{date_formatted} {time}
{line:-}
{list}
{itemname}
{itemcount}x {itemprice} = {itemtotal}
{/list}
{line:-}
{align:right}{bold}TOTAL: {currency} {total}{/bold}
{align:right}Paid: {amount_charged} | Chg: {change}
{align:center}Thank you!
{feed:1}''',
      );

  /// List of all default preset templates
  static List<ReceiptTemplateV2Model> get allPresets => [
        zimraFiscal,
        modernRetail,
        expressGrocery,
        cafeBistro,
        compactMinimal,
      ];
}
