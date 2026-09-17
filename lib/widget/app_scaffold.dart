import 'package:c2c/widget/app_annotated_region.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../di/theme_notifier.dart';

class AppScaffold extends ConsumerWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;

  const AppScaffold({
    Key? key,
    required this.body,
    this.floatingActionButton,
    this.appBar,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      body: AppAnnotatedRegion(child: SafeArea(child: body)),
      floatingActionButton:
          floatingActionButton ??
          FloatingActionButton(
            onPressed: () async {
              await ref.read(themeNotifierProvider.notifier).switchTheme();
              //     CommonSheet.showAppBottomSheet(
              //       title: context.translate.select_language,
              //       contentPadding: EdgeInsets.zero,
              //       onPositiveTap: () {},
              //       onNegativeTap: () {},
              //       content:  PersonalDetailsScreen(args: PersonalDetailsArgs(
              //         type: ProfileDetailsType.createProfile,
              //       )).languageSheetContent()
              //     );
            },
          ),
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
