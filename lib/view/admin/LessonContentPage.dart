import 'package:flutter/material.dart';
import '../../model/LessonModel.dart';

class LessonContentPage extends StatelessWidget {
  final LessonModel lesson;

  // Constructor to receive the lesson data
  LessonContentPage({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
       // title: Text(lesson.title), // Display the lesson title in the AppBar
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Wrap the body with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the lesson title
            Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Display the lesson content
            Text(
              lesson.content, // Update this to use subjectContent instead of subjectTitle
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}