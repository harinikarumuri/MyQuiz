// models/category.dart
import 'package:myquiz/models/question.dart';

class Category {
  final String name;
  final List<SubCategory> subCategories;

  Category({required this.name, required this.subCategories});
}

class SubCategory {
  final String name;
  final List<SubSubCategory> subSubCategories;
  final List<Question> questions;
  SubCategory({
    required this.name,
    required this.subSubCategories,
    required this.questions,
  });
  bool get hasDirectQuestions => questions.isNotEmpty;
}

class SubSubCategory {
  final String name;
  final List<Question> questions;

  SubSubCategory({required this.name, required this.questions});
}
