import 'package:flutter/material.dart';
import '../theme/ekyc_theme.dart';

class CaptureButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const CaptureButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          color: isLoading ? Colors.grey : EkycTheme.primary,
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Icon(Icons.camera_alt, color: Colors.white, size: 32),
      ),
    );
  }
}
