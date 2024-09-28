class SubjectModel {
  String id;
  String subjectName;

//constructor
  SubjectModel({required this.id, required this.subjectName});

  // Convert Firebase DocumentSnapshot to Subject object
  factory SubjectModel.fromDocument(Map<String, dynamic> doc, String docID) {
    return SubjectModel(id: docID, subjectName: doc['subjectName']);
  }

  //convert subj object to map for firestore storage
  Map<String, dynamic> toMap() {
    return {
      'subjectName': subjectName,
    };
  }
}
