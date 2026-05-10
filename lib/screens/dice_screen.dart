import 'package:flutter/material.dart';
import 'dart:math';

import '../utils/theme_danger.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  final Random _random = Random();
  final List<Map<String, dynamic>> _history = [];
  bool _advantage = false;
  bool _disadvantage = false;
  int _modifier = 0;

  final List<int> _diceTypes = [4, 6, 8, 10, 12, 20, 100];

  void _roll(int sides) {
    int roll1 = _random.nextInt(sides) + 1;
    int result = roll1;
    String label = 'd$sides';
    String detail = '';

    if (sides == 20 && (_advantage || _disadvantage)) {
      int roll2 = _random.nextInt(sides) + 1;
      if (_advantage) {
        result = max(roll1, roll2);
        detail = '($roll1, $roll2) перевага';
      } else {
        result = min(roll1, roll2);
        detail = '($roll1, $roll2) вада';
      }
    }

    final total = result + _modifier;
    final modStr = _modifier > 0
        ? '+$_modifier'
        : _modifier < 0
        ? '$_modifier'
        : '';

    setState(() {
      _history.insert(0, {
        'label': label,
        'result': result,
        'total': total,
        'detail': detail,
        'modifier': modStr,
        'isCrit': sides == 20 && result == 20,
        'isFail': sides == 20 && result == 1,
      });
      if (_history.length > 20) _history.removeLast();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDicePanel(),
        _buildModifierRow(),
        _buildAdvantageRow(),
        if (_history.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline, size: 15),
                  label: const Text('Очистити', style: TextStyle(fontSize: 12)),
                  onPressed: () => setState(() => _history.clear()),
                ),
              ],
            ),
          ),
        const Divider(height: 1),
        Expanded(child: _buildHistory()),
      ],
    );
  }

  Widget _buildDicePanel() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.4,
        physics: const NeverScrollableScrollPhysics(),
        children: _diceTypes.map((sides) => _buildDiceButton(sides)).toList(),
      ),
    );
  }

  Widget _buildDiceButton(int sides) {
    final isD20 = sides == 20;
    return ElevatedButton(
      onPressed: () => _roll(sides),
      style: ElevatedButton.styleFrom(
        backgroundColor: isD20
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondaryContainer,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        'd$sides',
        style: TextStyle(
          fontSize: isD20 ? 18 : 16,
          fontWeight: FontWeight.bold,
          color: isD20
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  Widget _buildModifierRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Text('Модифікатор:', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => setState(() => _modifier--),
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Text(
            _modifier >= 0 ? '+$_modifier' : '$_modifier',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () => setState(() => _modifier++),
            icon: const Icon(Icons.add_circle_outline),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => setState(() => _modifier = 0),
            child: const Text('Скинути'),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvantageRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Text('d20:', style: TextStyle(fontSize: 15)),
          const SizedBox(width: 12),
          ChoiceChip(
            label: const Text('Перевага'),
            selected: _advantage,
            onSelected: (v) => setState(() {
              _advantage = v;
              if (v) _disadvantage = false;
            }),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Вада'),
            selected: _disadvantage,
            onSelected: (v) => setState(() {
              _disadvantage = v;
              if (v) _advantage = false;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    if (_history.isEmpty) {
      return const Center(
        child: Text(
          'Кидай кубики!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final item = _history[index];
        final isCrit = item['isCrit'] as bool;
        final isFail = item['isFail'] as bool;

        final isLight = Theme.of(context).brightness == Brightness.light;
        Color? tileColor;
        if (isCrit) tileColor = isLight ? Colors.green.shade100 : Colors.green.shade900;
        if (isFail) tileColor = isLight ? Colors.red.shade100 : Colors.red.shade900;

        return Card(
          color: tileColor,
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
          child: ListTile(
            dense: true,
            leading: CircleAvatar(
              backgroundColor: isCrit
                  ? Colors.green
                  : isFail
                  ? dangerColor(context)
                  : Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                item['label'],
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Row(
              children: [
                Text(
                  '${item['total']}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isCrit
                        ? Colors.green.shade300
                        : isFail
                        ? Colors.red.shade300
                        : null,
                  ),
                ),
                if (item['modifier'].isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Text(
                    '(${item['result']}${item['modifier']})',
                    style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55)),
                  ),
                ],
                if (isCrit)
                  const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'КРИТ!',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isFail)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'ПРОВАЛ',
                      style: dangerStyle(context, const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
            subtitle: item['detail'].isNotEmpty
                ? Text(
                    item['detail'],
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55)),
                  )
                : null,
          ),
        );
      },
    );
  }
}
