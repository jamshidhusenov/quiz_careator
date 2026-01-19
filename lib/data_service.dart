import 'models.dart';

class DataService {
  /// Converts a string of text into a list of Questions.
  /// Uses '++++' as question separator and '====' as option separator.
  /// Options starting with '#' are considered correct.
  static List<Question> parseQuestions(String text) {
    List<String> questionBlocks = text
        .split('++++')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    List<Question> questions = [];

    for (String block in questionBlocks) {
      List<String> parts = block
          .split('====')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (parts.length < 2) continue;

      String questionText = parts[0];
      List<Option> options = [];

      for (int i = 1; i < parts.length; i++) {
        String optionText = parts[i];
        bool isCorrect = optionText.startsWith('#');
        if (isCorrect) {
          optionText = optionText.substring(1).trim();
        }
        options.add(Option(text: optionText, isCorrect: isCorrect));
      }

      if (options.any((o) => o.isCorrect)) {
        questions.add(Question(text: questionText, options: options));
      }
    }

    return questions;
  }

  /// Converts a list of Questions into the custom text format.
  static String formatQuestions(List<Question> questions) {
    List<String> blocks = [];

    for (var question in questions) {
      List<String> parts = [question.text];
      for (var option in question.options) {
        parts.add(option.isCorrect ? '# ${option.text}' : option.text);
      }
      blocks.add(parts.join('\n====\n'));
    }

    return blocks.join('\n++++\n');
  }
}
