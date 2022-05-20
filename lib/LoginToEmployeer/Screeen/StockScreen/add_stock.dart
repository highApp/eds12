import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eds/Color.dart';
import 'package:eds/LoginToEmployeer/category/SubcategoryResponse.dart';
import 'package:eds/LoginToEmployeer/category/categoryResponse.dart';
import 'package:eds/Widget/LabelWidget.dart';
import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:eds/utilities/image_bottom_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStockScreen extends StatefulWidget {
  CategoryModel? categoryModel;
  SubcategModel? subcategModel;

  AddStockScreen({required this.categoryModel, required this.subcategModel});

  @override
  _AddStockScreenState createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final prodNameController = TextEditingController();
  final amountController = TextEditingController();
  final descController = TextEditingController();
  final rentController = TextEditingController();
  final labourController = TextEditingController();
  final optionalController = TextEditingController();
  final quantityController = TextEditingController();
  bool isLoading = false;

  _btnActionSignIn(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (prodNameController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("stock name is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (amountController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("amount is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (descController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("description is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else if (quantityController.text == '') {
      HelperFunctions.showAlert(
        context: context,
        header: "EDS",
        widget: Text("quantity is required"),
        btnDoneText: "ok",
        onDone: () {},
        onCancel: () {},
      );
    } else {
      callAPIAddStock(context);
    }
  }

  callAPIAddStock(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    Map<String, String> body = Map<String, String>();

    body['empid'] = widget.categoryModel!.empid;
    body['cid'] = widget.categoryModel!.id.toString();
    body['scid'] = widget.subcategModel!.id.toString();
    body['productName'] = prodNameController.text;
    body['amount'] = amountController.text;
    body['description'] = descController.text;
    body['rent'] = rentController.text;

    body['labour'] = labourController.text;
    body['optionalAmount'] = optionalController.text;
    body['quantity'] = quantityController.text;

    Map<String, String> header = Map<String, String>();
    log(jsonEncode(body));

    FocusScope.of(context).requestFocus(FocusNode());
    CustomMultipartObject obj =
        CustomMultipartObject(file: _image, param: "image");
    files.add(obj);
    ApiCallMultiPart networkCall =
        ApiCallMultiPart(APIConstants.addStock, body, header);

    networkCall.callMultipartPostAPI(files, context).then((response) async {
      print('Back from api');
      setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      print(status);
      if (status == true) {
        HelperFunctions.showAlert(
          context: context,
          header: "Eds",
          widget: Text(response["message"]),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {},
        );
      } else {
        HelperFunctions.showAlert(
          context: context,
          header: "Eds",
          widget: Text(response["message"]),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {},
        );
      }
    });
  }

  File? _image;
  final imagePicker = ImagePicker();
  List<CustomMultipartObject> files = [];
  Future _chooseImage(BuildContext context, ImageSource source) async {
    final pickedFile = await imagePicker.getImage(
      source: source,
      imageQuality: 50,
    );
    Navigator.pop(context);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  _getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _image = File(result.files.single.path.toString());
    } else {
      // User canceled the picker
    }
    Navigator.pop(context);
    setState(() {
      this._image = _image;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorPrimary,
          title: Text(
            'Add Stock',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      CustomBottomSheetCamera.bottomSheet(context, () {
                        _chooseImage(context, ImageSource.camera);
                      }, () {
                        _getFile();
                      });
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: colorPrimary,
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                _image!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                LabelWidget(
                  labelText: 'Name',
                  max: 1,
                  controller: prodNameController,
                ),
                LabelWidget(
                  labelText: 'Amount',
                  max: 1,
                  controller: amountController,
                  inputType: TextInputType.number,
                ),
                LabelWidget(
                  labelText: 'Description',
                  max: 1,
                  controller: descController,
                ),
                LabelWidget(
                  labelText: 'Rent',
                  max: 1,
                  controller: rentController,
                  inputType: TextInputType.number,
                ),
                LabelWidget(
                  labelText: 'Labour',
                  max: 1,
                  controller: labourController,
                  inputType: TextInputType.number,
                ),
                LabelWidget(
                  labelText: 'Optional amount',
                  max: 1,
                  controller: optionalController,
                  inputType: TextInputType.number,
                ),
                LabelWidget(
                  labelText: 'Quantity',
                  max: 1,
                  controller: quantityController,
                  inputType: TextInputType.number,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.032,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      widget.categoryModel!.name,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: size.width * 0.032,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subcategory',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.032,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      widget.subcategModel!.name,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: size.width * 0.032,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                custom_btn(
                  onPressed: () {
                    _btnActionSignIn(context);
                  },
                  text: "Add",
                  textColor: colorWhite,
                  backcolor: colorPrimary,
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
