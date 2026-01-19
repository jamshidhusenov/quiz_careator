import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @loginTitle.
  ///
  /// In uz, this message translates to:
  /// **'Xush kelibsiz!'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Tizimga kirish uchun ma\'lumotlarni kiriting'**
  String get loginSubtitle;

  /// No description provided for @loginButton.
  ///
  /// In uz, this message translates to:
  /// **'Kirish'**
  String get loginButton;

  /// No description provided for @loginField.
  ///
  /// In uz, this message translates to:
  /// **'Login'**
  String get loginField;

  /// No description provided for @passwordField.
  ///
  /// In uz, this message translates to:
  /// **'Parol'**
  String get passwordField;

  /// No description provided for @homeTitle.
  ///
  /// In uz, this message translates to:
  /// **'Quiz Creator'**
  String get homeTitle;

  /// No description provided for @addQuestion.
  ///
  /// In uz, this message translates to:
  /// **'Yangi savol qo\'shish'**
  String get addQuestion;

  /// No description provided for @solveQuiz.
  ///
  /// In uz, this message translates to:
  /// **'Test ishlash'**
  String get solveQuiz;

  /// No description provided for @viewQuestions.
  ///
  /// In uz, this message translates to:
  /// **'Savollarni ko\'rish'**
  String get viewQuestions;

  /// No description provided for @quizConfig.
  ///
  /// In uz, this message translates to:
  /// **'Test sozlamalari'**
  String get quizConfig;

  /// No description provided for @questionCount.
  ///
  /// In uz, this message translates to:
  /// **'Savollar soni'**
  String get questionCount;

  /// No description provided for @shuffleOptions.
  ///
  /// In uz, this message translates to:
  /// **'Variantlarni aralashtirish'**
  String get shuffleOptions;

  /// No description provided for @startQuiz.
  ///
  /// In uz, this message translates to:
  /// **'Testni boshlash'**
  String get startQuiz;

  /// No description provided for @questionsFound.
  ///
  /// In uz, this message translates to:
  /// **'{count} ta savol topildi'**
  String questionsFound(int count);

  /// No description provided for @noQuestions.
  ///
  /// In uz, this message translates to:
  /// **'Savollar topilmadi'**
  String get noQuestions;

  /// No description provided for @correct.
  ///
  /// In uz, this message translates to:
  /// **'To\'g\'ri'**
  String get correct;

  /// No description provided for @incorrect.
  ///
  /// In uz, this message translates to:
  /// **'Noto\'g\'ri'**
  String get incorrect;

  /// No description provided for @score.
  ///
  /// In uz, this message translates to:
  /// **'Natija'**
  String get score;

  /// No description provided for @backToHome.
  ///
  /// In uz, this message translates to:
  /// **'Bosh sahifaga qaytish'**
  String get backToHome;

  /// No description provided for @save.
  ///
  /// In uz, this message translates to:
  /// **'Saqlash'**
  String get save;

  /// No description provided for @import.
  ///
  /// In uz, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @export.
  ///
  /// In uz, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @clearAll.
  ///
  /// In uz, this message translates to:
  /// **'Tozalash'**
  String get clearAll;

  /// No description provided for @questionsList.
  ///
  /// In uz, this message translates to:
  /// **'Savollar ro\'yxati'**
  String get questionsList;

  /// No description provided for @explanation.
  ///
  /// In uz, this message translates to:
  /// **'Tushuntirish'**
  String get explanation;

  /// No description provided for @copied.
  ///
  /// In uz, this message translates to:
  /// **'Nusxalandi!'**
  String get copied;

  /// No description provided for @copyTemplate.
  ///
  /// In uz, this message translates to:
  /// **'Nusxa olish'**
  String get copyTemplate;

  /// No description provided for @templateFormat.
  ///
  /// In uz, this message translates to:
  /// **'Savol va javoblarni quyidagi formatda kiriting:'**
  String get templateFormat;

  /// No description provided for @pasteHint.
  ///
  /// In uz, this message translates to:
  /// **'Shu yerga textni paste qiling...'**
  String get pasteHint;

  /// No description provided for @question.
  ///
  /// In uz, this message translates to:
  /// **'Savol'**
  String get question;

  /// No description provided for @noExplanation.
  ///
  /// In uz, this message translates to:
  /// **'Bu savol bo\'yicha hozircha tushuntirish mavjud emas.'**
  String get noExplanation;

  /// No description provided for @ok.
  ///
  /// In uz, this message translates to:
  /// **'Tushunarli'**
  String get ok;

  /// No description provided for @questions.
  ///
  /// In uz, this message translates to:
  /// **'savol'**
  String get questions;

  /// No description provided for @successMessage.
  ///
  /// In uz, this message translates to:
  /// **'Barakalla!'**
  String get successMessage;

  /// No description provided for @failureMessage.
  ///
  /// In uz, this message translates to:
  /// **'Yana harakat qiling!'**
  String get failureMessage;

  /// No description provided for @retryQuiz.
  ///
  /// In uz, this message translates to:
  /// **'Test ishlashda davom etish'**
  String get retryQuiz;

  /// No description provided for @allQuestions.
  ///
  /// In uz, this message translates to:
  /// **'Barcha savollar'**
  String get allQuestions;

  /// No description provided for @from.
  ///
  /// In uz, this message translates to:
  /// **'Dan'**
  String get from;

  /// No description provided for @to.
  ///
  /// In uz, this message translates to:
  /// **'Gacha'**
  String get to;

  /// No description provided for @questionGrid.
  ///
  /// In uz, this message translates to:
  /// **'Savollar tartibi'**
  String get questionGrid;

  /// No description provided for @rangeSelection.
  ///
  /// In uz, this message translates to:
  /// **'Oraliqni tanlash'**
  String get rangeSelection;

  /// No description provided for @randomQuestions.
  ///
  /// In uz, this message translates to:
  /// **'Random savollar'**
  String get randomQuestions;

  /// No description provided for @finishTest.
  ///
  /// In uz, this message translates to:
  /// **'Testni tugatish'**
  String get finishTest;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
