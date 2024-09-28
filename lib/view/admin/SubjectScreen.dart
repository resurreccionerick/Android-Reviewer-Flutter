import 'package:android_reviewer_flutter/model/SubjectModel.dart';
import 'package:android_reviewer_flutter/view/admin/LessonScreen.dart';
import 'package:android_reviewer_flutter/viewmodel/AppViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubjectScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  SubjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appViewModel = Provider.of<AppViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Admin Side"),
          backgroundColor: Colors.green[300],
        ),
        body: StreamBuilder<List<SubjectModel>>(
            stream: appViewModel.getSubjects(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error fetching subjects"),
                );
              } else if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final subjects = snapshot.data!;

              return ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return ListTile(
                      title: Text(subject.subjectName),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LessonScreen(subjectID: subject.id)));
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () =>
                                  appViewModel.deleteSubject(subject.id),
                              icon: const Icon(Icons.delete)),
                          IconButton(
                              onPressed: () => showUpdateDialog(
                                  context, appViewModel, subject),
                              icon: const Icon(Icons.edit)),
                        ],
                      ));
                },
              );
            }),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () => showAddDialog(context, appViewModel),
            child: const Icon(Icons.add, color: Colors.white)));
  }

  showAddDialog(BuildContext context, AppViewModel appViewModel) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Subject"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Enter Subject Name"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    final newSubject =
                        SubjectModel(id: '', subjectName: controller.text);
                    appViewModel.addSubject(newSubject);

                    Navigator.pop(context);

                    controller.clear();
                  },
                  child: const Text("Add"))
            ],
          );
        });
  }

  showUpdateDialog(
      BuildContext context, AppViewModel appViewModel, SubjectModel subject) {
    controller.text = subject.subjectName;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update Subject"),
            content: TextField(
              controller: controller,
              decoration:
                  const InputDecoration(hintText: "Enter new subject name"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final updateSubject = SubjectModel(
                      id: subject.id, subjectName: controller.text);

                  appViewModel.updateSubject(updateSubject);

                  Navigator.pop(context);

                  controller.clear();
                },
                child: const Text("Update"),
              )
            ],
          );
        });
  }
}
