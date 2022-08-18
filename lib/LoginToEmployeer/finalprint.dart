import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eds/Color.dart';
import 'package:eds/Widget/LabelWidget.dart';
import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/conteroller/api%20_controller.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/bNameListModel.dart';
import 'package:eds/provider/core_provider.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:eds/utilities/image_bottom_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared pref/share_pref.dart';

class FinalPrintDetailsScreen extends StatefulWidget {
  final String empID;

  FinalPrintDetailsScreen({required this.empID});

  @override
  _FinalPrintDetailsScreenState createState() =>
      _FinalPrintDetailsScreenState();
}

class _FinalPrintDetailsScreenState extends State<FinalPrintDetailsScreen>
    with SingleTickerProviderStateMixin {
  String? stockImage1 = "https://eds.greenspoints.com/public/images/eds.png";

  // File? _image1;
  PickedFile? _imageFile;

  // final imagePicker = ImagePicker();
  String? _selectedLocation1; // Option 2

  bool isLoading = true;
  final ImagePicker _picker = ImagePicker();

  List<String> _locations1 = [
    'left',
    'center',
    'right',
  ];

  final fromDataController = TextEditingController();

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: _imageFile == null
                ? AssetImage('assets/images/asemp.png')
                : FileImage(File(_imageFile!.path)) as ImageProvider,
          ),
          Positioned(
            child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context, builder: (builder) => myBottomSheet());
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Color(0xff99CCC3),
                )),
            bottom: 20,
            right: 20,
          )
        ],
      ),
    );
  }

  Widget myBottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            'Chose Profile photo',
            style:
                GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                    icon: Icon(Icons.camera_alt),
                  ),
                  Text('Camera'),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        takePhoto(ImageSource.gallery);
                      },
                      icon: Icon(Icons.image)),
                  Text('Gallery')
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<CoreProvider>(
      builder: (context, appPro, _) {
        return CustomLoader(
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    await preferences.clear();

                    Navigator.pop(context);
                  },
                ),
                elevation: 0,
                backgroundColor: colorPrimary,
                centerTitle: true,
                title: Text(
                  "Print Expenses",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: size.height * 0.024),
                ),
              ),
              body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        imageProfile(),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          "Select Logo",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * 0.034),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Center(
                          child: DropdownButton<String>(
                            underline: Divider(
                              color: colorPrimary,
                            ),
                            hint: Text('Please choose logo location'),
                            // Not necessary for Option 1
                            value: _selectedLocation1,
                            onChanged: (newValue) {
                              _selectedLocation1 = newValue;
                              setState(() {});
                            },
                            items: _locations1.map((location1) {
                              return DropdownMenuItem(
                                child: new Text(location1),
                                value: location1,
                              );
                            }).toList(),
                          ),
                        ),
                        custom_btn(
                          onPressed: () async {
                            final pdf = await ApiController().getPdf(
                              bid1: widget.empID,
                              pid1: appPro.selectedbName,
                              startDate1: appPro.startDateController.text,
                              endDate1: appPro.endDateController.text,
                              position: _selectedLocation1,
                              documentOne: File(_imageFile!.path),
                            );
                            await _openPDF(pdf?.expensesPdf ?? '');
                          },
                          text: "Final Print",
                          textColor: colorWhite,
                          backcolor: colorPrimary,
                        )
                      ],
                    )),
              )),
        );
      },
    );
  }

  _openPDF(String fileName) async {
    String url = fileName;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Konnte nicht gestartet werden $url';
    }
  }
}
