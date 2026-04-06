import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/cubit/ekyc_cubit.dart';
import '../../application/cubit/ekyc_state.dart';
import '../theme/ekyc_theme.dart';
import '../widgets/camera_overlay.dart';
import '../widgets/capture_button.dart';

/// Generic card capture screen — reused for both front and back of ID card.
class CardCaptureScreen extends StatefulWidget {
  final String instruction;
  final Future<void> Function(Uint8List bytes) onCapture;

  const CardCaptureScreen({
    super.key,
    required this.instruction,
    required this.onCapture,
  });

  @override
  State<CardCaptureScreen> createState() => _CardCaptureScreenState();
}

class _CardCaptureScreenState extends State<CardCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCapturing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _errorMessage = 'Không tìm thấy camera trên thiết bị');
        return;
      }

      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();
      if (!mounted) return;

      setState(() {
        _controller = controller;
        _errorMessage = null;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      final msg = e.description?.contains('cameraPermission') == true
          ? 'Ứng dụng cần quyền truy cập camera. Vui lòng cấp quyền trong Cài đặt.'
          : 'Lỗi camera: ${e.description}';
      setState(() => _errorMessage = msg);
    } catch (_) {
      if (mounted) setState(() => _errorMessage = 'Lỗi khởi động camera');
    }
  }

  Future<void> _onCapture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) return;

    setState(() => _isCapturing = true);
    try {
      final file = await controller.takePicture();
      final bytes = await file.readAsBytes();
      if (mounted) await widget.onCapture(bytes);
    } on CameraException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi chụp ảnh: ${e.description}'),
            backgroundColor: EkycTheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkycCubit, EkycState>(
      builder: (context, state) {
        final isLoading = state is EkycLoading;
        return Stack(
          fit: StackFit.expand,
          children: [
            _buildBody(),
            if (isLoading) _buildLoadingOverlay(state),
          ],
        );
      },
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: EkycTheme.error, size: 56),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15)),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _initCamera,
                icon: const Icon(Icons.refresh),
                label: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: CameraOverlay(
            instruction: widget.instruction,
            child: CameraPreview(controller),
          ),
        ),
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Center(
            child: CaptureButton(
              onPressed: _onCapture,
              isLoading: _isCapturing,
            ),
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
