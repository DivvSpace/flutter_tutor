import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tutor/providers/content_provider.dart';
import 'package:flutter_tutor/utils/markdown/markdown_builder.dart';
import 'package:provider/provider.dart';

class ContentWidget extends StatefulWidget {
  const ContentWidget({super.key, this.mdFilePath = ''});

  final String mdFilePath;

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ContentProvider>(builder: (context, value, child) {
      return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 0), () {
          return rootBundle.loadString('assets/markdown/${value.mdPath}');
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (Platform.isMacOS) {
              return Markdown(
                data: snapshot.data ?? '',
                selectable: false,
                builders: {'code': CodeElementBuilder()},
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
              return  const CircularProgressIndicator();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    });
  }
}
