import 'dart:convert';

enum ReceiptBlockType {
  logo,
  text,
  customerInfo,
  fiscalHeader,
  list,
  totals,
  line,
  barcode,
  qrcode,
  zimraQr,
  spacer,
}

class ReceiptBlockV2 {
  String id;
  ReceiptBlockType type;
  String content;
  String align; // 'left', 'center', 'right'
  bool isBold;
  String char; // '-', '=', '*', '.', '~'
  String length; // 'full', 'half', or numeric string
  int lines; // for spacer: 1, 2, 3
  bool enabled;
  String? listFormat;

  ReceiptBlockV2({
    required this.id,
    required this.type,
    this.content = '',
    this.align = 'left',
    this.isBold = false,
    this.char = '-',
    this.length = 'full',
    this.lines = 1,
    this.enabled = true,
    this.listFormat,
  });

  factory ReceiptBlockV2.fromJson(Map<String, dynamic> json) {
    ReceiptBlockType parseType(String? t) {
      switch (t) {
        case 'customer_info':
        case 'customerInfo':
          return ReceiptBlockType.customerInfo;
        case 'fiscal_header':
        case 'fiscalHeader':
          return ReceiptBlockType.fiscalHeader;
        case 'list':
          return ReceiptBlockType.list;
        case 'totals':
          return ReceiptBlockType.totals;
        case 'line':
          return ReceiptBlockType.line;
        case 'barcode':
          return ReceiptBlockType.barcode;
        case 'qrcode':
          return ReceiptBlockType.qrcode;
        case 'zimra_qr':
        case 'zimraQr':
          return ReceiptBlockType.zimraQr;
        case 'spacer':
          return ReceiptBlockType.spacer;
        case 'logo':
          return ReceiptBlockType.logo;
        case 'text':
        default:
          return ReceiptBlockType.text;
      }
    }

    return ReceiptBlockV2(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: parseType(json['type']),
      content: json['content'] ?? json['text'] ?? '',
      align: json['align'] ?? 'left',
      isBold: json['isBold'] ?? false,
      char: json['char'] ?? '-',
      length: json['length']?.toString() ?? 'full',
      lines: json['lines'] ?? 1,
      enabled: json['enabled'] ?? true,
      listFormat: json['listFormat'] ?? json['format'],
    );
  }

  Map<String, dynamic> toJson() {
    String typeStr;
    switch (type) {
      case ReceiptBlockType.customerInfo:
        typeStr = 'customer_info';
        break;
      case ReceiptBlockType.fiscalHeader:
        typeStr = 'fiscal_header';
        break;
      case ReceiptBlockType.list:
        typeStr = 'list';
        break;
      case ReceiptBlockType.totals:
        typeStr = 'totals';
        break;
      case ReceiptBlockType.line:
        typeStr = 'line';
        break;
      case ReceiptBlockType.barcode:
        typeStr = 'barcode';
        break;
      case ReceiptBlockType.qrcode:
        typeStr = 'qrcode';
        break;
      case ReceiptBlockType.zimraQr:
        typeStr = 'zimra_qr';
        break;
      case ReceiptBlockType.spacer:
        typeStr = 'spacer';
        break;
      case ReceiptBlockType.logo:
        typeStr = 'logo';
        break;
      case ReceiptBlockType.text:
        typeStr = 'text';
        break;
    }

    return {
      'id': id,
      'type': typeStr,
      'content': content,
      'align': align,
      'isBold': isBold,
      'char': char,
      'length': length,
      'lines': lines,
      'enabled': enabled,
      if (listFormat != null) 'listFormat': listFormat,
    };
  }

