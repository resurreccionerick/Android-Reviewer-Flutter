import 'package:android_reviewer_flutter/model/QuizModel.dart';
import 'package:android_reviewer_flutter/viewmodel/AppViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AddQuizScreen extends StatefulWidget {
  final String subjectID;
  final String lessonID;

  const AddQuizScreen({required this.subjectID, required this.lessonID, Key? key}) : super(key: key);

  @override
  _AddQuizScreenState createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  String question = '';
  List<String> options = ['', '', '', ''];
  String correctAnswer = '';

  @override
  Widget build(BuildContext context) {
    final appViewModel = Provider.of<AppViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Quiz question input
              TextFormField(
                decoration: const InputDecoration(labelText: 'Question'),
                onChanged: (value) {
                  question = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              // Options input (Multiple choices)
              ...List.generate(4, (index) {
                return TextFormField(
                  decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                  onChanged: (value) {
                    options[index] = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter option ${index + 1}';
                    }
                    return null;
                  },
                );
              }),
              // Correct answer input
              TextFormField(
                decoration: const InputDecoration(labelText: 'Correct Answer'),
                onChanged: (value) {
                  correctAnswer = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the correct answer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Submit button to add quiz
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Add the quiz using the ViewModel
                    appViewModel.addQuiz(
                      widget.subjectID,
                      QuizModel(
                        id: widget.subjectID,
                        question: question,
                        options: options,
                        correctAns: correctAnswer,
                      ),
                    ).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Quiz added successfully!')),
                      );
                      Navigator.pop(context); // Return to previous screen
                    });
                  }
                },
                child: const Text('Add Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
