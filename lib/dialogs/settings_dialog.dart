import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/localization_service.dart';
import '../services/character_export_service.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _selectedLanguage = state.language;
  }

  void _showExportDialog(AppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Передати персонажа'),
        content: const Text('Виберіть спосіб передачі:'),
        actions: [
          TextButton(
            onPressed: () {
              final jsonData = CharacterExportService.exportAsJson(state);
              final encodedUrl = CharacterExportService.exportAsEncodedUrl(state);
              _showShareLink(jsonData, encodedUrl);
            },
            child: const Text('За посиланням'),
          ),
          TextButton(
            onPressed: () {
              final pdfContent = CharacterExportService.generateCharacterSheet(state);
              _showExportPdf(pdfContent);
            },
            child: const Text('Як PDF'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Скасувати'),
          ),
        ],
      ),
    );
  }

  void _showShareLink(String jsonData, String encodedUrl) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Посилання персонажа'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Копіюйте цей код для передачі персонажа:'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  encodedUrl,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Реалізувати копіювання в буфер обміну
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Посилання скопійовано')),
              );
            },
            child: const Text('Копіювати'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Закрити'),
          ),
        ],
      ),
    );
  }

  void _showExportPdf(String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Аркуш персонажа'),
        content: SingleChildScrollView(
          child: SelectableText(
            content,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Реалізувати експорт в PDF
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF завантажено')),
              );
            },
            child: const Text('Завантажити PDF'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Закрити'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();
    return AlertDialog(
      title: const Text('Налаштування'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Вибір мови
            const Text(
              'Мова',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Column(
              children: LocalizationService.supportedLanguages.entries
                  .map(
                    (entry) => RadioListTile<String>(
                      title: Text(
                        '${entry.value['flag']} ${entry.value['name']}',
                      ),
                      value: entry.key,
                      groupValue: _selectedLanguage,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedLanguage = val);
                          state.changeLanguage(val);
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // Google акаунт
            const Text(
              'Синхронізація',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Реалізувати підключення Google аккаунту
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Функція буде доступна незабаром'),
                  ),
                );
              },
              icon: const Icon(Icons.account_circle),
              label: const Text('Підключити Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // Експорт персонажа
            const Text(
              'Персонаж',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _showExportDialog(state),
              icon: const Icon(Icons.share),
              label: const Text('Передати персонажа'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Реалізувати імпорт персонажа
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Функція імпорту буде доступна незабаром'),
                  ),
                );
              },
              icon: const Icon(Icons.upload),
              label: const Text('Імпортувати персонажа'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Закрити'),
        ),
      ],
    );
  }
}
