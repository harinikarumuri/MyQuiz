// screens/subcategories_screen.dart
import 'package:flutter/material.dart';
import '../models/category.dart';
import 'subsubcategories_screen.dart';
import 'quiz_screen.dart'; // Don't forget to import this

class SubCategoriesScreen extends StatelessWidget {
  final Category category;

  const SubCategoriesScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListView.builder(
        itemCount: category.subCategories.length,
        itemBuilder: (context, index) {
          final subCategory =
              category.subCategories[index]; // Store reference for cleaner code
          final hasDirectQuestions = subCategory
              .hasDirectQuestions; // Check if it has direct questions
          final totalQuestions = _countQuestionsInSubCategory(subCategory);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                subCategory.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('$totalQuestions questions'),
              trailing: hasDirectQuestions &&
                      subCategory.subSubCategories.isEmpty
                  ? const Icon(Icons
                      .play_arrow) // Show play icon if there are only direct questions
                  : const Icon(Icons.chevron_right),
              onTap: () {
                // If there are only direct questions and no sub-subcategories, go straight to quiz
                if (hasDirectQuestions &&
                    subCategory.subSubCategories.isEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        questions: subCategory.questions,
                        title: subCategory.name,
                      ),
                    ),
                  );
                } else {
                  // Otherwise go to sub-subcategories screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubSubCategoriesScreen(
                        subCategory: subCategory,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }

  int _countQuestionsInSubCategory(SubCategory subCategory) {
    int count = subCategory.questions.length; // Count direct questions

    // Add questions from sub-subcategories
    for (var subSubCategory in subCategory.subSubCategories) {
      count += subSubCategory.questions.length;
    }

    return count;
  }
}
