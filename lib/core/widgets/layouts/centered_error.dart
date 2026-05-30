import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';

class CenteredError extends StatelessWidget {
  final int? errorCode;
  final String? errorMessage;
  const CenteredError({super.key, this.errorCode, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Iconify(_getErrorIcon(errorCode ?? -1), size: 54, color: Colors.grey),
          if (errorMessage != null) ...[
            SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  String _getErrorIcon(int i) {
    return switch (i) {
      404 => Bx.error_alt,
      500 => Bx.bug,
      _ => Bx.bx_error,
    };
  }
}
