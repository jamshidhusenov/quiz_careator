import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'home_page.dart';
import 'login_page.dart';

// Global notifiers for locale, theme mode, color, sound and vibration changes
final localeNotifier = ValueNotifier<Locale>(const Locale('uz'));
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);
final themeColorNotifier = ValueNotifier<Color>(const Color(0xFF673AB7));
final isSoundEnabledNotifier = ValueNotifier<bool>(true);
final isVibrationEnabledNotifier = ValueNotifier<bool>(true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Load persistence
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  final String languageCode = prefs.getString('languageCode') ?? 'uz';
  localeNotifier.value = Locale(languageCode);

  final String themeMode = prefs.getString('themeMode') ?? 'light';
  themeModeNotifier.value = ThemeMode.values.firstWhere(
    (e) => e.name == themeMode,
    orElse: () => ThemeMode.light,
  );

  final int colorValue = prefs.getInt('themeColor') ?? 0xFF673AB7;
  themeColorNotifier.value = Color(colorValue);

  isSoundEnabledNotifier.value = prefs.getBool('isSoundEnabled') ?? true;
  isVibrationEnabledNotifier.value =
      prefs.getBool('isVibrationEnabled') ?? true;

  runApp(QuizApp(isLoggedIn: isLoggedIn));
}

class QuizApp extends StatelessWidget {
  final bool isLoggedIn;
  const QuizApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeModeNotifier,
          builder: (context, themeMode, _) {
            return ValueListenableBuilder<Color>(
              valueListenable: themeColorNotifier,
              builder: (context, seedColor, _) {
                return MaterialApp(
                  title: 'Quiz App',
                  debugShowCheckedModeBanner: false,
                  locale: locale,
                  themeMode: themeMode,
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  theme: _buildTheme(seedColor, Brightness.light),
                  darkTheme: _buildTheme(seedColor, Brightness.dark),
                  home: isLoggedIn ? const HomePage() : const LoginPage(),
                );
              },
            );
          },
        );
      },
    );
  }

  ThemeData _buildTheme(Color seedColor, Brightness brightness) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme(
        brightness == Brightness.dark
            ? ThemeData.dark().textTheme
            : ThemeData.light().textTheme,
      ),
    );

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
