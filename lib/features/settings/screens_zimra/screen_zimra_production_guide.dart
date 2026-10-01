import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Client-facing steps aligned with ZIMRA FDMS Gateway API v7.2 & MistPOS flows.
class ScreenZimraProductionGuide extends StatelessWidget {
  const ScreenZimraProductionGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Production fiscal device'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _SectionTitle('Before you start'),
          _Bullet(
            'Complete taxpayer registration on the ZIMRA production fiscal portal (not the test portal).',
          ),
          _Bullet(
            'You will receive a Device ID, 8-character activation key, and assign a device serial number.',
          ),
          _Bullet(
            'Production receipts are legally fiscal — use sandbox for training first.',
          ),
          SizedBox(height: 20),
          _SectionTitle('In MistPOS'),
          _Numbered(1, 'Subscribe to ZIMRA Fiscalization (in-app or dashboard).'),
          _Numbered(
            2,
            'ZIMRA Fiscalization → **Environment Mode** → switch to **Production (Live)**.',
          ),
          _Numbered(
            3,
            '**Device Registration** — enter production Device ID, serial, activation key. MistPOS registers with FDMS and stores your certificate.',
          ),
          _Numbered(
            4,
            'Run **Connection test** / diagnostic (support can verify).',
          ),
          _Numbered(5, '**Open Day** → make a small test sale → confirm fiscal QR → **Close Day**.'),
          _Numbered(
            6,
            'Refunds on fiscalized sales create **Credit notes** (visible under Sales → filter Credit note).',
          ),
          SizedBox(height: 20),
          _SectionTitle('Important'),
          _Bullet(
            'Test certificates only work on the sandbox API; production certificates only on the live API.',
          ),
          _Bullet(
            'Do not register the same portal device twice with different keys — request a new activation from ZIMRA if needed.',
          ),
          _Bullet(
            'Renew certificates before expiry (about one month ahead) via Device Registration / extend flow.',
          ),
          SizedBox(height: 20),
          _SectionTitle('Need help?'),
          _Bullet(
            'Contact MistPOS support with your company name, Device ID, and whether you are on Sandbox or Production.',
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 14, height: 1.4)),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 14, height: 1.45, color: Colors.grey.shade800)),
          ),
        ],
      ),
    );
  }
}

class _Numbered extends StatelessWidget {
  final int n;
  final String text;
  const _Numbered(this.n, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$n. ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(height: 1.45))),
        ],
      ),
    );
  }
}
