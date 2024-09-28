class QuizModel {
  String id;
  String question;
  List<String> options;
  String correctAns;

  QuizModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAns
  });

  //convert quiz object to map to store in firebase
  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'question' : question,
      'options' : options,
      'correctAnswer' : correctAns,
    };
  }

   // Create a Quiz object from FireStore data
   factory QuizModel.fromDocument(Map<String, dynamic> data, String id){
    return QuizModel(id: id,  question: data['question'], options: List<String>.from(data['options']), correctAns: data['correctAnswer']);
   }


}