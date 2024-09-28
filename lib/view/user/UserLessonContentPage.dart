import 'package:flutter/material.dart';

class UserLessonContentPage extends StatefulWidget {
  final String subjectTitle;
  final String subjectContent;

  const UserLessonContentPage(
      {super.key, required this.subjectTitle, required this.subjectContent});

  @override
  State<UserLessonContentPage> createState() => _UserLessonContentPageState();
}

class _UserLessonContentPageState extends State<UserLessonContentPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[500],
        title: Text(widget.subjectTitle), // Display the lesson title in the AppBar
      ),
      backgroundColor: Colors.green[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the lesson title
            Text(
              widget.subjectTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Display the lesson content
            Text(
              widget.subjectTitle,
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
