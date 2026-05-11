import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_assets.dart';
import '../providers/app_state.dart';
import '../services/localization_service.dart';

void showSettingsDialog(BuildContext context) {
  showDialog(context: context, builder: (_) => const SettingsDialog());
}

List<Widget> settingsAction(BuildContext context) {
  return [
    IconButton(
      icon: const Icon(Icons.settings),
      tooltip: tr(context, 'settings'),
      onPressed: () => showSettingsDialog(context),
    ),
  ];
}

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  void _showSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(trRead(context, 'comingSoon'))));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return AlertDialog(
      title: Text(tr(context, 'settings')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr(context, 'theme'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: state.isLightTheme,
              activeThumbColor: Theme.of(context).colorScheme.primary,
              title: Text(tr(context, state.isLightTheme ? 'light_theme' : 'dark_theme')),
              subtitle: Text(tr(context, 'theme_description')),
              onChanged: state.setThemeMode,
            ),
            const SizedBox(height: 18),
            Text(
              tr(context, 'language'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RadioGroup<String>(
              groupValue: state.languageCode,
              onChanged: (value) {
                if (value != null) state.setLanguage(value);
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    value: 'en',
                    title: Text(tr(context, 'english')),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  RadioListTile<String>(
                    value: 'ru',
                    title: Text(tr(context, 'russian')),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  RadioListTile<String>(
                    value: 'uk',
                    title: Text(tr(context, 'ukrainian')),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.account_circle_outlined),
              title: Text(tr(context, 'googleAccount')),
              onTap: () => _showSoon(context),
            ),
            const Divider(height: 20),
            Text(
              tr(context, 'shareCharacter'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: Text(tr(context, 'printPdf')),
              onTap: () => _showSoon(context),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.link),
              title: Text(tr(context, 'shareLink')),
              onTap: () => _showSoon(context),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 4),
            Center(child: _DonatButton()),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(tr(context, 'close')),
        ),
      ],
    );
  }
}

class _DonatButton extends StatefulWidget {
  @override
  State<_DonatButton> createState() => _DonatButtonState();
}

class _DonatButtonState extends State<_DonatButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          // Padding резервує місце для свічення — розмір НЕ змінюється при натисканні
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: SizedBox(
              height: 56,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  if (_pressed) ...[
                    // Коричневий широкий шар — видно на світлій темі
                    Positioned(
                      top: -14, bottom: -14, left: -8, right: -8,
                      child: ImageFiltered(
                        imageFilter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF7B3A10),
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(AppAssets.donatButtonActive, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    // Золотий гостріший шар
                    Positioned(
                      top: -10, bottom: -10, left: -4, right: -4,
                      child: ImageFiltered(
                        imageFilter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFFBD675),
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(AppAssets.donatButtonActive, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  ],
                  Image.asset(
                    _pressed ? AppAssets.donatButtonActive : AppAssets.donatButton,
                    height: 56,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          tr(context, 'donateButton'),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