  String toMarkup() {
    if (!enabled) return '';
    switch (type) {
      case ReceiptBlockType.logo:
        return '{align:$align}{logo}\n';

      case ReceiptBlockType.line:
        if (char != '-' && length == 'full') {
          return '{line:$char}\n';
        } else if (length == 'half') {
          return '{line:half}\n';
        }
        return '{line:$char}\n';

      case ReceiptBlockType.spacer:
        return '{feed:$lines}\n';

      case ReceiptBlockType.barcode:
        final code = content.trim().isNotEmpty ? content.trim() : '{receipt_no}';
        return '{align:$align}{barcode:$code}\n';

      case ReceiptBlockType.qrcode:
        final qrData = content.trim().isNotEmpty ? content.trim() : '{zimra_url}';
        return '{align:$align}{qrcode:$qrData}\n';

      case ReceiptBlockType.zimraQr:
        return '{align:center}{zimra_qr}\n{align:center}Verification code: {zimra_verification_code}\n{align:center}{zimra_manual_url}\n';

      case ReceiptBlockType.customerInfo:
        if (content.trim().isNotEmpty) {
          final cLines = content.trim().split('\n');
          final buf = StringBuffer();
          for (final l in cLines) {
            buf.writeln('{align:$align}$l');
          }
          return buf.toString();
        }
        return '{align:$align}Customer: {customer}\n'
            '{align:$align}Phone: {customer_phone}\n'
            '{align:$align}Email: {customer_email}\n';

      case ReceiptBlockType.fiscalHeader:
        return '{align:center}{bold}FISCAL RECEIPT{/bold}\n'
            '{align:center}Counter: {zimra_counter}\n'
            '{align:center}Device ID: {zimra_device_id}\n';

      case ReceiptBlockType.list:
        final fmt = listFormat ?? '{item_row}';
        return '{list}\n$fmt\n{/list}\n';

      case ReceiptBlockType.totals:
        return '{line:-}\n'
            '{align:right}Subtotal: {subtotal}\n'
            '{align:right}VAT (Standard) {vat_rate}%: {tax_amount}\n'
            '{line:-}\n'
            '{align:right}{bold}TOTAL: {currency} {total}{/bold}\n'
            '{line:-}\n'
            '{align:left}Payment Method: {payment_method}\n'
            '{align:right}Change: {change}\n';

      case ReceiptBlockType.text:
        final lines = content.split('\n');
        final buf = StringBuffer();
        for (final l in lines) {
          var res = l;
          if (isBold) {
            res = '{bold}$res{/bold}';
          }
          if (align != 'left') {
            res = '{align:$align}$res';
          }
          buf.writeln(res);
        }
        return buf.toString();
    }
  }

  ReceiptBlockV2 copyWith({
    String? id,
    ReceiptBlockType? type,
    String? content,
    String? align,
    bool? isBold,
    String? char,
    String? length,
    int? lines,
    bool? enabled,
    String? listFormat,
  }) {
    return ReceiptBlockV2(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      align: align ?? this.align,
      isBold: isBold ?? this.isBold,
      char: char ?? this.char,
      length: length ?? this.length,
      lines: lines ?? this.lines,
      enabled: enabled ?? this.enabled,
      listFormat: listFormat ?? this.listFormat,
    );
  }
}

class ReceiptTemplateV2Model {
  String id;
  String name;
  String description;
  String category; // 'fiscal', 'retail', 'grocery', 'restaurant', 'minimal', 'custom'
  String author;
  bool isCloud;
  int paperWidth; // 32 (58mm) or 42 (80mm) or 48
  String templateContent;
  List<ReceiptBlockV2> blocks;
  List<String> customWeekNames;
  List<String> customMonthNames;
  List<String> tags;
  int downloads;
  int likes;
  String? previewSample;

  ReceiptTemplateV2Model({
    required this.id,
    required this.name,
    this.description = '',
    this.category = 'custom',
    this.author = 'MistPOS User',
    this.isCloud = false,
    this.paperWidth = 42,
    required this.templateContent,
    this.blocks = const [],
    List<String>? customWeekNames,
    List<String>? customMonthNames,
    this.tags = const [],
    this.downloads = 0,
    this.likes = 0,
    this.previewSample,
  })  : customWeekNames = customWeekNames ??
            ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
        customMonthNames = customMonthNames ??
            [
              'January',
              'February',
              'March',
              'April',
              'May',
              'June',
              'July',
              'August',
              'September',
              'October',
              'November',
              'December'
            ];

  static bool isCompanyLine(String line) {
    final lower = line.toLowerCase();
    return lower.contains('{company_name}') ||
        lower.contains('{company_address}') ||
        lower.contains('{company_phone}') ||
        lower.contains('{company_email}') ||
        lower.contains('{company_tin}') ||
        lower.contains('{company_vat}') ||
        lower.contains('1904 midlands') ||
        lower.contains('waterfalls, harare') ||
        lower.contains('+263772336358') ||
        lower.contains('2001231110') ||
        lower.contains('220411676');
  }

  static String stripCompanyDetails(String markup) {
    if (markup.isEmpty) return markup;
    final lines = markup.split(RegExp(r'\r?\n'));
    final filtered = lines.where((l) => !isCompanyLine(l)).toList();
    return filtered.join('\n').replaceAll(RegExp(r'\n{3,}'), '\n\n').trimLeft();
  }

