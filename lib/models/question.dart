// models/question.dart
class Question {
  final String question;
  final String answer;
  final String category;
  final String subcategory;
  final String subsubcategory;

  Question({
    required this.question,
    required this.answer,
    required this.category,
    required this.subcategory,
    required this.subsubcategory,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      // The key names match what's in your Google Sheets
      question: _ensureString(json['Question']),
      answer: _ensureString(json['Answer']),
      category: _ensureString(json['Category']),
      subcategory: _ensureString(json['SubCategory'] ?? ''),
      subsubcategory: _ensureString(json['SubSubCategory'] ?? ''),
    );
  }

  // Helper method to ensure any value is converted to a string
  static String _ensureString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }
}
