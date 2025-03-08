// services/quiz_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/question.dart';
import '../models/category.dart';

class QuizService {
  // Replace with your Google Apps Script Web App URL
  final String apiUrl =
      'https://script.google.com/macros/s/AKfycbxg6w3NcrGX1QjS0AI8XhOKKvRY-vdkUNVXGTLW20GpRxq8qwQShuio2BBS24ZaWzsTqQ/exec';

  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse JSON response
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          // Get the categories array
          final List<dynamic> categoriesList = jsonData['data'];

          // Process each category
          List<Category> categories = [];

          for (var categoryData in categoriesList) {
            String categoryName = categoryData['name'];
            List<dynamic> questionsList = categoryData['questions'];

            // Convert to Question objects
            List<Question> allQuestions =
                questionsList.map((q) => Question.fromJson(q)).toList();

            // Organize questions into subcategories and sub-subcategories
            Category category = _organizeCategory(categoryName, allQuestions);
            categories.add(category);
          }

          return categories;
        } else {
          throw Exception('API returned error status');
        }
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }

  // Organize questions for a single category
  Category _organizeCategory(String categoryName, List<Question> questions) {
    Map<String, Map<String, List<Question>>> structure = {};
    Map<String, List<Question>> directQuestions = {};

    // First, organize questions into nested maps
    for (var question in questions) {
      // Check if the sub-subcategory is empty
      bool hasSubSubCategory = question.subsubcategory.trim().isNotEmpty;

      // Initialize subcategory if it doesn't exist
      if (!structure.containsKey(question.subcategory)) {
        structure[question.subcategory] = {};
      }

      // Initialize direct questions maps if needed
      if (!directQuestions.containsKey(question.subcategory)) {
        directQuestions[question.subcategory] = [];
      }

      // Handle direct questions (without sub-subcategory)
      if (!hasSubSubCategory) {
        // Add to direct questions
        directQuestions[question.subcategory]!.add(question);
      } else {
        // Normal case with a sub-subcategory
        if (!structure[question.subcategory]!
            .containsKey(question.subsubcategory)) {
          structure[question.subcategory]![question.subsubcategory] = [];
        }

        // Add question to appropriate sub-subcategory
        structure[question.subcategory]![question.subsubcategory]!
            .add(question);
      }
    }

    // Convert nested maps to object hierarchy
    List<SubCategory> subCategories = [];

    structure.forEach((subCategoryName, subSubCategoryMap) {
      List<SubSubCategory> subSubCategories = [];

      subSubCategoryMap.forEach((subSubCategoryName, questions) {
        subSubCategories.add(SubSubCategory(
          name: subSubCategoryName,
          questions: questions,
        ));
      });

      // Get any direct questions for this subcategory
      List<Question> directSubCatQuestions =
          directQuestions[subCategoryName] ?? [];

      subCategories.add(SubCategory(
        name: subCategoryName,
        subSubCategories: subSubCategories,
        questions: directSubCatQuestions,
      ));
    });

    return Category(
      name: categoryName,
      subCategories: subCategories,
    );
  }
}
