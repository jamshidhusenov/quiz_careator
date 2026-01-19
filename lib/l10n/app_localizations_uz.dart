// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get loginTitle => 'Xush kelibsiz!';

  @override
  String get loginSubtitle => 'Tizimga kirish uchun ma\'lumotlarni kiriting';

  @override
  String get loginButton => 'Kirish';

  @override
  String get loginField => 'Login';

  @override
  String get passwordField => 'Parol';

  @override
  String get homeTitle => 'Quiz Creator';

  @override
  String get addQuestion => 'Yangi savol qo\'shish';

  @override
  String get solveQuiz => 'Test ishlash';

  @override
  String get viewQuestions => 'Savollarni ko\'rish';

  @override
  String get quizConfig => 'Test sozlamalari';

  @override
  String get questionCount => 'Savollar soni';

  @override
  String get shuffleOptions => 'Variantlarni aralashtirish';

  @override
  String get startQuiz => 'Testni boshlash';

  @override
  String questionsFound(int count) {
    return '$count ta savol topildi';
  }

  @override
  String get noQuestions => 'Savollar topilmadi';

  @override
  String get correct => 'To\'g\'ri';

  @override
  String get incorrect => 'Noto\'g\'ri';

  @override
  String get score => 'Natija';

  @override
  String get backToHome => 'Bosh sahifaga qaytish';

  @override
  String get save => 'Saqlash';

  @override
  String get import => 'Import';

  @override
  String get export => 'Export';

  @override
  String get clearAll => 'Tozalash';

  @override
  String get questionsList => 'Savollar ro\'yxati';

  @override
  String get explanation => 'Tushuntirish';

  @override
  String get copied => 'Nusxalandi!';

  @override
  String get copyTemplate => 'Nusxa olish';

  @override
  String get templateFormat =>
      'Savol va javoblarni quyidagi formatda kiriting:';

  @override
  String get pasteHint => 'Shu yerga textni paste qiling...';

  @override
  String get question => 'Savol';

  @override
  String get noExplanation =>
      'Bu savol bo\'yicha hozircha tushuntirish mavjud emas.';

  @override
  String get ok => 'Tushunarli';

  @override
  String get questions => 'savol';

  @override
  String get successMessage => 'Barakalla!';

  @override
  String get failureMessage => 'Yana harakat qiling!';

  @override
  String get retryQuiz => 'Test ishlashda davom etish';

  @override
  String get allQuestions => 'Barcha savollar';

  @override
  String get from => 'Dan';

  @override
  String get to => 'Gacha';

  @override
  String get questionGrid => 'Savollar tartibi';

  @override
  String get rangeSelection => 'Oraliqni tanlash';

  @override
  String get randomQuestions => 'Random savollar';

  @override
  String get finishTest => 'Testni tugatish';
}
