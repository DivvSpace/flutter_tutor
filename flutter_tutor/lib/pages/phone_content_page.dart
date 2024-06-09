import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tutor/pages/markdown_content.dart';
import 'package:flutter_tutor/utils/markdown/markdown_builder.dart';

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
      body: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 0), () {
          return rootBundle.loadString('assets/markdown/${widget.mdPath}');
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Markdown(
                data: snapshot.data ?? '',
                selectable: false,
                builders: {'code': CodeElementBuilder()},
              );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}