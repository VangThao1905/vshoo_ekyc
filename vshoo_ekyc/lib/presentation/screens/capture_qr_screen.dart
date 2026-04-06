import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../application/cubit/ekyc_cubit.dart';
import '../../application/cubit/ekyc_state.dart';
import '../theme/ekyc_theme.dart';

class CaptureQrScreen extends StatefulWidget {
  const CaptureQrScreen({super.key});

  @override
  State<CaptureQrScreen> createState() => _CaptureQrScreenState();
}

class _CaptureQrScreenState extends State<CaptureQrScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _detected = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_detected) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.isEmpty) return;

    _detected = true;
    _controller.stop();
    context.read<EkycCubit>().onQrScanned(raw);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkycCubit, EkycState>(
      builder: (context, state) {
        final isLoading = state is EkycLoading;
        return Stack(
          fit: StackFit.expand,
          children: [
            _buildScanner(),
            _buildQrOverlay(),
            if (isLoading) _buildLoadingOverlay(state),
          ],
        );
      },
    );
  }

  Widget _buildScanner() {
    return MobileScanner(
      controller: _controller,
      onDetect: _onDetect,
    );
  }

  Widget _buildQrOverlay() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Dim areas outside the QR frame
        CustomPaint(painter: _QrDimPainter()),
        // Instruction text
        Positioned(
          left: 24,
          right: 24,
          top: 48,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Đưa mã QR trên CCCD vào khung vuông',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        // QR frame corners
        Center(
          child: SizedBox(
            width: 240,
            height: 240,
            child: CustomPaint(painter: _QrCornerPainter()),
          ),
        ),
        // Scan line animation
        Center(
          child: SizedBox(
            width: 240,
            height: 240,
            child: const _ScanLine(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay(EkycLoading state) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 16),
            Text(state.message, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// ── Painters ────────────────────────────────────────────────────────────────

class _QrDimPainter extends CustomPainter {
  static const double _size = 240;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black54;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final left = cx - _size / 2;
    final top = cy - _size / 2;
    final hole = Rect.fromLTWH(left, top, _size, _size);

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(hole, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QrCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = EkycTheme.primary
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const radius = 12.0;
    const arm = 28.0;
    final w = size.width;
    final h = size.height;

    // Top-left
    canvas.drawLine(Offset(radius, 0), Offset(arm, 0), paint);
    canvas.drawLine(Offset(0, radius), Offset(0, arm), paint);
    canvas.drawArc(const Rect.fromLTWH(0, 0, radius * 2, radius * 2), -3.14, 3.14 / 2, false, paint);
    // Top-right
    canvas.drawLine(Offset(w - arm, 0), Offset(w - radius, 0), paint);
    canvas.drawLine(Offset(w, radius), Offset(w, arm), paint);
    canvas.drawArc(Rect.fromLTWH(w - radius * 2, 0, radius * 2, radius * 2), -3.14 / 2, 3.14 / 2, false, paint);
    // Bottom-left
    canvas.drawLine(Offset(0, h - arm), Offset(0, h - radius), paint);
    canvas.drawLine(Offset(radius, h), Offset(arm, h), paint);
    canvas.drawArc(Rect.fromLTWH(0, h - radius * 2, radius * 2, radius * 2), 3.14 / 2, 3.14 / 2, false, paint);
    // Bottom-right
    canvas.drawLine(Offset(w, h - arm), Offset(w, h - radius), paint);
    canvas.drawLine(Offset(w - arm, h), Offset(w - radius, h), paint);
    canvas.drawArc(Rect.fromLTWH(w - radius * 2, h - radius * 2, radius * 2, radius * 2), 0, 3.14 / 2, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Animated scan line
class _ScanLine extends StatefulWidget {
  const _ScanLine();

  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine> with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _pos;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pos = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pos,
      builder: (_, __) => CustomPaint(
        painter: _ScanLinePainter(_pos.value),
      ),
    );
  }
}

class _ScanLinePainter extends CustomPainter {
  final double progress;
  _ScanLinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * progress;
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.transparent, EkycTheme.primary.withValues(alpha: 0.8), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, y - 1, size.width, 2))
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }

  @override
  bool shouldRepaint(_ScanLinePainter old) => old.progress != progress;
}
