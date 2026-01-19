import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_creator/l10n/app_localizations.dart';
import 'quiz_page.dart';

class ResultPage extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int limit;
  final bool isShuffle;

  const ResultPage({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.limit,
    required this.isShuffle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    double percentage = totalQuestions > 0
        ? (correctAnswers / totalQuestions) * 100
        : 0;
    bool isSuccess = percentage >= 60;

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSuccess)
              Lottie.asset(
                'assets/icon/Success celebration.json',
                height: 200,
                repeat: true,
              ),
            Text(
              l10n.score,
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Column(
                children: [
                  Text(
                    '${percentage.toInt()}%',
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '$correctAnswers / $totalQuestions',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isSuccess ? l10n.successMessage : l10n.failureMessage,
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 60),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedHome01,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(l10n.backToHome),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizPage(limit: limit, isShuffle: isShuffle),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    foregroundColor: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedPlay,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  label: Text(l10n.retryQuiz),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