  factory ReceiptTemplateV2Model.fromJson(Map<String, dynamic> json) {
    final rawBlocks = (json['blocks'] as List<dynamic>?) ?? [];
    final cleanedBlocks = <ReceiptBlockV2>[];
    for (final item in rawBlocks) {
      if (item is Map) {
        final map = Map<String, dynamic>.from(item);
        final rawType = map['type']?.toString() ?? '';
        if (rawType == 'company_info' || rawType == 'companyInfo') {
          continue;
        }
        final b = ReceiptBlockV2.fromJson(map);
        if (b.type == ReceiptBlockType.text && b.content.isNotEmpty) {
          final cleanedContent = stripCompanyDetails(b.content).trim();
          if (cleanedContent.isEmpty) continue;
          b.content = cleanedContent;
        }
        cleanedBlocks.add(b);
      }
    }

    return ReceiptTemplateV2Model(
      id: json['id'] ?? json['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? 'Untitled Template',
      description: json['description'] ?? '',
      category: json['category'] ?? 'custom',
      author: json['author'] ?? 'MistPOS User',
      isCloud: json['isCloud'] ?? false,
      paperWidth: json['paperWidth'] ?? 42,
      templateContent: stripCompanyDetails(json['templateContent'] ?? ''),
      blocks: cleanedBlocks,
      customWeekNames: (json['customWeekNames'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      customMonthNames: (json['customMonthNames'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      downloads: json['downloads'] ?? 0,
      likes: json['likes'] ?? 0,
      previewSample: json['previewSample'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'author': author,
      'isCloud': isCloud,
      'paperWidth': paperWidth,
      'templateContent': templateContent,
      'blocks': blocks.map((e) => e.toJson()).toList(),
      'customWeekNames': customWeekNames,
      'customMonthNames': customMonthNames,
      'tags': tags,
      'downloads': downloads,
      'likes': likes,
      if (previewSample != null) 'previewSample': previewSample,
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory ReceiptTemplateV2Model.fromJsonString(String source) =>
      ReceiptTemplateV2Model.fromJson(jsonDecode(source));

  /// Regenerates [templateContent] from the current list of [blocks]
  void syncMarkupFromBlocks() {
    final buffer = StringBuffer();
    for (final b in blocks) {
      if (b.enabled) {
        buffer.write(b.toMarkup());
      }
    }
    templateContent = buffer.toString();
  }

  /// Synchronizes [blocks] from raw [markup] string (bidirectional sync with Code Editor)
  void syncBlocksFromMarkup(String markup) {
    blocks = parseBlocksFromMarkup(markup);
    templateContent = markup;
  }

  /// Parser that converts raw receipt markup into structured [ReceiptBlockV2] objects
  static List<ReceiptBlockV2> parseBlocksFromMarkup(String markup) {
    final List<ReceiptBlockV2> result = [];
    if (markup.trim().isEmpty) return result;

    final lines = markup.split(RegExp(r'\r?\n'));
    int i = 0;
    int blockCounter = 1;

    String nextId(String prefix) => '${prefix}_${blockCounter++}';

    while (i < lines.length) {
      final rawLine = lines[i];
      final trimmed = rawLine.trim();

      if (trimmed.isEmpty) {
        i++;
        continue;
      }

      // 1. {list} ... {/list}
      if (trimmed.startsWith('{list}')) {
        final listBuffer = StringBuffer();
        String rest = trimmed.substring('{list}'.length);
        if (rest.contains('{/list}')) {
          listBuffer.write(rest.substring(0, rest.indexOf('{/list}')).trim());
          i++;
        } else {
          if (rest.trim().isNotEmpty) listBuffer.writeln(rest.trim());
          i++;
          while (i < lines.length && !lines[i].contains('{/list}')) {
            listBuffer.writeln(lines[i]);
            i++;
          }
          if (i < lines.length) {
            final endLine = lines[i];
            final beforeEnd = endLine.substring(0, endLine.indexOf('{/list}')).trim();
            if (beforeEnd.isNotEmpty) listBuffer.writeln(beforeEnd);
            i++;
          }
        }
        result.add(ReceiptBlockV2(
          id: nextId('b_list'),
          type: ReceiptBlockType.list,
          listFormat: listBuffer.toString().trim(),
        ));
        continue;
      }

      // 2. {line:...} or {line}
      final lineMatch = RegExp(r'^\{line(?::([^}]+))?\}$', caseSensitive: false).firstMatch(trimmed);
      if (lineMatch != null) {
        final param = lineMatch.group(1)?.trim() ?? '-';
        final isHalf = param.toLowerCase() == 'half';
        result.add(ReceiptBlockV2(
          id: nextId('b_line'),
          type: ReceiptBlockType.line,
          char: isHalf ? '-' : (param.isNotEmpty ? param[0] : '-'),
          length: isHalf ? 'half' : 'full',
        ));
        i++;
        continue;
      }

      // 3. {feed:...}
      final feedMatch = RegExp(r'^\{feed(?::(\d+))?\}$', caseSensitive: false).firstMatch(trimmed);
      if (feedMatch != null) {
        final feedLines = int.tryParse(feedMatch.group(1) ?? '1') ?? 1;
        result.add(ReceiptBlockV2(
          id: nextId('b_spacer'),
          type: ReceiptBlockType.spacer,
          lines: feedLines,
        ));
        i++;
        continue;
      }

      // 3.5 {logo}
      if (trimmed.contains('{logo}')) {
        String align = 'center';
        final alignM = RegExp(r'\{align:(left|center|right)\}', caseSensitive: false).firstMatch(trimmed);
        if (alignM != null) {
          align = alignM.group(1)!;
        }
        result.add(ReceiptBlockV2(
          id: nextId('b_logo'),
          type: ReceiptBlockType.logo,
          align: align,
        ));
        i++;
        continue;
      }

      // 4. {barcode:...}
      final barcodeMatch = RegExp(r'^(?:\{align:(left|center|right)\})?\{barcode(?::([^}]+))?\}$', caseSensitive: false).firstMatch(trimmed);
      if (barcodeMatch != null) {
        final align = barcodeMatch.group(1) ?? 'left';
        final code = barcodeMatch.group(2)?.trim() ?? '{receipt_no}';
        result.add(ReceiptBlockV2(
          id: nextId('b_bar'),
          type: ReceiptBlockType.barcode,
          content: code,
          align: align,
        ));
        i++;
        continue;
      }

      // 5. {qrcode:...}
      final qrcodeMatch = RegExp(r'^(?:\{align:(left|center|right)\})?\{qrcode(?::([^}]+))?\}$', caseSensitive: false).firstMatch(trimmed);
      if (qrcodeMatch != null) {
        final align = qrcodeMatch.group(1) ?? 'left';
        final code = qrcodeMatch.group(2)?.trim() ?? '{zimra_url}';
        result.add(ReceiptBlockV2(
          id: nextId('b_qr'),
          type: ReceiptBlockType.qrcode,
          content: code,
          align: align,
        ));
        i++;
        continue;
      }

      // 6. {zimra_qr}
      if (trimmed.contains('{zimra_qr}')) {
        result.add(ReceiptBlockV2(
          id: nextId('b_zimra'),
          type: ReceiptBlockType.zimraQr,
          align: 'center',
        ));
        i++;
        while (i < lines.length) {
          final nextTrim = lines[i].trim();
          if (nextTrim.contains('{zimra_verification_code}') ||
              nextTrim.contains('{zimra_manual_url}') ||
              nextTrim.toLowerCase().contains('verify this receipt') ||
              nextTrim.toLowerCase().contains('verification code') ||
              nextTrim.isEmpty) {
            i++;
          } else {
            break;
          }
        }
        continue;
      }

      // 7. Skip any legacy Company Info lines
      if (isCompanyLine(trimmed)) {
        i++;
        continue;
      }

      // 8. Fiscal Header
      if (trimmed.toUpperCase().contains('FISCAL RECEIPT') ||
          trimmed.contains('{zimra_counter}') ||
          trimmed.contains('{zimra_device_id}')) {
        i++;
        while (i < lines.length) {
          final nextTrim = lines[i].trim();
          if (nextTrim.contains('{zimra_counter}') ||
              nextTrim.contains('{zimra_device_id}')) {
            i++;
          } else {
            break;
          }
        }
        result.add(ReceiptBlockV2(
          id: nextId('b_fisc'),
          type: ReceiptBlockType.fiscalHeader,
          align: 'center',
          isBold: true,
        ));
        continue;
      }

      // 9. Customer Info
      if (trimmed.contains('{customer}') ||
          trimmed.contains('{customer_phone}') ||
          trimmed.contains('{customer_email}') ||
          trimmed.contains('{customer_tin}') ||
          trimmed.contains('{customer_vat}')) {
        final custLines = <String>[];
        String align = 'left';
        while (i < lines.length) {
          final l = lines[i].trim();
          if (l.contains('{customer}') ||
              l.contains('{customer_phone}') ||
              l.contains('{customer_email}') ||
              l.contains('{customer_tin}') ||
              l.contains('{customer_vat}')) {
            final alignM = RegExp(r'^\{align:(left|center|right)\}', caseSensitive: false).firstMatch(l);
            if (alignM != null) {
              align = alignM.group(1)!;
            }
            final clean = l.replaceAll(RegExp(r'\{align:(?:left|center|right)\}', caseSensitive: false), '').trim();
            custLines.add(clean);
            i++;
          } else {
            break;
          }
        }
        result.add(ReceiptBlockV2(
          id: nextId('b_cust'),
          type: ReceiptBlockType.customerInfo,
          content: custLines.join('\n'),
          align: align,
        ));
        continue;
      }

      // 10. General text lines (grouping consecutive text lines with same align & isBold)
      String parseAlign(String str) {
        final m = RegExp(r'^\{align:(left|center|right)\}', caseSensitive: false).firstMatch(str);
        return m != null ? m.group(1)! : 'left';
      }

      bool parseBold(String str) {
        final s = str.replaceAll(RegExp(r'\{align:(?:left|center|right)\}', caseSensitive: false), '').trim();
        return s.startsWith('{bold}') && s.endsWith('{/bold}');
      }

      String cleanText(String str) {
        var s = str.replaceAll(RegExp(r'\{align:(?:left|center|right)\}', caseSensitive: false), '').trim();
        if (s.startsWith('{bold}') && s.endsWith('{/bold}')) {
          s = s.substring('{bold}'.length, s.length - '{/bold}'.length).trim();
        }
        return s;
      }

      final align = parseAlign(trimmed);
      final isBold = parseBold(trimmed);
      final textLines = <String>[cleanText(trimmed)];
      i++;

      while (i < lines.length) {
        final nextTrim = lines[i].trim();
        if (nextTrim.isEmpty) {
          i++;
          break; // Empty line separates text paragraphs
        }
        if (nextTrim.startsWith('{list}') ||
            nextTrim.startsWith('{line') ||
            nextTrim.startsWith('{feed') ||
            nextTrim.startsWith('{barcode') ||
            nextTrim.startsWith('{qrcode') ||
            nextTrim.contains('{zimra_qr}') ||
            nextTrim.contains('{logo}') ||
            isCompanyLine(nextTrim) ||
            nextTrim.toUpperCase().contains('FISCAL RECEIPT') ||
            nextTrim.contains('{customer}')) {
          break;
        }

        final nextAlign = parseAlign(nextTrim);
        final nextBold = parseBold(nextTrim);
        if (nextAlign == align && nextBold == isBold) {
          textLines.add(cleanText(nextTrim));
          i++;
        } else {
          break;
        }
      }

      result.add(ReceiptBlockV2(
        id: nextId('b_text'),
        type: ReceiptBlockType.text,
        content: textLines.join('\n'),
        align: align,
        isBold: isBold,
      ));
    }

    return result;
  }

  ReceiptTemplateV2Model copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? author,
    bool? isCloud,
    int? paperWidth,
    String? templateContent,
    List<ReceiptBlockV2>? blocks,
    List<String>? customWeekNames,
    List<String>? customMonthNames,
    List<String>? tags,
    int? downloads,
    int? likes,
    String? previewSample,
  }) {
    return ReceiptTemplateV2Model(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      author: author ?? this.author,
      isCloud: isCloud ?? this.isCloud,
      paperWidth: paperWidth ?? this.paperWidth,
      templateContent: templateContent ?? this.templateContent,
      blocks: blocks ?? this.blocks.map((b) => b.copyWith()).toList(),
      customWeekNames: customWeekNames ?? List.from(this.customWeekNames),
      customMonthNames: customMonthNames ?? List.from(this.customMonthNames),
      tags: tags ?? List.from(this.tags),
      downloads: downloads ?? this.downloads,
      likes: likes ?? this.likes,
      previewSample: previewSample ?? this.previewSample,
    );
  }
}
