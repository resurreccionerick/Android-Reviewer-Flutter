import 'package:android_reviewer_flutter/model/QuizModel.dart';
import 'package:android_reviewer_flutter/viewmodel/AppViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddQuizScreen extends StatefulWidget {
  final String subjectID;

  AddQuizScreen({super.key, required this.subjectID});

  @override
  _AddQuizScreenState createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController option1Controller = TextEditingController();
  final TextEditingController option2Controller = TextEditingController();
  final TextEditingController option3Controller = TextEditingController();
  final TextEditingController option4Controller = TextEditingController();

  String? correctAnswer;

  @override
  Widget build(BuildContext context) {
    final appViewModel = Provider.of<AppViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text field for the question
            TextField(
              controller: questionController,
              decoration: const InputDecoration(hintText: "Question"),
            ),
            // Text field for option 1
            TextField(
              controller: option1Controller,
              decoration: const InputDecoration(hintText: "Option 1"),
              onChanged: (value) {
                setState(() {}); // Trigger UI rebuild on text change
              },
            ),
            // Text field for option 2
            TextField(
              controller: option2Controller,
              decoration: const InputDecoration(hintText: "Option 2"),
              onChanged: (value) {
                setState(() {}); // Trigger UI rebuild on text change
              },
            ),
            // Text field for option 3
            TextField(
              controller: option3Controller,
              decoration: const InputDecoration(hintText: "Option 3"),
              onChanged: (value) {
                setState(() {}); // Trigger UI rebuild on text change
              },
            ),
            // Text field for option 4
            TextField(
              controller: option4Controller,
              decoration: const InputDecoration(hintText: "Option 4"),
              onChanged: (value) {
                setState(() {}); // Trigger UI rebuild on text change
              },
            ),

            const SizedBox(height: 20),

            // Dropdown menu for selecting the correct answer
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Correct Answer"),
              value: correctAnswer,
              items: _buildDropdownItems(), // Dynamically built dropdown items
              onChanged: (String? newValue) {
                setState(() {
                  correctAnswer = newValue;
                });
              },
              validator: (value) =>
              value == null ? "Please select the correct answer" : null,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                // Rebuild dropdown to reflect the current input from text fields
                setState(() {});

                if (questionController.text.isEmpty ||
                    option1Controller.text.isEmpty ||
                    option2Controller.text.isEmpty ||
                    option3Controller.text.isEmpty ||
                    option4Controller.text.isEmpty ||
                    correctAnswer == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please fill out all fields"),
                  ));
                } else {
                  // Create a new quiz model and save it through the ViewModel
                  final newQuiz = QuizModel(
                    id: widget.subjectID,
                    question: questionController.text,
                    options: [
                      option1Controller.text,
                      option2Controller.text,
                      option3Controller.text,
                      option4Controller.text,
                    ],
                    correctAns: correctAnswer!, // selected correct answer
                  );
                  appViewModel.addQuiz(widget.subjectID, newQuiz);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Quiz"),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build dropdown items dynamically
  List<DropdownMenuItem<String>> _buildDropdownItems() {
    // Only create dropdown items if all options have non-empty values
    if (option1Controller.text.isEmpty ||
        option2Controller.text.isEmpty ||
        option3Controller.text.isEmpty ||
        option4Controller.text.isEmpty) {
      return [];
    }

    // Create dropdown items using the values entered in the text fields
    return [
      DropdownMenuItem(value: option1Controller.text, child: Text(option1Controller.text)),
      DropdownMenuItem(value: option2Controller.text, child: Text(option2Controller.text)),
      DropdownMenuItem(value: option3Controller.text, child: Text(option3Controller.text)),
      DropdownMenuItem(value: option4Controller.text, child: Text(option4Controller.text)),
    ];
  }
}
