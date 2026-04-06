import 'package:flutter/material.dart';
import '../../application/cubit/ekyc_state.dart';
import '../theme/ekyc_theme.dart';

class StepProgressBar extends StatelessWidget {
  final EkycStep currentStep;

  const StepProgressBar({super.key, required this.currentStep});

  static const _steps = [
    EkycStep.captureFront,
    EkycStep.captureQr,
    EkycStep.captureBack,
    EkycStep.captureFace,
    EkycStep.result,
  ];

  static const _labels = ['Mặt trước', 'QR Code', 'Mặt sau', 'Khuôn mặt', 'Kết quả'];

  @override
  Widget build(BuildContext context) {
    final currentIndex = _steps.indexOf(currentStep);
    return Row(
      children: List.generate(_steps.length, (i) {
        final isCompleted = i < currentIndex;
        final isActive = i == currentIndex;
        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 4,
                color: isCompleted || isActive
                    ? EkycTheme.primary
                    : Colors.grey.shade300,
              ),
              const SizedBox(height: 4),
              Text(
                _labels[i],
                style: TextStyle(
                  fontSize: 10,
                  color: isActive ? EkycTheme.primary : Colors.grey,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
