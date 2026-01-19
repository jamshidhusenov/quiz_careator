import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:quiz_creator/l10n/app_localizations.dart';
import 'database_helper.dart';
import 'data_service.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({super.key});

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final TextEditingController _controller = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  void _saveQuestion() async {
    final l10n = AppLocalizations.of(context)!;
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    final questions = DataService.parseQuestions(text);

    if (questions.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.noQuestions)));
      }
      return;
    }

    int savedCount = 0;
    for (var q in questions) {
      await _dbHelper.insertQuestion(q);
      savedCount++;
    }

    if (mounted) {
      _controller.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.questionsFound(savedCount))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addQuestion)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.templateFormat,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Text(
                    'Savol 1\n====\n# To\'g\'ri javob\n====\nNoto\'g\'ri\n++++\nSavol 2\n====\n# To\'g\'ri javob\n====\nNoto\'g\'ri',
                    style: GoogleFonts.firaCode(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedCopy01,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      Clipboard.setData(
                        const ClipboardData(
                          text:
                              'Savol 1\n====\n# To\'g\'ri javob\n====\nNoto\'g\'ri\n++++\nSavol 2\n====\n# To\'g\'ri javob\n====\nNoto\'g\'ri',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.copied),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    tooltip: l10n.copyTemplate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: l10n.pasteHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveQuestion,
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                color: Colors.white,
                size: 20,
              ),
              label: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}
