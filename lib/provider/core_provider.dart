

import 'package:eds/models/bNameListModel.dart';
import 'package:eds/models/bNameModel.dart';
import 'package:flutter/cupertino.dart';

class CoreProvider extends ChangeNotifier {
  BNameModel? bNameModel;
  String? selectedbName = null;

  // BListModel? bListModel;
  // CategoryListModel? categoryListModel;
  BListModel? bListModel;


  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();


}
