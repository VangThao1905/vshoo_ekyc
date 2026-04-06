import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/cubit/ekyc_cubit.dart';
import '../../application/cubit/ekyc_state.dart';
import '../widgets/step_progress_bar.dart';
import 'card_capture_screen.dart';
import 'capture_qr_screen.dart';
import 'instruction_screen.dart';
import 'result_screen.dart';

class EkycFlowScreen extends StatelessWidget {
  const EkycFlowScreen({super.key});

  Widget _buildStepBody(BuildContext context, EkycState state) {
    final cubit = context.read<EkycCubit>();
    return switch (state.step) {
      EkycStep.captureFront => CardCaptureScreen(
          instruction: 'Đặt mặt trước CCCD vào khung — giữ thẳng và rõ nét',
          onCapture: cubit.onFrontCardCaptured,
        ),
      EkycStep.captureQr => const CaptureQrScreen(),
      EkycStep.captureBack => CardCaptureScreen(
          instruction: 'Đặt mặt sau CCCD vào khung — giữ thẳng và rõ nét',
          onCapture: cubit.onBackCardCaptured,
        ),
      _ => const Center(child: Text('Coming soon...')),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EkycCubit, EkycState>(
      listener: (context, state) {
        if (state is EkycStepFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.message),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Thử lại',
                textColor: Colors.white,
                onPressed: () => context.read<EkycCubit>().retry(),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.step == EkycStep.instruction) {
          return const InstructionScreen();
        }

        if (state is EkycCompleted) {
          return ResultScreen(session: state.session);
        }

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Xác thực eKYC'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: StepProgressBar(currentStep: state.step),
                ),
              ),
            ),
            body: _buildStepBody(context, state),
          ),
        );
      },
    );
  }
}
