import 'package:flutter/material.dart';
import 'package:flutter_tutor/pages/main_list.dart';

class PhoneMainPage extends StatefulWidget {
  const PhoneMainPage({super.key});

  @override
  State<PhoneMainPage> createState() => _PhoneMainPageState();
}

class _PhoneMainPageState extends State<PhoneMainPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: MainListViewWidget(),);
  }
}