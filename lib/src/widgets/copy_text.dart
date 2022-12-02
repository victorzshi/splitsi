import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Highlight copyable text. Copy to clipboard on click.
class CopyText extends StatelessWidget {
  const CopyText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Click to copy!',
      child: TextButton(
        onPressed: () async {
          Clipboard.setData(ClipboardData(text: text));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Copied!'),
            ),
          );
        },
        child: Text(text),
      ),
    );
  }
}
