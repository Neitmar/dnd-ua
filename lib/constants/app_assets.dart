/// Централізований реєстр всіх статичних асетів ДнД - Компаньон.
/// Змінювати шляхи лише тут — весь проект підтягне оновлення автоматично.
class AppAssets {
  // ── Фони ────────────────────────────────────────────────────────────────────
  static const String bgTavern          = 'assets/images/bg_tavern.jpg';
  static const String bgParchment       = 'assets/images/bg_parchment.jpg';
  static const String bgParchmentV2Sand = 'assets/images/bg_parchment_v2_sand.jpg';
  static const String bgParchmentV4Dark = 'assets/images/bg_parchment_v4_dark.jpg';

  // ── Крила (demon = темна тема, angel = світла; _clean = без фону) ────────────
  static const String wingDemonClean = 'assets/icons/wing_demon_clean.png';
  static const String wingAngelClean = 'assets/icons/wing_angel_clean.png';
  static const String wingDemon      = 'assets/icons/wing_demon.png';
  static const String wingAngel      = 'assets/icons/wing_angel.png';

  // ── Навігаційні іконки (PNG) ─────────────────────────────────────────────────
  static const String navCharacter = 'assets/icons/nav_character.png';
  static const String navArmor     = 'assets/icons/nav_armor.png';
  static const String navCombat    = 'assets/icons/nav_combat.png';
  static const String navSpells    = 'assets/icons/nav_spells.png';
  static const String navInventory = 'assets/icons/nav_inventory.png';
  static const String navDice      = 'assets/icons/nav_dice.png';
  static const String navNotes     = 'assets/icons/nav_notes.png';

  // ── Іконки монет (SVG) ───────────────────────────────────────────────────────
  static const String coinCopper   = 'assets/icons/ic_coin_copper.svg';
  static const String coinSilver   = 'assets/icons/ic_coin_silver.svg';
  static const String coinGold     = 'assets/icons/ic_coin_gold.svg';
  static const String coinElectrum = 'assets/icons/ic_coin_electrum.svg';
  static const String coinPlatinum = 'assets/icons/ic_coin_platinum.svg';

  // ── Іконки категорій інвентаря — ТЕМНА тема (тёмні іконки для СВІТЛОГО фону) ─
  static const String invDarkAll         = 'assets/icons/dark-theme-all.png';
  static const String invDarkArmors      = 'assets/icons/dark-theme-armors.png';
  static const String invDarkWeapons     = 'assets/icons/dark-theme-weapons.png';
  static const String invDarkPotions     = 'assets/icons/dark-theme-potions.png';
  static const String invDarkQuest       = 'assets/icons/dark-theme-quest.png';
  static const String invDarkUseful      = 'assets/icons/dark-theme-useful.png';
  static const String invDarkAccessories = 'assets/icons/dark-theme-accessories.png';

  // ── Іконки категорій інвентаря — СВІТЛА тема (світлі іконки для ТЕМНОГО фону) ─
  static const String invLightAll         = 'assets/icons/light-theme-all.png';
  static const String invLightArmors      = 'assets/icons/light-theme-armors.png';
  static const String invLightWeapons     = 'assets/icons/light-theme-weapons.png';
  static const String invLightPotions     = 'assets/icons/light-theme-potions.png';
  static const String invLightQuest       = 'assets/icons/light-theme-quest.png';
  static const String invLightUseful      = 'assets/icons/light-theme-useful.png';
  static const String invLightAccessories = 'assets/icons/light-theme-accessories.png';

  /// Повертає правильну іконку «Всі» залежно від теми.
  static String invIconAll(bool isLightTheme) =>
      isLightTheme ? invDarkAll : invLightAll;

  // ── Кнопка донату ────────────────────────────────────────────────────────────
  static const String donatButton       = 'assets/images/donat.png';
  static const String donatButtonActive = 'assets/images/donat-activ.png';

  // ── Резерв для майбутнього візуалу ──────────────────────────────────────────
  // static const String characterSex     = 'assets/icons/sex.png';
  // static const String characterRace    = 'assets/icons/race.png';
  // static const String characterClass   = 'assets/icons/class.png';
  // static const String armorySlots      = 'assets/icons/armori.png';
}
