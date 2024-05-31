import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tutor/pages/main_list.dart';
import 'package:flutter_tutor/pages/phone_content_page.dart';
import 'package:flutter_tutor/providers/content_provider.dart';
import 'package:provider/provider.dart';

class PhoneMainPage extends StatefulWidget {
  const PhoneMainPage({super.key});

  @override
  State<PhoneMainPage> createState() => _PhoneMainPageState();
}

class _PhoneMainPageState extends State<PhoneMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider<ContentProvider>(
      create: (context) => ContentProvider(),
      child: Consumer<ContentProvider>(
          builder: (context, value, child) {
            var item = Provider.of<ContentProvider>(context, listen: false);
            if (item.mdPath.isNotEmpty) {
              debugPrint('is not empty [${item.mdPath}]');
              Future.delayed(const Duration(milliseconds: 100), () {
                _pushContentPage(item);
              });
            }
            return const MainListViewWidget();
          },
          child: const MainListViewWidget()),
    ));
  }

  void _pushContentPage(ContentProvider item) {
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) {
        return PhoneContentPage(
          mdPath: item.mdPath,
          title: item.mdTitle,
        );
      },
    ));
  }
}
