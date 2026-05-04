import 'package:flutter/material.dart';
import '../dialogs/settings_dialog.dart';

class ScreenWithSettings extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const ScreenWithSettings({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Tooltip(
            message: 'Налаштування',
            child: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const SettingsDialog(),
                );
              },
            ),
          ),
        ),
        actions: actions,
        bottom: bottom,
      ),
      body: body,
    );
  }
}
