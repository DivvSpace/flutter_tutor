import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tutor/utils/markdown/markdown_builder.dart';

class ContentWidget extends StatefulWidget {
  const ContentWidget({super.key, required this.mdFilePath});

  final String mdFilePath;

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 200), () {
        return rootBundle.loadString(widget.mdFilePath);
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (Platform.isMacOS) {
            return Expanded(
              child: Markdown(
                data: snapshot.data ?? '',
                selectable: false,
                builders: {'code': CodeElementBuilder()},
              ),
            );
          } else {
            return Markdown(
              data: snapshot.data ?? '',
              selectable: false,
              builders: {'code': CodeElementBuilder()},
            );
          }
        } else {
          if (Platform.isMacOS) {
            return const Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
