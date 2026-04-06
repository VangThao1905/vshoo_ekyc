import 'package:flutter/material.dart';

class CameraOverlay extends StatelessWidget {
  final String instruction;
  final Widget? child;

  const CameraOverlay({
    super.key,
    required this.instruction,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (child != null) child!,
        Positioned(
          left: 24,
          right: 24,
          top: 60,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              instruction,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        // Card frame guide
        Center(
          child: Container(
            width: 280,
            height: 176,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
