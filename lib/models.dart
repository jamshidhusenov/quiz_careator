class Question {
  final int? id;
  final String text;
  final List<Option> options;

  Question({this.id, required this.text, required this.options});

  Map<String, dynamic> toMap() {
    return {'id': id, 'text': text};
  }

  factory Question.fromMap(Map<String, dynamic> map, List<Option> options) {
    return Question(id: map['id'], text: map['text'], options: options);
  }
}

class Option {
  final int? id;
  final int? questionId;
  final String text;
  final bool isCorrect;

  Option({
    this.id,
    this.questionId,
    required this.text,
    required this.isCorrect,
  });

  Map<String, dynamic> toMap(int questionId) {
    return {
      'id': id,
      'question_id': questionId,
      'text': text,
      'is_correct': isCorrect ? 1 : 0,
    };
  }

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      id: map['id'],
      questionId: map['question_id'],
      text: map['text'],
      isCorrect: map['is_correct'] == 1,
    );
  }
}
