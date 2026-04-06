library vshoo_ekyc;

import 'vshoo_ekyc_platform_interface.dart';

// Domain
export 'domain/entities/address_entities.dart';
export 'domain/entities/card_info.dart';
export 'domain/entities/qr_info.dart';
export 'domain/entities/liveness_result.dart';
export 'domain/entities/face_match_result.dart';
export 'domain/entities/ekyc_session.dart';
export 'domain/value_objects/card_number.dart';
export 'domain/value_objects/similarity_score.dart';
export 'domain/value_objects/session_id.dart';
export 'domain/failures/ekyc_failure.dart';
export 'domain/repositories/ekyc_repository.dart';

// Application
export 'application/cubit/ekyc_cubit.dart';
export 'application/cubit/ekyc_state.dart';
export 'application/dtos/card_capture_dto.dart';
export 'application/dtos/face_capture_dto.dart';
export 'application/use_cases/upload_front_card_usecase.dart';
export 'application/use_cases/scan_qr_usecase.dart';
export 'application/use_cases/upload_back_card_usecase.dart';
export 'application/use_cases/check_liveness_usecase.dart';
export 'application/use_cases/match_face_usecase.dart';

// Infra
export 'infra/datasources/ekyc_config.dart';
export 'infra/datasources/ekyc_constants.dart';
export 'infra/datasources/ekyc_remote_datasource.dart';
export 'infra/repositories/ekyc_repository_impl.dart';
export 'infra/image/image_processor.dart';

// Presentation
export 'presentation/screens/ekyc_flow_screen.dart';
export 'presentation/theme/ekyc_theme.dart';

class VshooEkyc {
  Future<String?> getPlatformVersion() {
    return VshooEkycPlatform.instance.getPlatformVersion();
  }
}
