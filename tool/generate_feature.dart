import 'dart:io';

/// Converts 'add_edit' → 'AddEdit'
String toPascalCase(String input) {
  return input
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join();
}

/// Converts 'add_edit' → 'addEdit'
String toCamelCase(String input) {
  final parts = input.split('_');
  return parts.first +
      parts.skip(1).map((p) => p[0].toUpperCase() + p.substring(1)).join();
}

void main(List<String> args) {
  if (args.isEmpty) {
    print(
      '❗ Please provide a feature name.\n👉 Example: dart tool/generate_feature.dart add_edit',
    );
    return;
  }

  final feature = args[0].toLowerCase();
  final className = toPascalCase(feature); // AddEdit
  final providerName = toCamelCase(
    '${feature}NotifierProvider',
  ); // addEditNotifierProvider
  final baseDir = Directory('lib/src/presentation/screen/$feature');
  final notifierDir = Directory('${baseDir.path}/notifier');
  final stateDir = Directory('${baseDir.path}/state');

  notifierDir.createSync(recursive: true);
  stateDir.createSync(recursive: true);

  // 1️⃣ chat_screen.dart
  File('${baseDir.path}/${feature}_screen.dart').writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/common_consumer.dart';

import 'notifier/${feature}_notifier.dart';
import 'state/${feature}_state.dart';

class ${className}Screen extends StatelessWidget {
  const ${className}Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoConsumerBuilder<${className}State, ${className}Notifier>(
      provider: $providerName,
      
      // Optional listener - run side-effects on state change
      listener: (previous, next, ref) {
        // Example: show a snackbar when something changes
        if (next.sampleValue != previous.sampleValue) {
          ScaffoldMessenger.of(ref.context).showSnackBar(
            SnackBar(content: Text('Value changed!')),
          );
        }
      },

      builder: (BuildContext context, ${className}State state, ${className}Notifier notifier, WidgetRef ref) {
        return Scaffold(
          appBar: AppBar(title: const Text('$className')),
          body: Center(
            child: Text('Welcome to $className Screen'),
          ),
        );
      },
    );
  }
}
''');

  // 2️⃣ chat_notifier.dart
  File('${notifierDir.path}/${feature}_notifier.dart').writeAsStringSync('''
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../state/${feature}_state.dart';

part '${feature}_notifier.g.dart';

@riverpod
class ${className}Notifier extends _\$${className}Notifier {
  @override
  ${className}State build() {
    return ${className}State();
  }
}
''');

  // 3️⃣ chat_state.dart
  File('${stateDir.path}/${feature}_state.dart').writeAsStringSync('''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${feature}_state.freezed.dart';

@freezed
class ${className}State with _\$${className}State {
  factory ${className}State({
    @Default('') String sampleValue,
  }) = _${className}State;
}
''');

  print('\n✅ Successfully generated files for feature: "$feature"\n');
  print('📁 lib/src/presentation/screen/$feature/');
  print(' ├── ${feature}_screen.dart');
  print(' ├── notifier/${feature}_notifier.dart');
  print(' └── state/${feature}_state.dart\n');

  // Add to Git
  final result = Process.runSync('git', ['add', '.']);

  if (result.exitCode == 0) {
    print('📦 All generated files added to Git successfully.');
  } else {
    print('❌ Failed to add files to Git:\n${result.stderr}');
  }

  // Run build_runner
  print(
    '⚙️ Running build_runner to generate *.g.dart and *.freezed.dart files...',
  );
  final buildResult = Process.runSync('dart', [
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ], runInShell: true);

  if (buildResult.exitCode == 0) {
    print('✅ build_runner completed successfully.');
  } else {
    print('❌ build_runner failed:\n${buildResult.stderr}');
  }
}
