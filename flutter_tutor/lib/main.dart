import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tutor/pages/main_list.dart';
import 'package:flutter_tutor/pages/markdown_content.dart';
import 'package:flutter_tutor/providers/content_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => ContentProvider(),
        child: Row(children: [
          Container(color: const Color.fromARGB(255, 228, 226, 226), width: 200,child: const MainListViewWidget()),
          Consumer<ContentProvider>(
            builder:(context, contentProvider, child) {
              return ContentWidget(mdFilePath:'assets/markdown/${contentProvider.mdPath}');
            }
          ),
        ]),
      ),
    );
  }
}
