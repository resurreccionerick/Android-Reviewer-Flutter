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
     //   title: Text(lesson.title), // Display the lesson title in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the lesson title
            Text(
              lesson.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Display the lesson content
            Text(
              lesson.content,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
