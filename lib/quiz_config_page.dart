import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_creator/l10n/app_localizations.dart';
import 'database_helper.dart';
import 'quiz_page.dart';

class QuizConfigPage extends StatefulWidget {
  const QuizConfigPage({super.key});

  @override
  State<QuizConfigPage> createState() => _QuizConfigPageState();
}

class _QuizConfigPageState extends State<QuizConfigPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  int _totalQuestionsInDb = 0;
  List<int> _questionIds = [];
  Map<int, bool> _questionResults = {}; // questionId -> isCorrect
  final TextEditingController _customCountController = TextEditingController();
  bool _isLoading = true;
  bool _isShuffle = false;
  int? _selectedFrom;
  int? _selectedTo;

  @override
  void initState() {
    super.initState();
    _loadQuestionCount();
  }

  void _loadQuestionCount() async {
    final prefs = await SharedPreferences.getInstance();
    final questions = await _dbHelper.getQuestions();
    final results = await _dbHelper.getQuestionResults();
    setState(() {
      _totalQuestionsInDb = questions.length;
      _questionIds = questions.map((q) => q.id ?? 0).toList();
      _questionResults = results;
      _isShuffle = prefs.getBool('isShuffleQuestions') ?? false;
      _isLoading = false;
    });
  }

  void _toggleShuffle(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isShuffleQuestions', value);
    setState(() {
      _isShuffle = value;
    });
  }

  void _startQuiz(int? count, {int? from, int? to}) {
    int start = (from ?? 1) - 1;
    int end =
        to ??
        (from != null ? _totalQuestionsInDb : (count ?? _totalQuestionsInDb));

    if (from == null && count != null) {
      end = count;
    }

    if (start < 0) start = 0;
    if (end > _totalQuestionsInDb) end = _totalQuestionsInDb;
    if (start >= end) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Noto\'g\'ri oraliq tanlandi')),
      );
      return;
    }

    // If range is selected (from/to), always use sequential order
    final bool useSequential = from != null && to != null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(
          limit: end - start,
          isShuffle: useSequential ? false : _isShuffle,
          startIndex: start + 1,
        ),
      ),
    );
  }

  Color _getGridItemColor(int index, bool isEndpoint, bool isInRange) {
    if (isEndpoint) {
      return Theme.of(context).colorScheme.primary;
    }
    final questionId = _questionIds.isNotEmpty && index < _questionIds.length
        ? _questionIds[index]
        : 0;
    if (_questionResults.containsKey(questionId)) {
      if (_questionResults[questionId] == true) {
        return isInRange ? Colors.green.withValues(alpha: 0.7) : Colors.green;
      } else {
        return isInRange ? Colors.red.withValues(alpha: 0.7) : Colors.red;
      }
    }
    return isInRange
        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
        : Colors.grey[200]!;
  }

  Color _getGridItemTextColor(int index, bool isEndpoint) {
    if (isEndpoint) {
      return Colors.white;
    }
    final questionId = _questionIds.isNotEmpty && index < _questionIds.length
        ? _questionIds[index]
        : 0;
    if (_questionResults.containsKey(questionId)) {
      return Colors.white;
    }
    return Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_totalQuestionsInDb == 0) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.quizConfig)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedInformationCircle,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noQuestions,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.backToHome),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.questionCount)),
      floatingActionButton: _selectedFrom != null && _selectedTo != null
          ? FloatingActionButton.extended(
              onPressed: () =>
                  _startQuiz(null, from: _selectedFrom, to: _selectedTo),
              icon: const HugeIcon(
                icon: HugeIcons.strokeRoundedPlayCircle,
                color: Colors.white,
              ),
              label: Text(l10n.startQuiz),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.questionsFound(_totalQuestionsInDb),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _ConfigButton(
                title: '10 ${l10n.questions}',
                onTap: () => _startQuiz(10),
                enabled: _totalQuestionsInDb >= 10,
              ),
              const SizedBox(height: 16),
              _ConfigButton(
                title: '20 ${l10n.questions}',
                onTap: () => _startQuiz(20),
                enabled: _totalQuestionsInDb >= 20,
              ),
              const SizedBox(height: 16),
              _ConfigButton(
                title: l10n.allQuestions,
                onTap: () => _startQuiz(null),
                enabled: true,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        HugeIcon(
                          icon: HugeIcons.strokeRoundedShuffle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.randomQuestions,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    Switch(value: _isShuffle, onChanged: _toggleShuffle),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 24),
              Text(
                '${l10n.questionCount}:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _customCountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '5',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      int? count = int.tryParse(_customCountController.text);
                      _startQuiz(count);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                    child: Text(l10n.startQuiz),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 24),
              Text(
                '${l10n.rangeSelection}:',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: _totalQuestionsInDb,
                  itemBuilder: (context, index) {
                    final qNum = index + 1;
                    bool isInRange = false;
                    bool isEndpoint = false;
                    if (_selectedFrom != null && _selectedTo != null) {
                      isInRange =
                          qNum >= _selectedFrom! && qNum <= _selectedTo!;
                      isEndpoint = qNum == _selectedFrom || qNum == _selectedTo;
                    } else if (_selectedFrom != null) {
                      isEndpoint = qNum == _selectedFrom;
                    }
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (_selectedFrom == null) {
                            _selectedFrom = qNum;
                          } else if (_selectedTo == null) {
                            if (qNum < _selectedFrom!) {
                              _selectedTo = _selectedFrom;
                              _selectedFrom = qNum;
                            } else {
                              _selectedTo = qNum;
                            }
                          } else {
                            _selectedFrom = qNum;
                            _selectedTo = null;
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getGridItemColor(
                            index,
                            isEndpoint,
                            isInRange,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: isEndpoint
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            '$qNum',
                            style: GoogleFonts.poppins(
                              fontWeight: isEndpoint
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: _getGridItemTextColor(index, isEndpoint),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_selectedFrom != null && _selectedTo != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    '${l10n.from}: $_selectedFrom  -  ${l10n.to}: $_selectedTo',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConfigButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool enabled;

  const _ConfigButton({
    required this.title,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? null : Colors.grey[200],
        foregroundColor: enabled ? null : Colors.grey[500],
        elevation: enabled ? 2 : 0,
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }
}
