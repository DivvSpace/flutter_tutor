import 'package:flutter/cupertino.dart';

class ContentProvider with ChangeNotifier {
  String _mdPath = '';
  String _mdTitle = '';

  String get mdPath => _mdPath;
  String get mdTitle => _mdTitle;

  void changeMdContent({required String mdpath, String? mdTitle}) {
    _mdPath = mdpath;
    _mdTitle = mdTitle ?? '';

    notifyListeners();
  }
}
