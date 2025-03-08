// screens/quiz_screen.dart
import 'package:flutter/material.dart';
import '../models/question.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String title;

  const QuizScreen({super.key, required this.questions, required this.title});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Map to store user answers for each question
  Map<int, String> userAnswers = {};

  // Map to store feedback status for each question
  Map<int, bool> questionChecked = {};

  // Map to store whether answer was correct
  Map<int, bool> isCorrect = {};

  // Controllers for text fields
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    // Initialize controllers for each question
    controllers =
        List.generate(widget.questions.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Check individual answer
  void checkAnswer(int index) {
    final userAnswer = controllers[index].text.trim().toLowerCase();
    final correctAnswer = widget.questions[index].answer.toLowerCase();

    setState(() {
      userAnswers[index] = userAnswer;
      questionChecked[index] = true;
      isCorrect[index] = (userAnswer == correctAnswer);
    });
  }

  // Calculate results
  int getCorrectAnswersCount() {
    int count = 0;
    isCorrect.forEach((_, value) {
      if (value) count++;
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Results summary at top
          if (questionChecked.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey.shade200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Score: ${getCorrectAnswersCount()}/${questionChecked.length} checked',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

          // List of questions
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.questions.length,
              itemBuilder: (context, index) {
                final question = widget.questions[index];
                final isChecked = questionChecked[index] ?? false;
                final answerCorrect = isCorrect[index] ?? false;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question text
                        Text(
                          'Q${index + 1}: ${question.question}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        // Answer input field
                        TextField(
                          controller: controllers[index],
                          decoration: InputDecoration(
                            labelText: 'Your Answer',
                            border: const OutlineInputBorder(),
                            enabled: !isChecked,
                          ),
                          enabled: !isChecked,
                        ),

                        const SizedBox(height: 12),

                        // Submit button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed:
                                  isChecked ? null : () => checkAnswer(index),
                              child: const Text('Submit'),
                            ),
                          ],
                        ),

                        // Feedback message (only shown if checked)
                        if (isChecked)
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: answerCorrect
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  answerCorrect
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color: answerCorrect
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    answerCorrect
                                        ? 'Correct!'
                                        : 'Wrong. The correct answer is: ${question.answer}',
                                    style: TextStyle(
                                      color: answerCorrect
                                          ? Colors.green.shade800
                                          : Colors.red.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
