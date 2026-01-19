import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quiz_creator/l10n/app_localizations.dart';
import 'database_helper.dart';
import 'models.dart';
import 'data_service.dart';

class QuestionsListPage extends StatefulWidget {
  const QuestionsListPage({super.key});

  @override
  State<QuestionsListPage> createState() => _QuestionsListPageState();
}

class _QuestionsListPageState extends State<QuestionsListPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Question> _questions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    final questions = await _dbHelper.getQuestions();
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  void _exportQuestions() async {
    final l10n = AppLocalizations.of(context)!;
    if (_questions.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.noQuestions)));
      }
      return;
    }

    final text = DataService.formatQuestions(_questions);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/quiz_export.txt');
    await file.writeAsString(text);

    await Share.shareXFiles([XFile(file.path)], text: l10n.homeTitle);
  }

  void _importQuestions() async {
    final l10n = AppLocalizations.of(context)!;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();
      final questions = DataService.parseQuestions(content);

      if (questions.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.noQuestions)));
        }
        return;
      }

      for (var q in questions) {
        await _dbHelper.insertQuestion(q);
      }

      _loadQuestions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.questionsFound(questions.length))),
        );
      }
    }
  }

  void _clearAllQuestions() async {
    final l10n = AppLocalizations.of(context)!;
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAll),
        content: Text(
          l10n.noQuestions, // Fallback confirmation text
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.backToHome),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.clearAll),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _dbHelper.clearDatabase();
      _loadQuestions();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.noQuestions)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.questionsList),
        actions: [
          IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedDelete02,
              color: Colors.red[400]!,
            ),
            onPressed: _clearAllQuestions,
            tooltip: l10n.clearAll,
          ),
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedUpload01,
              color: Colors.white,
            ),
            onPressed: _importQuestions,
            tooltip: l10n.import,
          ),
          IconButton(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedShare01,
              color: Colors.white,
            ),
            onPressed: _exportQuestions,
            tooltip: l10n.export,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
          ? Center(
              child: Text(
                l10n.noQuestions,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 1,
                  color: Theme.of(context).colorScheme.surface,
                  surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${index + 1}. ${question.text}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...question.options.map((option) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: option.isCorrect
                                  ? Colors.green.withValues(alpha: 0.08)
                                  : Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: option.isCorrect
                                    ? Colors.green.withValues(alpha: 0.5)
                                    : Theme.of(
                                        context,
                                      ).colorScheme.outlineVariant,
                              ),
                            ),
                            child: Row(
                              children: [
                                HugeIcon(
                                  icon: option.isCorrect
                                      ? HugeIcons.strokeRoundedCheckmarkCircle01
                                      : HugeIcons.strokeRoundedCircle,
                                  color: option.isCorrect
                                      ? Colors.green
                                      : Colors.grey[400]!,
                                  size: 22,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    option.text,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      color: option.isCorrect
                                          ? Colors.green[900]
                                          : Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                      fontWeight: option.isCorrect
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
