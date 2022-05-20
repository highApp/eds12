import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eds/Color.dart';
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

class AddSubCategory extends StatefulWidget {
  String catId = "";
  late VoidCallback subcatAdded;
  AddSubCategory({required this.catId, required this.subcatAdded});

  @override
  _AddSubCategoryState createState() => _AddSubCategoryState();
}

class _AddSubCategoryState extends State<AddSubCategory> {
  File? _image;
  bool uploadingImage = false;
  bool isLoading = false;

  final txtSubCategoryName = TextEditingController();

  _btnActionAddSubCat(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());

    if (txtSubCategoryName.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("Categoryname is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else {
      _callAddNewCategory(context);
    }
  }

  _callAddNewCategory(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, String> body = Map<String, String>();

    body['cid'] = widget.catId;
    body['name'] = txtSubCategoryName.text;

    log(jsonEncode(body));

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    CustomMultipartObject obj =
        CustomMultipartObject(file: _image, param: "image");
    files.add(obj);
    ApiCallMultiPart networkCall =
        ApiCallMultiPart(APIConstants.addSubCategory, body, header);

    networkCall.callMultipartPostAPI(files, context).then((response) async {
      log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        HelperFunctions.showAlert(
            context: context,
            header: "EDS",
            widget: Text(response["message"]),
            btnDoneText: "ok",
            onDone: () {
              Navigator.pop(
                context,
              );
              widget.subcatAdded();
            },
            onCancel: () {});
      } else {
        HelperFunctions.showAlert(
            context: context,
            header: "EDS",
            widget: Text(response["message"]),
            btnDoneText: "ok",
            onDone: () {},
            onCancel: () {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              size: size.height * 0.03,
            ),
          ),
          backgroundColor: colorPrimary,
          centerTitle: true,
          title: Text(
            'Add Sub Category',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        body: Column(
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
            LabelWidget(
              labelText: "Subcategory Name",
              max: 1,
              controller: txtSubCategoryName,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            custom_btn(
              onPressed: () {
                _btnActionAddSubCat(context);
              },
              text: "Add",
              textColor: colorWhite,
              backcolor: colorPrimary,
            )
          ],
        ),
      ),
    );
  }

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
}
