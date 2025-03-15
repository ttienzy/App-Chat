import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HoverCopyText extends StatefulWidget {
  final String text;

  const HoverCopyText({super.key, required this.text});

  @override
  State<HoverCopyText> createState() => _HoverCopyTextState();
}

class _HoverCopyTextState extends State<HoverCopyText> {
  bool _isHovering = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.text));
    Fluttertoast.showToast(
      msg: "Copy thành công!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 8, 161, 10),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: _copyToClipboard,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mã phòng: ${widget.text}',
              style: TextStyle(
                fontSize: 12,
                color:
                    _isHovering
                        ? const Color.fromARGB(255, 4, 4, 5)
                        : const Color.fromARGB(255, 126, 128, 126),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 5), // Khoảng cách giữa text và icon
            Icon(Icons.copy, size: 16, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
