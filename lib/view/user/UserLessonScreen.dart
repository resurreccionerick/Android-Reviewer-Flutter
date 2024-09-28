import 'package:android_reviewer_flutter/view/admin/LessonContentPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/LessonModel.dart';
import '../../viewmodel/AppViewModel.dart';
import 'QuizScreen.dart';

class UserLessonScreen extends StatelessWidget {
  final String subjectID;
  final String subjectName;

  UserLessonScreen(
      {super.key, required this.subjectName, required this.subjectID});

  @override
  Widget build(BuildContext context) {
    final appViewModel = Provider.of<AppViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Lessons"),
          backgroundColor: Colors.green[500],
        ),
        backgroundColor: Colors.green[200],
        body: StreamBuilder<List<LessonModel>>(
          stream: appViewModel.getLesson(subjectID),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error fetching lessons'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final lessons = snapshot.data!;

            return ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];

                return ListTile(
                  title: Text(lesson.title),
                  subtitle: Text(lesson.content),
                  onTap: () {
                    // Navigate to lesson content page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonContentPage(lesson: lesson),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuizScreen(subjectID: subjectID)));
            },
            child: const Text("Take Quiz"))
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     // Navigate to quiz screen when the button is pressed
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => QuizScreen(subjectID: subjectID),
        //       ),
        //     );
        //   },
        //   child: const Icon(Icons.quiz),
        // ),
        );
  }
}
