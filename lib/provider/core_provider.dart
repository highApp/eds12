

import 'package:eds/models/bNameListModel.dart';
import 'package:eds/models/bNameModel.dart';
import 'package:eds/models/stockModel.dart';
import 'package:flutter/cupertino.dart';

class CoreProvider extends ChangeNotifier {
  BNameModel? bNameModel;
  String? selectedbName = null;

  // BListModel? bListModel;
  // CategoryListModel? categoryListModel;
  BListModel? bListModel;
  StockModel? stockModel;


  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  // TextEditingController addressController = TextEditingController();
  // TextEditingController vatRegController = TextEditingController();

}
