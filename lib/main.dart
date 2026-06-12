import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'l10n/app_localizations.dart';
import 'home_page.dart';
import 'login_page.dart';

// Global notifiers for locale, theme mode, color, sound and vibration changes
final localeNotifier = ValueNotifier<Locale>(const Locale('uz'));
final themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);
final themeColorNotifier = ValueNotifier<Color>(const Color(0xFF673AB7));
final isSoundEnabledNotifier = ValueNotifier<bool>(true);
final isVibrationEnabledNotifier = ValueNotifier<bool>(true);

// Initialize ShorebirdUpdater for manual OTA update management
final _shorebirdUpdater = ShorebirdUpdater();

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

/// Checks for updates silently in the background and applies them if found.
void _checkForUpdatesSilently() {
  if (!_shorebirdUpdater.isAvailable) {
    debugPrint('Shorebird: Updater is not available (e.g., running in debug mode, simulator, or unsupported platform).');
    return;
  }

  _shorebirdUpdater.readCurrentPatch().then((patch) {
    if (patch != null) {
      debugPrint('Shorebird: Running patch version: ${patch.number}');
    } else {
      debugPrint('Shorebird: Running base release (no patch applied yet).');
    }
  }).catchError((e) {
    debugPrint('Shorebird: Error reading current patch: $e');
  });

  _shorebirdUpdater.checkForUpdate().then((status) {
    if (status == UpdateStatus.outdated) {
      _shorebirdUpdater.update().then((_) {
        debugPrint('Shorebird: Update downloaded successfully. The patch will be applied on the next cold start.');
      }).catchError((e) {
        debugPrint('Shorebird: Error downloading update: $e');
      });
    } else {
      debugPrint('Shorebird: Update check completed. Status: $status');
    }
  }).catchError((e) {
    debugPrint('Shorebird: Error checking for updates: $e');
  });
}

class QuizApp extends StatefulWidget {
  final bool isLoggedIn;
  const QuizApp({super.key, required this.isLoggedIn});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  @override
  void initState() {
    super.initState();
    // Check for updates asynchronously after the widget tree is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdatesSilently();
    });
  }

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
                  home: widget.isLoggedIn ? const HomePage() : const LoginPage(),
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
