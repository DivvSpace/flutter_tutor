import 'package:flutter/material.dart';
import 'package:flutter_tutor/pages/markdown_content.dart';

class PhoneContentPage extends StatefulWidget {

  final String mdPath;
  final String title;

  const PhoneContentPage({super.key, required this.mdPath, required this.title});

  @override
  State<PhoneContentPage> createState() => _PhoneContentPageState();
}

class _PhoneContentPageState extends State<PhoneContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: ContentWidget(mdFilePath: 'assets/markdown/${widget.mdPath}',),
    );
  }
}