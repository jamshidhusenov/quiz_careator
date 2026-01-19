// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get loginTitle => 'Добро пожаловать!';

  @override
  String get loginSubtitle => 'Введите данные для входа в систему';

  @override
  String get loginButton => 'Войти';

  @override
  String get loginField => 'Логин';

  @override
  String get passwordField => 'Пароль';

  @override
  String get homeTitle => 'Quiz Creator';

  @override
  String get addQuestion => 'Добавить новый вопрос';

  @override
  String get solveQuiz => 'Пройти тест';

  @override
  String get viewQuestions => 'Просмотреть вопросы';

  @override
  String get quizConfig => 'Настройки теста';

  @override
  String get questionCount => 'Количество вопросов';

  @override
  String get shuffleOptions => 'Перемешать варианты';

  @override
  String get startQuiz => 'Начать тест';

  @override
  String questionsFound(int count) {
    return 'Найдено вопросов: $count';
  }

  @override
  String get noQuestions => 'Вопросы не найдены';

  @override
  String get correct => 'Правильно';

  @override
  String get incorrect => 'Неправильно';

  @override
  String get score => 'Результат';

  @override
  String get backToHome => 'Вернуться на главную';

  @override
  String get save => 'Сохранить';

  @override
  String get import => 'Импорт';

  @override
  String get export => 'Экспорт';

  @override
  String get clearAll => 'Очистить';

  @override
  String get questionsList => 'Список вопросов';

  @override
  String get explanation => 'Объяснение';

  @override
  String get copied => 'Скопировано!';

  @override
  String get copyTemplate => 'Копировать';

  @override
  String get templateFormat => 'Введите вопросы и ответы в следующем формате:';

  @override
  String get pasteHint => 'Вставьте текст сюда...';

  @override
  String get question => 'Вопрос';

  @override
  String get noExplanation => 'Для этого вопроса пока нет объяснения.';

  @override
  String get ok => 'Понятно';

  @override
  String get questions => 'вопросов';

  @override
  String get successMessage => 'Молодец!';

  @override
  String get failureMessage => 'Попробуйте еще раз!';

  @override
  String get retryQuiz => 'Продолжить тест';

  @override
  String get allQuestions => 'Все вопросы';

  @override
  String get from => 'От';

  @override
  String get to => 'До';

  @override
  String get questionGrid => 'Навигатор вопросов';

  @override
  String get rangeSelection => 'Выбор диапазона';

  @override
  String get randomQuestions => 'Случайные вопросы';

  @override
  String get finishTest => 'Завершить тест';
}
