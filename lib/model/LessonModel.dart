class LessonModel {
  String? id; // Lesson ID
  String title; // Lesson title
  String content; // Lesson content

  LessonModel({
    this.id,
    required this.title,
    required this.content,
  });



  // Convert the lesson to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
    };
  }

  // Create a lesson from a Firestore document
  static LessonModel fromDocument(Map<String, dynamic> doc, String id) {
    return LessonModel(
      id: id,
      title: doc['title'],
      content: doc['content'],
    );
  }
}
