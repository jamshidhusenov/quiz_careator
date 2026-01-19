import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_creator/l10n/app_localizations.dart';
import 'main.dart';
import 'add_question_page.dart';
import 'quiz_config_page.dart';
import 'questions_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _changeLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', code);
    localeNotifier.value = Locale(code);
  }

  void _changeThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.name);
    themeModeNotifier.value = mode;
  }

  void _changeThemeColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeColor', color.toARGB32());
    themeColorNotifier.value = color;
  }

  void _toggleSound() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !isSoundEnabledNotifier.value;
    await prefs.setBool('isSoundEnabled', newValue);
    isSoundEnabledNotifier.value = newValue;
  }

  void _toggleVibration() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !isVibrationEnabledNotifier.value;
    await prefs.setBool('isVibrationEnabled', newValue);
    isVibrationEnabledNotifier.value = newValue;
  }

  void _showColorPicker(BuildContext context) {
    final colors = [
      const Color(0xFF673AB7), // Purple
      const Color(0xFF007AFF), // Cupertino Blue
      const Color(0xFFE91E63), // Pink/Red
      const Color(0xFF4CAF50), // Green
      const Color(0xFF009688), // Teal
      const Color(0xFFFF9800), // Orange
      const Color(0xFF2196F3), // Blue
      const Color(0xFF3F51B5), // Indigo
      const Color(0xFF8BC34A), // Light Green
      const Color(0xFF795548), // Brown
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme Color'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SizedBox(
          width: double.maxFinite,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  _changeThemeColor(colors[index]);
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: themeColorNotifier.value == colors[index] ? 3 : 0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colors[index].withValues(alpha: 0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildLanguageItem(
    String code,
    String flag,
    String label,
    bool isSelected,
    BuildContext context,
  ) {
    return PopupMenuItem<String>(
      value: code,
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeItem(
    String label,
    List<List<dynamic>> icon,
    bool isSelected,
    BuildContext context,
  ) {
    return _buildSettingItem(label, icon, isSelected, context);
  }

  Widget _buildSettingItem(
    String label,
    List<List<dynamic>> icon,
    bool isActive,
    BuildContext context, {
    Widget? trailing,
  }) {
    return Row(
      children: [
        HugeIcon(
          icon: icon,
          size: 20,
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.black54,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildToggleItem(
    String label,
    List<List<dynamic>> icon,
    bool isEnabled,
    BuildContext context,
  ) {
    return _buildSettingItem(
      label,
      icon,
      isEnabled,
      context,
      trailing: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isEnabled
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: HugeIcon(
          icon: isEnabled
              ? HugeIcons.strokeRoundedCheckmarkCircle01
              : HugeIcons.strokeRoundedCircle,
          size: 16,
          color: isEnabled
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedPaintBoard,
              color: Colors.white,
            ),
            onPressed: () => _showColorPicker(context),
            tooltip: 'Theme Color',
          ),
          PopupMenuButton<String>(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedSettings01,
              color: Colors.white,
            ),
            onSelected: (value) {
              if (value == 'light') _changeThemeMode(ThemeMode.light);
              if (value == 'dark') _changeThemeMode(ThemeMode.dark);
              if (value == 'sound') _toggleSound();
              if (value == 'vibration') _toggleVibration();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'light',
                child: _buildThemeItem(
                  'Light Mode',
                  HugeIcons.strokeRoundedSun01,
                  themeModeNotifier.value == ThemeMode.light,
                  context,
                ),
              ),
              PopupMenuItem(
                value: 'dark',
                child: _buildThemeItem(
                  'Dark Mode',
                  HugeIcons.strokeRoundedMoon,
                  themeModeNotifier.value == ThemeMode.dark,
                  context,
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'sound',
                child: _buildToggleItem(
                  'Sound Effects',
                  HugeIcons.strokeRoundedVolumeHigh,
                  isSoundEnabledNotifier.value,
                  context,
                ),
              ),
              PopupMenuItem(
                value: 'vibration',
                child: _buildToggleItem(
                  'Vibration',
                  HugeIcons.strokeRoundedAiIdea,
                  isVibrationEnabledNotifier.value,
                  context,
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedLanguageSkill,
              color: Colors.white,
            ),
            onSelected: _changeLanguage,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            itemBuilder: (context) {
              final currentCode = localeNotifier.value.languageCode;
              return [
                _buildLanguageItem(
                  'uz',
                  '🇺🇿',
                  'O\'zbek',
                  currentCode == 'uz',
                  context,
                ),
                _buildLanguageItem(
                  'ru',
                  '🇷🇺',
                  'Русский',
                  currentCode == 'ru',
                  context,
                ),
                _buildLanguageItem(
                  'en',
                  '🇺🇸',
                  'English',
                  currentCode == 'en',
                  context,
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CategoryCard(
                title: l10n.addQuestion,
                icon: HugeIcons.strokeRoundedAddCircle,
                color: Theme.of(context).colorScheme.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddQuestionPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              _CategoryCard(
                title: l10n.solveQuiz,
                icon: HugeIcons.strokeRoundedPlaylist01,
                color: Theme.of(context).colorScheme.secondary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuizConfigPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              _CategoryCard(
                title: l10n.viewQuestions,
                icon: HugeIcons.strokeRoundedTask01,
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QuestionsListPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final List<List<dynamic>> icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.1), width: 2),
        ),
        child: Column(
          children: [
            HugeIcon(icon: icon, size: 48, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
