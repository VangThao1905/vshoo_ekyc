import 'package:flutter/material.dart';
import '../../application/cubit/ekyc_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/ekyc_theme.dart';

class InstructionScreen extends StatelessWidget {
  const InstructionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EkycTheme.background,
      appBar: AppBar(
        title: const Text('Xac thuc eKYC'),
        backgroundColor: EkycTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Huong dan xac thuc',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildStep(1, 'Chup mat truoc CCCD', Icons.credit_card),
            _buildStep(2, 'Quet ma QR tren CCCD', Icons.qr_code),
            _buildStep(3, 'Chup mat sau CCCD', Icons.credit_card_outlined),
            _buildStep(4, 'Chup anh khuon mat', Icons.face),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: EkycTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.read<EkycCubit>().startFlow(),
                child: const Text('Bat dau'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int num, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: EkycTheme.primary,
            radius: 18,
            child: Text('$num', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Icon(icon, color: EkycTheme.primary),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
