import 'package:android_reviewer_flutter/view/user/UserLessonScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Topics Available"),
        backgroundColor: Colors.green[500],
      ),
      backgroundColor: Colors.green[200],
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // Show loading indicator if data is not ready
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // If no subjects found
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No subjects available'));
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                final subjectData = doc.data() as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    title: Text(subjectData['subjectName']),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserLessonScreen(
                                  subjectID: doc.id,
                                  subjectName: subjectData['subjectName'])));
                    },
                  ),
                );
              }).toList(),
            );
          }),

      // Display subjects using Card view
    );
  }
}
