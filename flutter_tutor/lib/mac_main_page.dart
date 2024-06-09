import 'package:flutter/material.dart';
import 'package:flutter_tutor/pages/main_list.dart';
import 'package:flutter_tutor/pages/markdown_content.dart';
import 'package:flutter_tutor/providers/content_provider.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:provider/provider.dart';

class MacMainPage extends StatefulWidget {
  const MacMainPage({
    super.key,
  });

  @override
  State<MacMainPage> createState() => _MacMainPageState();
}

class _MacMainPageState extends State<MacMainPage> {
  final MultiSplitViewController _controller = MultiSplitViewController(areas: [
    Area(
      size: 200,
      min: 200,
      max: 300,
      builder: (context, area) {
        debugPrint(area.size.toString());
        return Container(
          color: const Color.fromARGB(255, 228, 226, 226),
          constraints: const BoxConstraints(
            minWidth: 200,
            maxWidth: 300
          ),
          child: const MainListViewWidget(),
        );
      },
    ),
    Area(
        min: 300,
        flex: 2,
        builder: (context, area) {
          return const ContentWidget();
        })
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
          create: (context) => ContentProvider(),
          child: MultiSplitView(
            resizable: true,
            controller: _controller,
          ),
        ),
    );
  }
}
