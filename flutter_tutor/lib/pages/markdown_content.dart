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
      future: rootBundle.loadString(widget.mdFilePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Expanded(
              child: Markdown(
            data: snapshot.data ?? '',
            selectable: false,
            builders: {'code': CodeElementBuilder()},
          ));
        } else {
          return const Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        }
      },
    );
  }
}
