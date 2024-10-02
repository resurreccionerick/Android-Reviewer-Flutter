import 'package:android_reviewer_flutter/model/QuizModel.dart';
import 'package:android_reviewer_flutter/viewmodel/AppViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  final String subjectID;

  QuizScreen({super.key, required this.subjectID});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0; // Track the current question
  int correctAnswersCount = 0; // Track the correct answers
  String? selectedAnswer; // Store selected answer
  bool isQuizFinished = false; // Check if quiz is finished

  @override
  Widget build(BuildContext context) {
    // Access ViewModel data using Provider
    final appViewModel = Provider.of<AppViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
        backgroundColor: Colors.green[600],
      ),
      body: StreamBuilder<List<QuizModel>>(
        stream: appViewModel.getQuizzes(widget.subjectID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching quizzes'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final quizzes = snapshot.data!;

          if (isQuizFinished) {
            // Save the score when quiz is finished
            saveQuizScore(appViewModel, correctAnswersCount, quizzes.length);
            // Show Snackbar with the result
            Future.delayed(Duration.zero, () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'You got $correctAnswersCount out of ${quizzes.length} correct!',
                  ),
                ),
              );
              // Close the page after showing the result
              Navigator.pop(context);
            });
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display the question
                  Text(
                    'Question ${currentQuestionIndex + 1}:',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    quizzes[currentQuestionIndex].question,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Display the options
                  for (var option in quizzes[currentQuestionIndex].options)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: getOptionColor(option, quizzes[currentQuestionIndex]),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: selectedAnswer,
                        onChanged: (value) {
                          setState(() {
                            selectedAnswer = value;
                            // Check if the selected answer is correct
                            if (value == quizzes[currentQuestionIndex].correctAns) {
                              correctAnswersCount++;
                            }
                          });
                        },
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Button to go to the next question or submit quiz
                  ElevatedButton(
                    onPressed: selectedAnswer == null
                        ? null // Disable button if no answer is selected
                        : () {
                      if (currentQuestionIndex < quizzes.length - 1) {
                        // Move to the next question
                        setState(() {
                          currentQuestionIndex++;
                          selectedAnswer = null; // Reset selected answer
                        });
                      } else {
                        // Finish the quiz
                        setState(() {
                          isQuizFinished = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      currentQuestionIndex < quizzes.length - 1
                          ? "Next Question"
                          : "Submit Quiz",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Get the color for the option based on correctness
  Color? getOptionColor(String option, QuizModel quiz) {
    if (selectedAnswer == null) return null; // No color if no answer selected

    if (option == quiz.correctAns) {
      return Colors.green[400]; // Correct answer
    } else if (option == selectedAnswer) {
      return Colors.red[400]; // Selected incorrect answer
    }

    return null; // Default color
  }

  // Save the quiz score to the database
  void saveQuizScore(AppViewModel appViewModel, int correctAnswers, int totalQuestions) {
    appViewModel.saveScore(widget.subjectID, correctAnswers, totalQuestions);
  }
}
