import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quiz_creator/l10n/app_localizations.dart';
import 'database_helper.dart';
import 'models.dart';
import 'result_page.dart';
import 'main.dart';

class QuizPage extends StatefulWidget {
  final int limit;
  final bool isShuffle;
  final int startIndex;
  const QuizPage({
    super.key,
    required this.limit,
    required this.isShuffle,
    this.startIndex = 1,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  List<bool?> _results = []; // true: correct, false: wrong, null: unanswered
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    final questions = await _dbHelper.getQuestions();
    List<Question> selectedQuestions = [];

    if (widget.isShuffle) {
      questions.shuffle();
      selectedQuestions = questions.take(widget.limit).toList();
    } else {
      // For sequential, we take from startIndex
      int skip = widget.startIndex - 1;
      if (skip < 0) skip = 0;
      selectedQuestions = questions.skip(skip).take(widget.limit).toList();
    }

    // Shuffle options for each question
    for (var q in selectedQuestions) {
      q.options.shuffle();
    }

    setState(() {
      _questions = selectedQuestions;
      _results = List<bool?>.filled(_questions.length, null);
      _isLoading = false;
    });
  }

  void _showExplanation() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedAiIdea,
              color: Colors.amber,
            ),
            const SizedBox(width: 8),
            Text(l10n.explanation),
          ],
        ),
        content: Text(l10n.noExplanation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showProgressGrid() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (ctx, scrollController) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.questionGrid,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: _questions.length,
                  itemBuilder: (ctx, index) {
                    Color bgColor;
                    Color textColor;
                    if (_results[index] == true) {
                      bgColor = Colors.green;
                      textColor = Colors.white;
                    } else if (_results[index] == false) {
                      bgColor = Colors.red;
                      textColor = Colors.white;
                    } else if (index == _currentIndex) {
                      bgColor = Theme.of(context).colorScheme.primary;
                      textColor = Colors.white;
                    } else {
                      bgColor = Colors.grey[200]!;
                      textColor = Colors.black87;
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() {
                          _currentIndex = index;
                          _selectedOptionIndex = null;
                          _isAnswered = _results[index] != null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${widget.startIndex + index}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _answerQuestion(int index) {
    if (_isAnswered) return;

    final isCorrect = _questions[_currentIndex].options[index].isCorrect;

    setState(() {
      _selectedOptionIndex = index;
      _isAnswered = true;
      if (isCorrect) {
        _score++;
        if (isVibrationEnabledNotifier.value) HapticFeedback.heavyImpact();
        if (isSoundEnabledNotifier.value) {
          _audioPlayer.play(AssetSource('sounds/correct.mp3'));
        }
      } else {
        if (isVibrationEnabledNotifier.value) HapticFeedback.vibrate();
        if (isSoundEnabledNotifier.value) {
          _audioPlayer.play(AssetSource('sounds/wrong-answer.mp3'));
        }
      }
      _results[_currentIndex] = isCorrect;
    });

    // Save result to database
    final questionId = _questions[_currentIndex].id;
    if (questionId != null) {
      _dbHelper.saveQuestionResult(questionId, isCorrect);
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedOptionIndex = null;
          _isAnswered = false;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              totalQuestions: _questions.length,
              correctAnswers: _score,
              limit: widget.limit,
              isShuffle: widget.isShuffle,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Test')),
        body: Center(
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
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.backToHome),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '${l10n.question} ${_currentIndex + 1} / ${_questions.length}',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: Text(
                      question.text,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                  ),
                  if (_isAnswered &&
                      !_questions[_currentIndex]
                          .options[_selectedOptionIndex!]
                          .isCorrect)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedAiIdea,
                          color: Colors.amber,
                          size: 28,
                        ),
                        onPressed: _showExplanation,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: question.options.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  Color cardColor = Theme.of(
                    context,
                  ).colorScheme.surfaceContainerLow;
                  Color borderColor = Theme.of(
                    context,
                  ).colorScheme.outlineVariant;
                  List<List<dynamic>>? iconData;

                  if (_isAnswered) {
                    if (option.isCorrect) {
                      cardColor = Colors.green[50]!;
                      borderColor = Colors.green;
                      iconData = HugeIcons.strokeRoundedCheckmarkCircle01;
                    } else if (_selectedOptionIndex == index) {
                      cardColor = Colors.red[50]!;
                      borderColor = Colors.red;
                      iconData = HugeIcons.strokeRoundedCancel01;
                    }
                  } else if (_selectedOptionIndex == index) {
                    borderColor = Theme.of(context).colorScheme.primary;
                  }

                  return InkWell(
                    onTap: () => _answerQuestion(index),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              option.text,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (iconData != null)
                            HugeIcon(icon: iconData, color: borderColor),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      totalQuestions: _questions.length,
                      correctAnswers: _score,
                      limit: widget.limit,
                      isShuffle: widget.isShuffle,
                    ),
                  ),
                );
              },
              child: Text(l10n.finishTest),
            ),
          ],
        ),
      ),
    );
  }
}
