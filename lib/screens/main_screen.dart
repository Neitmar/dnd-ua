import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/localization_service.dart';
import '../constants/app_assets.dart';
import '../widgets/dnd_design_system.dart';
import 'character_screen.dart';
import 'combat_screen.dart';
import 'spells_screen.dart';
import 'inventory_screen.dart';
import 'dice_screen.dart';
import 'tavern_screen.dart';
import 'armory_screen.dart';
import 'notes_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static const _titleKeys = [
    'character', 'armory', 'combat', 'spells', 'inventory', 'dice', 'notes',
  ];

  final List<Widget> _screens = const [
    CharacterScreen(),
    ArmoryScreen(),
    CombatScreen(),
    SpellsScreen(),
    InventoryScreen(),
    DiceScreen(),
    NotesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    if (!state.onboardingDone) {
      return const TavernScreen();
    }

    return DndScaffold(
      appBar: DndAppBar(
        title: tr(context, _titleKeys[_currentIndex]).toUpperCase(),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: DndNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          DndNavItem(imagePath: AppAssets.navCharacter, label: tr(context, 'character')),
          DndNavItem(imagePath: AppAssets.navArmor,     label: tr(context, 'armory')),
          DndNavItem(imagePath: AppAssets.navCombat,    label: tr(context, 'combat')),
          DndNavItem(imagePath: AppAssets.navSpells,    label: tr(context, 'spells')),
          DndNavItem(imagePath: AppAssets.navInventory, label: tr(context, 'inventory')),
          DndNavItem(imagePath: AppAssets.navDice,      label: tr(context, 'dice')),
          DndNavItem(imagePath: AppAssets.navNotes,     label: tr(context, 'notes')),
        ],
      ),
    );
  }
}
