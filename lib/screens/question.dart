import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:ict/helpers/contents.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/size.dart';
class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> _questions = [];
  int currentQuestionIndex = 0;
  Map<String, bool> selectedAnswers = {};
  String cat="";

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final url = Uri.parse('https://quizapi.io/api/v1/questions?apiKey=Gd067JPjOARLehfnqwREAEUq8cJpq0Wsguo3qhzA&limit=20&category=$cat');
    final response = await http.get(url);
    print(response.body);
    try {
      final data = jsonDecode(response.body) as List<dynamic>;
      _questions = data.map((questionData) => Question.fromJson(questionData)).toList();
      setState(() {});
    } catch (e) {
      print('Error decoding JSON: $e');
    }
  }
  void _showTextFieldPopup() {
    showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
      title: Text("Search Topics",style: TextStyle(fontFamily: "Main",fontSize:getSize(context, 2.5),fontWeight: FontWeight.bold)),
      content: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search Here",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {setState(() {
            cat = searchController.text;
            searchController.clear();
            _fetchQuestions();
            Get.back();
          });},
          child: Text("Search"),
        ),
      ],
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Interview Questions',style: TextStyle(fontFamily: "Main",color: Colors.white,fontSize:getSize(context, 2.5),fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: muColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              cat.isEmpty?
              Text("Categoery \n  Random", style: TextStyle(fontFamily:"main",fontWeight:FontWeight.bold,color: muColor,fontSize: getSize(context, 1.8)),):
              Text("Categoery \n"+cat, style: TextStyle(fontFamily:"main",fontWeight:FontWeight.bold,color: muColor,fontSize: getSize(context, 1.8)),),
            ElevatedButton(
                onPressed: (){setState(() {
                  cat="";
                  _fetchQuestions();
                });},
                child: Text("Random",style: TextStyle(fontFamily: "Main",color: Colors.white,fontSize:getSize(context, 2),fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                backgroundColor: muColor,
              ),
            ),
            ElevatedButton(
                onPressed: (){_showTextFieldPopup();},
                child: Text("Search",style: TextStyle(fontFamily: "Main",color: Colors.white,fontSize:getSize(context, 2),fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                backgroundColor: muColor,
              ),
            ),
          ],),
          Expanded(
            child: _questions.isEmpty
                ? Center(child: CircularProgressIndicator(color: Colors.orange,))
                : ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final ques = _questions[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onLongPress: () async {
                      final searchQuery = Uri.encodeFull(ques.question);
                    final url = 'https://www.google.com/search?q=$searchQuery';
                    await launch(url);
                   },
                    child: Card(
                      child: ListTile(
                        leading: Text("${index+1}"),
                        title: Text(ques.question),
                        subtitle: cat.isEmpty?Text("Categoery : "+ ques.category, style: TextStyle(fontFamily:"main",fontWeight:FontWeight.bold,color: muColor,fontSize: getSize(context, 1.5)),):SizedBox(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class Question {
  final int id;
  final String question;
  final String category;

  Question({
    required this.id,
    required this.question,
    required this.category,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      category: json['category'] ?? 'Default Category',
    );
  }
}
Future<void> _launchGoogleSearch(String query) async {
  final searchQuery = Uri.encodeFull(query);
  final url = 'https://www.google.com/search?q=$searchQuery';

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}