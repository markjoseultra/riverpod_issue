import 'package:flutter/material.dart';
import 'package:flutter_custom_prompts/awesome_prompts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AwesomePrompt(
      child: MaterialApp(
        home: App(),
      ),
    );
  }
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    return AwesomePrompt(
      child: Scaffold(
          body: Center(
        child: ElevatedButton(
          onPressed: () {
            showError(title: "TEST", message: "TEST", ref: ref);
          },
          child: const Text("Show Prompt"),
        ),
      )),
    );
  }
}
