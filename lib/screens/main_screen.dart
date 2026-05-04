import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/localization_service.dart';
import 'character_screen.dart';
import 'combat_screen.dart';
import 'spells_screen.dart';
import 'inventory_screen.dart';
import 'dice_screen.dart';
import 'tavern_screen.dart';
import 'armory_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CharacterScreen(),
    ArmoryScreen(),
    CombatScreen(),
    SpellsScreen(),
    InventoryScreen(),
    DiceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    if (!state.onboardingDone) {
      return const TavernScreen();
    }

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: tr(context, 'character'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shield_moon_outlined),
            activeIcon: const Icon(Icons.shield_moon),
            label: tr(context, 'armory'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.shield_outlined),
            activeIcon: const Icon(Icons.shield),
            label: tr(context, 'combat'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_awesome_outlined),
            activeIcon: const Icon(Icons.auto_awesome),
            label: tr(context, 'spells'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.backpack_outlined),
            activeIcon: const Icon(Icons.backpack),
            label: tr(context, 'inventory'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.casino_outlined),
            activeIcon: const Icon(Icons.casino),
            label: tr(context, 'dice'),
          ),
        ],
      ),
    );
  }
}
