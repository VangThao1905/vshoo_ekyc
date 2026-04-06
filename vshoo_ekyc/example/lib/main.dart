import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vshoo_ekyc/vshoo_ekyc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'vshoo_ekyc Example',
      theme: EkycTheme.theme,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _startEkyc(BuildContext context) {
    final config = EkycConfig(
      baseUrl: 'https://your-backend.com',
      apiKey: 'your-backend-api-key',
      sessionId: SessionId.generate().value,
      fptApiKey: EkycConstants.vshooEkycApiKey,
    );

    final datasource = EkycRemoteDatasource(config);
    final repository = EkycRepositoryImpl(datasource);

    final cubit = EkycCubit(
      uploadFront: UploadFrontCardUsecase(repository),
      scanQr: ScanQrUsecase(repository),
      uploadBack: UploadBackCardUsecase(repository),
      checkLiveness: CheckLivenessUsecase(repository),
      matchFace: MatchFaceUsecase(repository),
      imageProcessor: ImageProcessor(),
      sessionId: SessionId.generate(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const EkycFlowScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('vshoo_ekyc Demo'),
        backgroundColor: EkycTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_user,
                  size: 80, color: EkycTheme.primary),
              const SizedBox(height: 24),
              const Text(
                'eKYC Plugin Demo',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Xác thực danh tính điện tử\nqua CCCD và khuôn mặt',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: EkycTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Bắt đầu xác thực eKYC',
                      style: TextStyle(fontSize: 16)),
                  onPressed: () => _startEkyc(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
