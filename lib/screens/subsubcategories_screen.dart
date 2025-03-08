// screens/subsubcategories_screen.dart
import 'package:flutter/material.dart';
import '../models/category.dart';
import 'quiz_screen.dart';

class SubSubCategoriesScreen extends StatelessWidget {
  final SubCategory subCategory;

  const SubSubCategoriesScreen({super.key, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subCategory.name),
      ),
      body: ListView.builder(
        itemCount: subCategory.subSubCategories.length,
        itemBuilder: (context, index) {
          final subSubCategory = subCategory.subSubCategories[index];
          final questionCount = subSubCategory.questions.length;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                subSubCategory.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('$questionCount questions'),
              trailing: const Icon(Icons.play_arrow),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(
                      questions: subSubCategory.questions,
                      title: subSubCategory.name,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
