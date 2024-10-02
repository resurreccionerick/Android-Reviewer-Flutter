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
       // title: Text(lesson.title), // Display the lesson title in the AppBar
        backgroundColor: Colors.green[600],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
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
              lesson.content,
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
