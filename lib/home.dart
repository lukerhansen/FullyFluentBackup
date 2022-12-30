import 'package:flutter/material.dart';
import 'package:openai/models/chat.dart';
//import 'package:gpt_3_dart/gpt_3_dart.dart';
import 'package:openai/gpt3_dart.dart';

class Home extends StatefulWidget {
  final OpenAI openAI;
  Home(this.openAI);
  @override
  _HomeState createState() => _HomeState(openAI);
}

class _HomeState extends State<Home> {
  final OpenAI openAI;
  _HomeState(this.openAI);

  List<Chat> chat = [];
  var textController = TextEditingController();
  final scrollController = ScrollController();
  String prompt =
      'The following is a conversation with an AI assistant. The assistant is helpful, creative, clever, and very friendly.';

  void addData(Chat data) {
    setState(() {
      chat.add(data);
    });
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                  itemCount: chat.length,
                  shrinkWrap: true,
                  reverse: false,
                  controller: scrollController,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (chat[index].isAnswer
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (chat[index].isAnswer
                                ? Colors.grey.shade200
                                : Colors.blue[200]),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            chat[index].text,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: "Ask a question?",
                          ),
                          onChanged: (String value) => {},
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: MaterialButton(
                        onPressed: () async {
                          if (textController.value.text.isNotEmpty) {
                            addData(Chat(textController.value.text, false));
                            scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.linear);
                            String prompt =
                                'The following is a conversation with an AI assistant. The assistant is helpful, creative, clever, and very friendly.\n\nHuman: Hello, who are you?\nAI: I am an AI created by OpenAI. How can I help you today?\nHuman: ';
                            String answer = await openAI.complete(
                                prompt + textController.value.text, 50,
                                temperature: 0.9,
                                topP: 1,
                                n: 1,
                                engine: "text-curie-003",// List engineList = ['text-ada-001', 'text-babbage-001', 'text-curie-001', 'text-davinci-003'];
                                presencePenalty: 0.6,
                                frequencyPenalty: 0,
                                stop: [" Human:", " AI:"]);
                            setState(() {
                                textController.text = "";
                              });
                            if (answer != null) {
                              print("#### ANSWER: " + answer);
                              addData(Chat(answer, true));
                              scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.linear);
                            }
                          }
                        },
                        child: Icon(
                          Icons.send,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
