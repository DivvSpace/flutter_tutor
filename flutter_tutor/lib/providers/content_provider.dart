import 'package:flutter/cupertino.dart';

class ContentProvider with ChangeNotifier {
  String _mdPath = '';

  String get mdPath => _mdPath;

  void changeMdContent({required String mdpath}) {
    _mdPath = mdpath;
    notifyListeners();
  }
}
