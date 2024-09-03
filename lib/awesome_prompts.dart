import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@visibleForTesting
enum Severity { info, error, warning, good }

@visibleForTesting
class PromptModel {
  final int id;
  final String title;
  final String message;
  final Severity severity;

  PromptModel({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
  });
}

@visibleForTesting
class PromptStateNotifier extends Notifier<List<PromptModel>> {
  @override
  List<PromptModel> build() {
    return [];
  }

  void addPrompt({
    required String title,
    required String message,
    required Severity severity,
  }) {
    state.add(
      PromptModel(
        id: state.length,
        title: title,
        message: message,
        severity: severity,
      ),
    );
  }

  void removePrompt({required int id}) {
    if (state.isEmpty) {
      return;
    }
    state.removeAt(state.indexWhere((prompt) => prompt.id == id));
  }
}

@visibleForTesting
final promptNotifierProvider =
    NotifierProvider<PromptStateNotifier, List<PromptModel>>(
  PromptStateNotifier.new,
);

void showError(
    {required String title, required String message, required WidgetRef ref}) {
  ref.read(promptNotifierProvider.notifier).addPrompt(
        title: title,
        message: message,
        severity: Severity.error,
      );
}

///Wrap your whole app with this so the prompts can show anywhere on your screen
class AwesomePrompt extends ConsumerStatefulWidget {
  final Widget child;
  const AwesomePrompt({super.key, required this.child});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AwesomePromptState();
}

class _AwesomePromptState extends ConsumerState<AwesomePrompt> {
  @override
  Widget build(BuildContext context) {
    List<PromptModel> prompts = ref.watch(promptNotifierProvider);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: List.generate(prompts.length, (index) {
                      return PromptCard(
                        title: prompts[index].title,
                        message: prompts[index].message,
                        severity: prompts[index].severity,
                        onClose: () {
                          ref
                              .read(promptNotifierProvider.notifier)
                              .removePrompt(
                                id: prompts[index].id,
                              );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

@visibleForTesting
class PromptCard extends StatelessWidget {
  final Severity severity;
  final String title;
  final String message;
  final VoidCallback? onTap;
  final VoidCallback? onClose;

  const PromptCard({
    super.key,
    this.title = "Information",
    this.message =
        "Please check your device and make sure all the needed services are turned on.",
    this.onTap,
    this.onClose,
    this.severity = Severity.info,
  });

  final Color textColor = const Color(0xFF282828);

  Color bgColor({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Color(0xFF0FDFAF);
      case Severity.info:
        return const Color(0xFFEFF6FF);
      case Severity.warning:
        return const Color(0xFFFFF7ED);
      case Severity.error:
        return const Color(0xFFFFEBEB);
      default:
        return const Color(0xFF0FDFAF);
    }
  }

  Color borderColor({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Color(0xFF14B8A6);
      case Severity.info:
        return const Color(0xFF3B82F6);
      case Severity.warning:
        return const Color(0xFFF97316);
      case Severity.error:
        return const Color(0xFFFF3F3C);
      default:
        return const Color(0xFF5EEAD4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: bgColor(severity: severity),
            border: Border.all(
              width: 1,
              color: borderColor(severity: severity),
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconContainer(
                    icon: const Icon(Icons.info),
                    severity: severity,
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        child: Text(
                          message,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 11.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  if (onClose != null) {
                    onClose!();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class IconContainer extends StatelessWidget {
  final Icon icon;
  final Severity severity;
  const IconContainer({
    super.key,
    required this.icon,
    this.severity = Severity.good,
  });

  Color outerRingColor({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Color(0xFFCCFBF1);
      case Severity.info:
        return const Color(0xFFDBEAFE);
      case Severity.warning:
        return const Color(0xFFFFEDD5);
      case Severity.error:
        return const Color(0xFFFFD1D1);
      default:
        return const Color(0xFFCCFBF1);
    }
  }

  Color innerRingColor({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return const Color(0xFF5EEAD4);
      case Severity.info:
        return const Color(0xFF93C5FD);
      case Severity.warning:
        return const Color(0xFFFDBA74);
      case Severity.error:
        return const Color(0x4DFF3F3C);
      default:
        return const Color(0xFF5EEAD4);
    }
  }

  Color iconColor({required Severity severity}) {
    switch (severity) {
      case Severity.good:
        return Colors.teal.shade500;
      case Severity.info:
        return const Color(0xFF3B82F6);
      case Severity.warning:
        return const Color(0xFFF97316);
      case Severity.error:
        return const Color(0xFFFF3F3C);
      default:
        return Colors.teal.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: outerRingColor(severity: severity),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: innerRingColor(severity: severity),
        ),
        child: Icon(
          icon.icon,
          color: iconColor(severity: severity),
          size: 20.0,
        ),
      ),
    );
  }
}
