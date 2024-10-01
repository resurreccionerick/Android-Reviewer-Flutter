import 'package:android_reviewer_flutter/model/LessonModel.dart';
import 'package:android_reviewer_flutter/viewmodel/AppViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'AddQuizScreen.dart';
import 'LessonContentPage.dart';

class LessonScreen extends StatelessWidget {
  final String subjectID;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  LessonScreen({super.key, required this.subjectID});

  @override
  Widget build(BuildContext context) {
    final appViewModel = Provider.of<AppViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lesson"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'add_lesson') {
                showAddLessonDialog(context, appViewModel);
              } else if (value == 'add_quiz') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddQuizScreen(subjectID: subjectID),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'add_lesson',
                  child: Row(
                    children: [
                      Icon(Icons.library_add, color: Colors.black),
                      SizedBox(width: 8),
                      Text("Add Lesson"),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'add_quiz',
                  child: Row(
                    children: [
                      Icon(Icons.quiz, color: Colors.black),
                      SizedBox(width: 8),
                      Text("Add Quiz"),
                    ],
                  ),
                ),
              ];
            },
          )
        ],
      ),
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
                  // subtitle: Text(lesson.content),
                  onTap: () {
                    //navigate to lesson content page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LessonContentPage(lesson: lesson)));
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () => showDeleteLessonConfirmationDialog(
                              context, appViewModel, subjectID, lesson),
                          // appViewModel.deleteLesson(subjectID, lesson),
                          icon: const Icon(Icons.delete)),
                      IconButton(
                          onPressed: () =>
                              showUpdateDialog(context, appViewModel, lesson),
                          icon: const Icon(Icons.edit)),
                    ],
                  ));
            },
          );
        },
      ),
    );
  }

  showAddLessonDialog(BuildContext context, AppViewModel appViewModel) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Lesson"),
            content: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "Title"),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(hintText: "Content"),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        contentController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please enter all fields!"),
                      ));
                    } else {
                      final newLesson = LessonModel(
                          id: '',
                          title: titleController.text,
                          content: contentController.text);
                      appViewModel.addLesson(subjectID, newLesson);
                      titleController.clear();
                      contentController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add"))
            ],
          );
        });
  }

  showUpdateDialog(
      BuildContext context, AppViewModel appViewModel, LessonModel lesson) {
    titleController.text = lesson.title;
    contentController.text = lesson.content;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update Lesson"),
            content: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "Title"),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(hintText: "Content"),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        contentController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please enter all fields!"),
                      ));
                    } else {
                      final newLesson = LessonModel(
                          id: lesson.id,
                          title: titleController.text,
                          content: contentController.text);
                      appViewModel.updateLesson(subjectID, newLesson);
                      titleController.clear();
                      contentController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Update"))
            ],
          );
        });
  }

  void showDeleteLessonConfirmationDialog(BuildContext context,
      AppViewModel appViewModel, String lessonId, LessonModel lesson) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Lesson Confirmation"),
          content: const Text(
              "Are you sure you want to delete this lesson? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                appViewModel.deleteLesson(lessonId, lesson);
                Navigator.pop(context);
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
