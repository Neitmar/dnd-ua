import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'constants/design_tokens.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.load();
  await appState.checkOnboarding();

  runApp(ChangeNotifierProvider.value(value: appState, child: const DndApp()));
}

class DndApp extends StatefulWidget {
  const DndApp({super.key});

  @override
  State<DndApp> createState() => _DndAppState();
}

class _DndAppState extends State<DndApp> {
  // Bumps FontWeight one step heavier, capping at w700.
  FontWeight _bumpWeight(FontWeight w) {
    final next = <FontWeight, FontWeight>{
      FontWeight.w100: FontWeight.w200,
      FontWeight.w200: FontWeight.w300,
      FontWeight.w300: FontWeight.w400,
      FontWeight.w400: FontWeight.w500,
      FontWeight.w500: FontWeight.w600,
      FontWeight.w600: FontWeight.w700,
    };
    return next[w] ?? w;
  }

  TextStyle _applyEffect(TextStyle? style, List<Shadow> shadows) {
    if (style == null) return TextStyle(shadows: shadows);
    return style.copyWith(
      fontWeight: _bumpWeight(style.fontWeight ?? FontWeight.w400),
      shadows: shadows,
    );
  }

  TextTheme _applyTextEffects(TextTheme theme, Brightness brightness) {
    final shadows = DesignTokens.getTextShadow(brightness);
    return theme.copyWith(
      displayLarge: _applyEffect(theme.displayLarge, shadows),
      displayMedium: _applyEffect(theme.displayMedium, shadows),
      displaySmall: _applyEffect(theme.displaySmall, shadows),
      headlineLarge: _applyEffect(theme.headlineLarge, shadows),
      headlineMedium: _applyEffect(theme.headlineMedium, shadows),
      headlineSmall: _applyEffect(theme.headlineSmall, shadows),
      titleLarge: _applyEffect(theme.titleLarge, shadows),
      titleMedium: _applyEffect(theme.titleMedium, shadows),
      titleSmall: _applyEffect(theme.titleSmall, shadows),
      bodyLarge: _applyEffect(theme.bodyLarge, shadows),
      bodyMedium: _applyEffect(theme.bodyMedium, shadows),
      bodySmall: _applyEffect(theme.bodySmall, shadows),
      labelLarge: _applyEffect(theme.labelLarge, shadows),
      labelMedium: _applyEffect(theme.labelMedium, shadows),
      labelSmall: _applyEffect(theme.labelSmall, shadows),
    );
  }

