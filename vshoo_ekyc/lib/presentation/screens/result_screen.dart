import 'package:flutter/material.dart';
import '../../domain/entities/ekyc_session.dart';
import '../theme/ekyc_theme.dart';
import '../widgets/result_info_tile.dart';

class ResultScreen extends StatelessWidget {
  final EkycSession session;

  const ResultScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final isVerified = session.isVerified;
    final front = session.frontCard;
    final back = session.backCard;

    return SafeArea(
      child: Scaffold(
        backgroundColor: EkycTheme.background,
        appBar: AppBar(
          title: const Text('Kết quả xác thực'),
          backgroundColor: EkycTheme.primary,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // ── Verification badge ──────────────────────────────
              Icon(
                isVerified ? Icons.verified_user : Icons.cancel,
                size: 64,
                color: isVerified ? EkycTheme.success : EkycTheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                isVerified ? 'Xác thực thành công' : 'Xác thực thất bại',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isVerified ? EkycTheme.success : EkycTheme.error,
                ),
              ),
              const SizedBox(height: 24),
      
              // ── Front card info ─────────────────────────────────
              _SectionCard(
                title: 'Thông tin CCCD (Mặt trước)',
                tiles: [
                  ResultInfoTile(label: 'Họ tên', value: front?.fullName, icon: Icons.person),
                  ResultInfoTile(label: 'Số CCCD', value: front?.cardNumber?.toString(), icon: Icons.credit_card),
                  ResultInfoTile(label: 'Ngày sinh', value: front?.dateOfBirth, icon: Icons.cake),
                  ResultInfoTile(label: 'Giới tính', value: front?.sex, icon: Icons.wc),
                  ResultInfoTile(label: 'Quốc tịch', value: front?.nationality, icon: Icons.flag),
                  ResultInfoTile(label: 'Quê quán', value: front?.homeTown, icon: Icons.home),
                  ResultInfoTile(
                    label: 'Địa chỉ',
                    value: front?.addressEntities?.full ?? front?.address,
                    icon: Icons.location_on,
                  ),
                  ResultInfoTile(label: 'Ngày hết hạn', value: front?.dateOfExpiry, icon: Icons.event),
                ],
              ),
              const SizedBox(height: 16),
      
              // ── Back card info ──────────────────────────────────
              _SectionCard(
                title: 'Thông tin CCCD (Mặt sau)',
                tiles: [
                  ResultInfoTile(label: 'Dân tộc', value: back?.ethnicity, icon: Icons.diversity_3),
                  ResultInfoTile(label: 'Tôn giáo', value: back?.religion, icon: Icons.church),
                  ResultInfoTile(label: 'Đặc điểm nhận dạng', value: back?.personalFeatures, icon: Icons.fingerprint),
                  ResultInfoTile(label: 'Ngày cấp', value: back?.issueDate, icon: Icons.calendar_today),
                  ResultInfoTile(label: 'Nơi cấp', value: back?.issueLocation, icon: Icons.business),
                ],
              ),
              const SizedBox(height: 16),
      
              // ── Liveness & Face match ───────────────────────────
              _SectionCard(
                title: 'Kết quả Liveness & Face Match',
                tiles: [
                  ResultInfoTile(
                    label: 'Liveness',
                    value: session.livenessResult?.isLive == true ? 'Đạt' : 'Không đạt',
                    icon: Icons.face,
                  ),
                  ResultInfoTile(
                    label: 'Độ tương đồng khuôn mặt',
                    value: session.faceMatchResult?.score.asPercent,
                    icon: Icons.compare,
                  ),
                  ResultInfoTile(
                    label: 'Mức độ tin cậy',
                    value: session.faceMatchResult?.confidence,
                    icon: Icons.shield,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> tiles;

  const _SectionCard({required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          ...tiles,
        ],
      ),
    );
  }
}
