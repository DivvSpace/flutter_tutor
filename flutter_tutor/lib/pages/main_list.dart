import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                            return ExpansionTile(
                              key: Key(e['title']),
                              expandedCrossAxisAlignment: CrossAxisAlignment.start,
                              title: Text(
                                e['title'],
                                style: const TextStyle(color: Colors.red),
                              ),
                              collapsedBackgroundColor: Colors.blue,
                              initiallyExpanded: true,
                              expandedAlignment: Alignment.centerLeft,
                              children: (e['menus'] as List).map((item) {
                                return ValueListenableBuilder(valueListenable: _selectedIndexTitle, builder: (context, value, child) {

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3),
                                  child: GestureDetector(
                                    onTap: () {
                                      _selectedIndexTitle.value = item['title'];

                                      debugPrint('tap on : ${item['title'] ?? ""}');
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                                        color: _selectedIndexTitle.value == item['title']
                                            ? Colors.blue
                                            : Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: Text(item['title'], style: const TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                );
                                });
                              }).toList(),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(e['title']),
                          );
                        },
                        // children: (data['menus'] as List).map((e) {
                        //   if (e['menus'] != null && e['menus']!.isNotEmpty && (e['menus'] as List).isNotEmpty) {
                        //     return ExpansionTile(
                        //       key: Key(e['title']),
                        //       expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        //       title: Text(e['title'], style: const TextStyle(color: Colors.red),),
                        //       collapsedBackgroundColor: Colors.blue,
                        //       initiallyExpanded: true,
                        //       expandedAlignment: Alignment.centerLeft,
                        //       children:(e['menus'] as List).map((item) {
                        //               return Padding(
                        //                 padding: const EdgeInsets.symmetric(vertical: 3),
                        //                 child: GestureDetector(
                        //                   onTap: () {
                        //                     _selectedIndexTitle = item['title'];
                        //                     debugPrint('tap on : ${item['title'] ?? ""}');
                        //                     setState(() {

                        //                     });
                        //                   },
                        //                   child: Container(
                        //                     width: double.infinity,
                        //                     padding: const EdgeInsets.all(2),
                        //                     decoration: BoxDecoration(
                        //                       borderRadius: const BorderRadius.all(Radius.circular(4)),
                        //                       color: _selectedIndexTitle == item['title'] ? Colors.blue : Colors.white,
                        //                     ),
                        //                     child: Padding(
                        //                       padding: const EdgeInsets.only(left: 16.0),
                        //                       child: Text(item['title'], style: const TextStyle(color: Colors.black)),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               );
                        //             }).toList(),

                        //     );
                        //   }

                        //   return Padding(
                        //     padding: const EdgeInsets.symmetric(vertical: 2.0),
                        //     child: Text(e['title']),
                        //   );
                        // }).toList(),
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
}