  TextTheme _getTextTheme(String languageCode, Brightness brightness) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true).textTheme
        : ThemeData.light(useMaterial3: true).textTheme;
    final fontTheme = languageCode == 'en'
        ? GoogleFonts.playfairDisplayTextTheme(base)
        : GoogleFonts.forumTextTheme(base);
    return _applyTextEffects(fontTheme, brightness);
  }

  ThemeData _buildLightTheme(String languageCode) {
    final colorScheme = ColorScheme.light().copyWith(
      primary: DesignTokens.lightAccent,
      onPrimary: DesignTokens.lightBg,
      primaryContainer: DesignTokens.lightBgCard,
      onPrimaryContainer: DesignTokens.lightText,
      secondary: DesignTokens.lightDanger,
      onSecondary: DesignTokens.lightBg,
      secondaryContainer: DesignTokens.lightBgInput,
      onSecondaryContainer: DesignTokens.lightTextDim,
      surface: DesignTokens.lightBg,
      onSurface: DesignTokens.lightText,
      onSurfaceVariant: DesignTokens.lightTextDim,
      surfaceContainerLowest: DesignTokens.lightBgCard,
      surfaceContainerLow: DesignTokens.lightBgElev,
      surfaceContainer: DesignTokens.lightBg,
      surfaceContainerHigh: DesignTokens.lightBorderSoft,
      surfaceContainerHighest: DesignTokens.lightBorder,
      error: DesignTokens.lightDanger,
      onError: DesignTokens.lightBg,
      tertiary: const Color(0xFF4A8A6E),
      onTertiary: DesignTokens.lightBg,
      outline: DesignTokens.lightBorder,
      outlineVariant: DesignTokens.lightBorderSoft,
    );

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: DesignTokens.lightBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignTokens.lightBgElev,
        foregroundColor: DesignTokens.lightText,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: DesignTokens.lightBgCard,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: DesignTokens.lightBorder,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: DesignTokens.lightBorderSoft),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.lightBgInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: DesignTokens.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: DesignTokens.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: DesignTokens.lightAccent),
        ),
        labelStyle: TextStyle(color: DesignTokens.lightTextDim),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: DesignTokens.lightAccent,
        unselectedLabelColor: DesignTokens.lightTextDim,
        indicatorColor: DesignTokens.lightDanger,
        dividerColor: DesignTokens.lightBorderSoft,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: DesignTokens.lightBorder),
          foregroundColor: DesignTokens.lightText,
        ),
      ),
      textTheme: _getTextTheme(languageCode, Brightness.light),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DesignTokens.lightBg,
        selectedItemColor: DesignTokens.lightAccent,
        unselectedItemColor: DesignTokens.lightTextMute,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      useMaterial3: true,
    );
  }

  ThemeData _buildDarkTheme(String languageCode) {
    final colorScheme = ColorScheme.dark().copyWith(
      primary: DesignTokens.darkAccent,
      onPrimary: DesignTokens.darkBg,
      primaryContainer: DesignTokens.darkBgCard,
      onPrimaryContainer: DesignTokens.darkText,
      secondary: DesignTokens.darkDanger,
      onSecondary: DesignTokens.darkBg,
      secondaryContainer: DesignTokens.darkBgInput,
      onSecondaryContainer: DesignTokens.darkText,
      surface: DesignTokens.darkBg,
      onSurface: DesignTokens.darkText,
      onSurfaceVariant: DesignTokens.darkTextDim,
      surfaceContainerLowest: const Color(0xFF0F0A07),
      surfaceContainerLow: DesignTokens.darkBgElev,
      surfaceContainer: DesignTokens.darkBgCard,
      surfaceContainerHigh: DesignTokens.darkBorder,
      surfaceContainerHighest: const Color(0xFF44362A),
      error: DesignTokens.darkDanger,
      onError: DesignTokens.darkText,
      tertiary: const Color(0xFF4A8A6E),
      onTertiary: DesignTokens.darkBg,
      outline: DesignTokens.darkBorder,
      outlineVariant: DesignTokens.darkBorderSoft,
    );

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: DesignTokens.darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignTokens.darkBgElev,
        foregroundColor: DesignTokens.darkText,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: const CardThemeData(
        color: DesignTokens.darkBgCard,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: Color(0xFF000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: DesignTokens.darkBorderSoft),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.darkBgInput,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: DesignTokens.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: DesignTokens.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: DesignTokens.darkAccent),
        ),
        labelStyle: TextStyle(color: DesignTokens.darkTextDim),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: DesignTokens.darkAccent,
        unselectedLabelColor: DesignTokens.darkTextDim,
        indicatorColor: DesignTokens.darkDanger,
        dividerColor: DesignTokens.darkBorderSoft,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: DesignTokens.darkBorder),
          foregroundColor: DesignTokens.darkText,
        ),
      ),
      textTheme: _getTextTheme(languageCode, Brightness.dark),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DesignTokens.darkBg,
        selectedItemColor: DesignTokens.darkAccent,
        unselectedItemColor: DesignTokens.darkTextMute,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return MaterialApp(
      title: 'ДнД Українською',
      debugShowCheckedModeBanner: false,
      theme: appState.isLightTheme
          ? _buildLightTheme(appState.languageCode)
          : _buildDarkTheme(appState.languageCode),
      home: const MainScreen(),
    );
  }
}

