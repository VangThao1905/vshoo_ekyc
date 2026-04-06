import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../application/cubit/ekyc_cubit.dart';
import '../../application/cubit/ekyc_state.dart';
import '../widgets/step_progress_bar.dart';
import 'instruction_screen.dart';
import 'result_screen.dart';

class EkycFlowScreen extends StatelessWidget {
  const EkycFlowScreen({super.key});

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
                label: 'Thu lai',
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

        return Scaffold(
          appBar: AppBar(
            title: const Text('Xac thuc eKYC'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: StepProgressBar(currentStep: state.step),
              ),
            ),
          ),
          body: const Center(child: Text('Camera Screen — se implement voi camera plugin')),
        );
      },
    );
  }
}
