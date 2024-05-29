import 'package:flutter/material.dart';
import 'package:flutter_tutor/pages/main_list.dart';
import 'package:flutter_tutor/pages/markdown_content.dart';
import 'package:flutter_tutor/providers/content_provider.dart';
import 'package:provider/provider.dart';

class MacMainPage extends StatelessWidget {
  const MacMainPage({
    super.key,
  });

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