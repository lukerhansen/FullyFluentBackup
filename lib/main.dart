import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:openai/home.dart';
import 'package:openai/gpt3_dart.dart';
//import 'package:gpt_3_dart/gpt_3_dart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance?.resamplingEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  OpenAI openAI = new OpenAI(apiKey: "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");
  runApp(MyApp(openAI));
}

class MyApp extends StatelessWidget {
  final OpenAI openAI;
  MyApp(this.openAI);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenAI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Home(openAI),
    );
  }
}
