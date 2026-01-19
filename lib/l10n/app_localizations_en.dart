// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Welcome!';

  @override
  String get loginSubtitle => 'Enter your details to log in';

  @override
  String get loginButton => 'Login';

  @override
  String get loginField => 'Login';

  @override
  String get passwordField => 'Password';

  @override
  String get homeTitle => 'Quiz Creator';

  @override
  String get addQuestion => 'Add New Question';

  @override
  String get solveQuiz => 'Take a Quiz';

  @override
  String get viewQuestions => 'View Questions';

  @override
  String get quizConfig => 'Quiz Settings';

  @override
  String get questionCount => 'Number of Questions';

  @override
  String get shuffleOptions => 'Shuffle Options';

  @override
  String get startQuiz => 'Start Quiz';

  @override
  String questionsFound(int count) {
    return '$count questions found';
  }

  @override
  String get noQuestions => 'No questions found';

  @override
  String get correct => 'Correct';

  @override
  String get incorrect => 'Incorrect';

  @override
  String get score => 'Score';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get save => 'Save';

  @override
  String get import => 'Import';

  @override
  String get export => 'Export';

  @override
  String get clearAll => 'Clear All';

  @override
  String get questionsList => 'Questions List';

  @override
  String get explanation => 'Explanation';

  @override
  String get copied => 'Copied!';

  @override
  String get copyTemplate => 'Copy Template';

  @override
  String get templateFormat =>
      'Enter questions and answers in the following format:';

  @override
  String get pasteHint => 'Paste text here...';

  @override
  String get question => 'Question';

  @override
  String get noExplanation => 'No explanation available for this question.';

  @override
  String get ok => 'OK';

  @override
  String get questions => 'Questions';

  @override
  String get successMessage => 'Well done!';

  @override
  String get failureMessage => 'Try again!';

  @override
  String get retryQuiz => 'Retry Quiz';

  @override
  String get allQuestions => 'All Questions';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get questionGrid => 'Question Navigator';

  @override
  String get rangeSelection => 'Select Range';

  @override
  String get randomQuestions => 'Random Questions';

  @override
  String get finishTest => 'Finish Test';
}
