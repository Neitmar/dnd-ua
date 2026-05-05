import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_assets.dart';
import '../providers/app_state.dart';
import '../services/localization_service.dart';
import '../widgets/dnd_ui_widgets.dart';
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

    return DndScaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: _NavIcon(AppAssets.navCharacter),
            activeIcon: _NavIcon(AppAssets.navCharacterActive),
            label: tr(context, 'character'),
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(AppAssets.navArmory),
            activeIcon: _NavIcon(AppAssets.navArmoryActive),
            label: tr(context, 'armory'),
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(AppAssets.navCombat),
            activeIcon: _NavIcon(AppAssets.navCombatActive),
            label: tr(context, 'combat'),
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(AppAssets.navSpells),
            activeIcon: _NavIcon(AppAssets.navSpellsActive),
            label: tr(context, 'spells'),
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(AppAssets.navInventory),
            activeIcon: _NavIcon(AppAssets.navInventoryActive),
            label: tr(context, 'inventory'),
          ),
          BottomNavigationBarItem(
            icon: _NavIcon(AppAssets.navDice),
            activeIcon: _NavIcon(AppAssets.navDiceActive),
            label: tr(context, 'dice'),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String path;
  const _NavIcon(this.path);

  @override
  Widget build(BuildContext context) => Image.asset(
        path,
        width: 24,
        height: 24,
        errorBuilder: (_, _, _) => const SizedBox(width: 24, height: 24),
      );
}
