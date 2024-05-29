import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tutor/pages/phone_content_page.dart';
import 'package:flutter_tutor/providers/content_provider.dart';
import 'package:provider/provider.dart';

class MainListViewWidget extends StatefulWidget {
  const MainListViewWidget({super.key});

  @override
  State<MainListViewWidget> createState() => _MainListViewWidgetState();
}

class _MainListViewWidgetState extends State<MainListViewWidget> {
  @override
  void initState() {
    _readJson();
    super.initState();
  }

  Future<List> _readJson() async {
    final String response = await rootBundle.loadString('assets/menu_list.json');
    final List<dynamic> data = await json.decode(response);
    debugPrint(data.toString());
    return Future(() => data);
  }

  final ValueNotifier<String> _selectedIndexTitle = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _readJson(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final Map data = snapshot.data![index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data['title'],
                        style: const TextStyle(color: Color.fromARGB(255, 161, 163, 164)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: (data['menus'] as List).length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final e = data['menus'][index];
                          if (e['menus'] != null && e['menus']!.isNotEmpty && (e['menus'] as List).isNotEmpty) {
                            return _buildExpansionTitle(e);
                          }

                          return GestureDetector(
                            onTap: () {
                              _selectedIndexTitle.value = e['title'];
                              if (Platform.isMacOS) {
                                Provider.of<ContentProvider>(context, listen: false)
                                    .changeMdContent(mdpath: e['mdName']);
                              } else if (Platform.isIOS || Platform.isAndroid) {
                                Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) {
                                    return PhoneContentPage(mdPath: e['mdName'], title: e['title'],);
                                  },
                                ));
                              }
                            },
                            child: _buildValueListenBuild(e),
                          );
                        },
                      ),
                    )
                  ],
                );
              });
        } else {
          return Container();
        }
      },
    );
  }

  ValueListenableBuilder<String> _buildValueListenBuild(e) {
    return ValueListenableBuilder(
        valueListenable: _selectedIndexTitle,
        builder: (context, value, child) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: _selectedIndexTitle.value == e['title'] ? Colors.blue : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(e['title'], style: const TextStyle(color: Colors.black)),
            ),
          );
        });
  }

  ExpansionTile _buildExpansionTitle(e) {
    return ExpansionTile(
      key: Key(e['title']),
      shape: Border.all(color: Colors.transparent),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      title: Text(
        e['title'],
        style: const TextStyle(color: Colors.black54, fontSize: 16.0),
      ),
      initiallyExpanded: true,
      expandedAlignment: Alignment.centerLeft,
      children: (e['menus'] as List).map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: GestureDetector(
            onTap: () {
              _selectedIndexTitle.value = item['title'];

              if (Platform.isMacOS) {
                Provider.of<ContentProvider>(context, listen: false).changeMdContent(mdpath: item['mdName']);
              } else if (Platform.isIOS || Platform.isAndroid) {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) {
                    return PhoneContentPage(mdPath: item['mdName'], title: item['title'],);
                  },
                ));
              }

              debugPrint('tap on : ${item['title'] ?? ""}');
            },
            child: _buildValueListenBuild(item),
          ),
        );
      }).toList(),
    );
  }
}
