import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atelier-cave-dark.dart';
import 'package:flutter_highlighter/themes/github-gist.dart';
import 'package:flutter_highlighter/themes/github.dart';
import 'package:flutter_highlighter/themes/vs.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class MarkdownCodeHightlighter extends StatefulWidget {
  final String content;
  final String lang;
  const MarkdownCodeHightlighter({super.key, required this.content, required this.lang});

  @override
  State<MarkdownCodeHightlighter> createState() => _MarkdownCodeHightlighterState();
}

class _MarkdownCodeHightlighterState extends State<MarkdownCodeHightlighter> {
  @override
  Widget build(BuildContext context) {
    return HighlightView(
      widget.content,
      language: widget.lang,
      theme: atelierCaveDarkTheme,
      padding: const EdgeInsets.all(8),
      textStyle: const TextStyle(
        fontSize: 18,
      ),
    );
  }
}

class CodeElementBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
      BuildContext context, md.Element element, TextStyle? preferredStyle, TextStyle? parentStyle) {
    var language = '';
    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    return MarkdownCodeHightlighter(content: element.textContent, lang: language);
  }
}
