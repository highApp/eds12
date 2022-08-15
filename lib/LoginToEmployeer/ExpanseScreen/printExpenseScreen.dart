import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eds/Color.dart';
import 'package:eds/Widget/LabelWidget.dart';
import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/conteroller/api%20_controller.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/provider/core_provider.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:eds/utilities/image_bottom_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PrintexpenseScreen extends StatefulWidget {

  String empId = "";
  PrintexpenseScreen({required this.empId});

  @override
  _PrintexpenseScreenState createState() => _PrintexpenseScreenState();
}

class _PrintexpenseScreenState extends State<PrintexpenseScreen> with SingleTickerProviderStateMixin{
  final fromDataController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  final toDateController = TextEditingController();
  DateFormat ourFormat = DateFormat('yyyy-MM-dd');
  List<String> _locations = [
    'left',
    'center',
    'right',
  ]; //
  List<String> _locations1 = [
    'left',
    'center',
    'right',
  ];// Option 2
  String? _selectedLocation; // Option 2
  String? _selectedLocation1; // Option 2
  String? stockImage="https://eds.greenspoints.com/public/images/eds.png";
  String? stockImage1="https://eds.greenspoints.com/public/images/eds.png";

  final imagePicker = ImagePicker();
  File? _image ;
  File? _image1 ;
  List<CustomMultipartObject> files = [];
  _openPDF(String fileName) async {
    String url = fileName;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Konnte nicht gestartet werden $url';
    }
  }
  _openPDF1(String fileName1) async {
    String url = fileName1;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Konnte nicht gestartet werden $url';
    }
  }

  Future chooseImage(BuildContext context, ImageSource source) async {
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
  _btnActionprint(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());

    // if (_image == null) {
    //   HelperFunctions.showAlert(
    //       context: context,
    //       header: "EDS",
    //       widget: Text("Logo is required"),
    //       btnDoneText: "ok",
    //       onDone: () {},
    //       onCancel: () {});
    // } else if (_selectedLocation == null) {
    //   HelperFunctions.showAlert(
    //       context: context,
    //       header: "EDS",
    //       widget: Text("Olease select logo is Position"),
    //       btnDoneText: "ok",
    //       onDone: () {},
    //       onCancel: () {});
    // } else
    if (fromDataController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("start date is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (toDateController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("end date is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else {
      _callPrintExpense(context);
    }
  }

  Future chooseImage1(BuildContext context, ImageSource source) async {
    final pickedFile1 = await imagePicker.getImage(
      source: source,
      imageQuality: 50,
    );
    Navigator.pop(context);
    setState(() {
      _image1 = File(pickedFile1!.path);
    });
  }


  _getFile1() async {
    FilePickerResult? result1 = await FilePicker.platform.pickFiles();

    if (result1 != null) {
      _image1 = File(result1.files.single.path.toString());
    } else {
      // User canceled the picker
    }
    Navigator.pop(context);
    setState(() {
      this._image1 = _image1;
    });
  }

  _btnActionprintPdf(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());

    // if (_image == null) {
    //   HelperFunctions.showAlert(
    //       context: context,
    //       header: "EDS",
    //       widget: Text("Logo is required"),
    //       btnDoneText: "ok",
    //       onDone: () {},
    //       onCancel: () {});
    // } else if (_selectedLocation == null) {
    //   HelperFunctions.showAlert(
    //       context: context,
    //       header: "EDS",
    //       widget: Text("Olease select logo is Position"),
    //       btnDoneText: "ok",
    //       onDone: () {},
    //       onCancel: () {});
    // } else
      if (fromDataController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("start date is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (toDateController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("end date is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else {
      _callPrintExpense(context);
    }
  }

  bool isLoading = false;
  _callPrintExpense(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, String> body = Map<String, String>();

    body['empid'] = widget.empId;
    body['position'] = _selectedLocation.toString();
    body['startDate'] = fromDataController.text;
    body['endDate'] = toDateController.text;

    log(jsonEncode(body));

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    CustomMultipartObject obj =
        CustomMultipartObject(file: _image, param: "logo");
    if (_image != null) {
      files.add(obj);
    }
    //files.add(obj);
    ApiCallMultiPart networkCall =
        ApiCallMultiPart(APIConstants.printExpense, body, header);

    networkCall.callMultipartPostAPI(files, context).then((response) async {
      log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        _openPDF(response["response"]);
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
  _callPrintExpensePdf(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, String> body = Map<String, String>();

    body['empid'] = widget.empId;
    body['pname'] =  "zain";
    body['position'] = _selectedLocation.toString();
    body['startDate'] = fromDataController.text;
    body['endDate'] = toDateController.text;

    log(jsonEncode(body));

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    CustomMultipartObject obj =
        CustomMultipartObject(file: _image1, param: "logo");
    if (_image != null) {
      files.add(obj);
    }
    //files.add(obj);
    ApiCallMultiPart networkCall =
        ApiCallMultiPart(APIConstants.printExpensePdf, body, header);

    networkCall.callMultipartPostAPI(files, context).then((response) async {
      log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        _openPDF(response["expenses_pdf"]);
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


  String dropdownValue = 'Furniture & General items';

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<CoreProvider>(builder: (context, appPro, _) {
      return CustomLoader(
        isLoading: isLoading,
        child: Scaffold(
          appBar: AppBar(
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
          body:
          SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: TabBar(
                        indicator: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: BorderRadius.circular(5)),
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: colorPrimary,
                        tabs: [
                          Tab(
                            text: 'Total Sale',
                          ),
                          Tab(
                            text: 'Individual Sale',
                          )
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height,
                        child: TabBarView(
                            controller: _tabController,
                            children: [
                              SingleChildScrollView(
                                physics: ScrollPhysics(),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          CustomBottomSheetCamera.bottomSheet(
                                              context, () {
                                            chooseImage(
                                                context, ImageSource.camera);
                                          }, () {
                                            _getFile();
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: 55,
                                          backgroundColor: colorPrimary,
                                          child: _image != null
                                              ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                50),
                                            child: Image.file(
                                              _image!,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                              : stockImage != null
                                              ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                50),
                                            child: Image.network(
                                              stockImage.toString(),
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                              : Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius: BorderRadius
                                                    .circular(50)),
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
                                      height: size.height * 0.01,
                                    ),
                                    Text(
                                      "Select Logo",
                                      style:
                                      TextStyle(color: Colors.black,
                                          fontSize: size.width * 0.034),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Center(
                                      child: DropdownButton(
                                        underline: Divider(
                                          color: colorPrimary,
                                        ),
                                        hint: Text(
                                            'Please choose logo location'),
                                        // Not necessary for Option 1
                                        value: _selectedLocation,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _selectedLocation =
                                                newValue.toString();
                                          });
                                        },
                                        items: _locations.map((location) {
                                          return DropdownMenuItem(
                                            child: new Text(location),
                                            value: location,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDatePicker(
                                          // builder: ,
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2018),
                                          lastDate: DateTime(2025),
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                colorScheme: ColorScheme.light(
                                                    primary: colorPrimary),
                                                buttonTheme:
                                                ButtonThemeData(
                                                    textTheme: ButtonTextTheme
                                                        .accent),
                                              ),
                                              // This will change to light theme.
                                              child: child!,
                                            );
                                          },
                                        ).then((date) {
                                          if (date != null) {
                                            setState(() {
                                              fromDataController.text =
                                                  ourFormat.format(date);
                                            });
                                          }
                                        });
                                      },
                                      child: AbsorbPointer(
                                        child: LabelWidget(
                                          labelText: "Start Date",
                                          controller: fromDataController,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDatePicker(
                                          // builder: ,
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2018),
                                          lastDate: DateTime(2025),
                                          builder: (context, child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                colorScheme: ColorScheme.light(
                                                    primary: colorPrimary),
                                                buttonTheme:
                                                ButtonThemeData(
                                                    textTheme: ButtonTextTheme
                                                        .accent),
                                              ),
                                              // This will change to light theme.
                                              child: child!,
                                            );
                                          },
                                        ).then((date) {
                                          if (date != null) {
                                            setState(() {
                                              toDateController.text =
                                                  ourFormat.format(date);
                                            });
                                          }
                                        });
                                      },
                                      child: AbsorbPointer(
                                        child: LabelWidget(
                                          labelText: "End Date",
                                          controller: toDateController,
                                        ),
                                      ),
                                    ),
                                    custom_btn(
                                      onPressed: () {
                                        _btnActionprint(context);
                                      },
                                      text: "Print",
                                      textColor: colorWhite,
                                      backcolor: colorPrimary,
                                    )
                                  ],
                                ),

                              ),
                              SingleChildScrollView(
                                  physics: ScrollPhysics(),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 20,),

                                      Text(
                                        "Please Select the name buyer",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: size.height * 0.020),
                                      ),


                                      SizedBox(height: 20,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                ),
                                                height: 45,
                                                // width: 311.w,
                                                child: DropdownButton<String>(
                                                  hint: Text(
                                                      'select Name '),
                                                  elevation: 12,
                                                  // isExpanded: true,
                                                  icon: const Icon(
                                                    Icons.arrow_downward,
                                                  ),
                                                  underline: SizedBox(),
                                                  // Step 3.
                                                  value: context
                                                      .read<CoreProvider>()
                                                      .selectedbName,
                                                  // Step 4.
                                                  items: context
                                                      .read<CoreProvider>()
                                                      .bNameModel!
                                                      .pNames!
                                                      .map<
                                                      DropdownMenuItem<String>>(
                                                          (value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value:value
                                                              .toString(),
                                                          child: Text(
                                                            '${value}'
                                                          ),
                                                        );
                                                      })
                                                      .toList(),
                                                  // Step 5.
                                                  onChanged: (
                                                      String? newValue) {
                                                    setState(() {
                                                      context
                                                          .read<CoreProvider>()
                                                          .selectedbName =
                                                          newValue;
                                                      print(
                                                          'Selected Categorry ID - $newValue');
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),




                                        ],
                                      ),

                                      // Container(height: 100,width: 300,
                                      //   child: GestureDetector(
                                      //     onTap: () {
                                      //       showDatePicker(
                                      //         context: context,
                                      //         initialDate: DateTime.now(),
                                      //         firstDate: DateTime(2018),
                                      //         lastDate: DateTime(2025),
                                      //         builder: (context, child) {
                                      //           return Theme(
                                      //             data: ThemeData.light().copyWith(
                                      //               colorScheme: ColorScheme.light(
                                      //                   primary: colorPrimary),
                                      //               buttonTheme:
                                      //               ButtonThemeData(
                                      //                   textTheme: ButtonTextTheme
                                      //                       .accent),
                                      //             ),
                                      //             // This will change to light theme.
                                      //             child: child!,
                                      //           );
                                      //         },
                                      //       ).then((date) {
                                      //         if (date != null) {
                                      //           setState(() {
                                      //             startDateController.text =
                                      //                 ourFormat.format(date);
                                      //           });
                                      //         }
                                      //       });
                                      //     },
                                      //     child: AbsorbPointer(
                                      //       child: LabelWidget(
                                      //         labelText: "Start Date",
                                      //         controller: startDateController,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(height: 20,),
                                      //
                                      // Container(height: 100,width: 300,
                                      //   child: GestureDetector(
                                      //     onTap: () {
                                      //       showDatePicker(
                                      //         context: context,
                                      //         initialDate: DateTime.now(),
                                      //         firstDate: DateTime(2018),
                                      //         lastDate: DateTime(2025),
                                      //         builder: (context, child) {
                                      //           return Theme(
                                      //             data: ThemeData.light().copyWith(
                                      //               colorScheme: ColorScheme.light(
                                      //                   primary: colorPrimary),
                                      //               buttonTheme:
                                      //               ButtonThemeData(
                                      //                   textTheme: ButtonTextTheme
                                      //                       .accent),
                                      //             ),
                                      //             // This will change to light theme.
                                      //             child: child!,
                                      //           );
                                      //         },
                                      //       ).then((date) {
                                      //         if (date != null) {
                                      //           setState(() {
                                      //             endDateController.text =
                                      //                 ourFormat.format(date);
                                      //           });
                                      //         }
                                      //       });
                                      //     },
                                      //     child: AbsorbPointer(
                                      //       child: LabelWidget(
                                      //         labelText: "Start Date",
                                      //         controller: endDateController,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),

                                      SizedBox(height: 20,),

                                      custom_btn(
                                        onPressed: () async{
                                         await ApiController().getlist(
                                           bid: widget.empId,pid: appPro.selectedbName,
                                             startDate: startDateController.text,endDate: endDateController.text

                                         )

                                             .then((value) =>{
                                           print
                                         });
                                        },
                                        text: "Print",
                                        textColor: colorWhite,
                                        backcolor: colorPrimary,
                                      ),
                                      SizedBox(height: 20,),

                                      Column(
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                          Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                CustomBottomSheetCamera.bottomSheet(
                                                    context, () {
                                                  chooseImage1(
                                                      context, ImageSource.camera);
                                                }, () {
                                                  _getFile1();
                                                });
                                              },
                                              child: CircleAvatar(
                                                radius: 55,
                                                backgroundColor: colorPrimary,
                                                child: _image1 != null
                                                    ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(
                                                      50),
                                                  child: Image.file(
                                                    _image1!,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                                    : stockImage1 != null
                                                    ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(
                                                      50),
                                                  child: Image.network(
                                                    stockImage1.toString(),
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                                    : Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius: BorderRadius
                                                          .circular(50)),
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
                                            height: size.height * 0.01,
                                          ),
                                          Text(
                                            "Select Logo",
                                            style:
                                            TextStyle(color: Colors.black,
                                                fontSize: size.width * 0.034),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Center(
                                            child: DropdownButton(
                                              underline: Divider(
                                                color: colorPrimary,
                                              ),
                                              hint: Text(
                                                  'Please choose logo location'),
                                              // Not necessary for Option 1
                                              value: _selectedLocation1,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _selectedLocation1 =
                                                      newValue.toString();
                                                });
                                              },
                                              items: _locations1.map((location1) {
                                                return DropdownMenuItem(
                                                  child: new Text(location1),
                                                  value: location1,
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDatePicker(
                                                // builder: ,
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2018),
                                                lastDate: DateTime(2025),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: ThemeData.light().copyWith(
                                                      colorScheme: ColorScheme.light(
                                                          primary: colorPrimary),
                                                      buttonTheme:
                                                      ButtonThemeData(
                                                          textTheme: ButtonTextTheme
                                                              .accent),
                                                    ),
                                                    // This will change to light theme.
                                                    child: child!,
                                                  );
                                                },
                                              ).then((date) {
                                                if (date != null) {
                                                  setState(() {
                                                    startDateController.text =
                                                        ourFormat.format(date);
                                                  });
                                                }
                                              });
                                            },
                                            child: AbsorbPointer(
                                              child: LabelWidget(
                                                labelText: "Start Date",
                                                controller: startDateController,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDatePicker(
                                                // builder: ,
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2018),
                                                lastDate: DateTime(2025),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: ThemeData.light().copyWith(
                                                      colorScheme: ColorScheme.light(
                                                          primary: colorPrimary),
                                                      buttonTheme:
                                                      ButtonThemeData(
                                                          textTheme: ButtonTextTheme
                                                              .accent),
                                                    ),
                                                    // This will change to light theme.
                                                    child: child!,
                                                  );
                                                },
                                              ).then((date) {
                                                if (date != null) {
                                                  setState(() {
                                                    endDateController.text =
                                                        ourFormat.format(date);
                                                  });
                                                }
                                              });
                                            },
                                            child: AbsorbPointer(
                                              child: LabelWidget(
                                                labelText: "End Date",
                                                controller: endDateController,
                                              ),
                                            ),
                                          ),
                                          custom_btn(
                                            onPressed: () {
                                              _btnActionprintPdf(context);
                                            },
                                            text: "Print",
                                            textColor: colorWhite,
                                            backcolor: colorPrimary,
                                          )
                                        ],
                                      ),

                                    ],
                                  )

                              ),
                            ]),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),

        ),
      );
    });
    }}

// Column(
// children: [
// SizedBox(
// height: size.height * 0.02,
// ),
// Center(
// child: GestureDetector(
// onTap: () {
// CustomBottomSheetCamera.bottomSheet(context, () {
// chooseImage(context, ImageSource.camera);
// }, () {
//
// _getFile();
// });
// },
// child: CircleAvatar(
// radius: 55,
// backgroundColor: colorPrimary,
// child: _image != null
// ? ClipRRect(
// borderRadius: BorderRadius.circular(50),
// child: Image.file(
// _image!,
// width: 100,
// height: 100,
// fit: BoxFit.cover,
// ),
// )
// : stockImage != null
// ? ClipRRect(
// borderRadius: BorderRadius.circular(50),
// child: Image.network(
// stockImage.toString(),
// width: 100,
// height: 100,
// fit: BoxFit.cover,
// ),
// )
// : Container(
// decoration: BoxDecoration(
// color: Colors.grey[200],
// borderRadius: BorderRadius.circular(50)),
// width: 100,
// height: 100,
// child: Icon(
// Icons.camera_alt,
// color: Colors.grey[800],
// ),
// ),
// ),
// ),
// ),
// SizedBox(
// height: size.height * 0.01,
// ),
// Text(
// "Select Logo",
// style:
// TextStyle(color: Colors.black, fontSize: size.width * 0.034),
// ),
// SizedBox(
// height: size.height * 0.01,
// ),
// Center(
// child: DropdownButton(
// underline: Divider(
// color: colorPrimary,
// ),
// hint: Text(
// 'Please choose logo location'), // Not necessary for Option 1
// value: _selectedLocation,
// onChanged: (newValue) {
// setState(() {
// _selectedLocation = newValue.toString();
// });
// },
// items: _locations.map((location) {
// return DropdownMenuItem(
// child: new Text(location),
// value: location,
// );
// }).toList(),
// ),
// ),
// GestureDetector(
// onTap: () {
// showDatePicker(
// // builder: ,
// context: context,
// initialDate: DateTime.now(),
// firstDate: DateTime(2018),
// lastDate: DateTime(2025),
// builder: (context, child) {
// return Theme(
// data: ThemeData.light().copyWith(
// colorScheme: ColorScheme.light(primary: colorPrimary),
// buttonTheme:
// ButtonThemeData(textTheme: ButtonTextTheme.accent),
// ), // This will change to light theme.
// child: child!,
// );
// },
// ).then((date) {
// if (date != null) {
// setState(() {
// fromDataController.text = ourFormat.format(date);
// });
// }
// });
// },
// child: AbsorbPointer(
// child: LabelWidget(
// labelText: "Start Date",
// controller: fromDataController,
// ),
// ),
// ),
// SizedBox(
// height: size.height * 0.02,
// ),
// GestureDetector(
// onTap: () {
// showDatePicker(
// // builder: ,
// context: context,
// initialDate: DateTime.now(),
// firstDate: DateTime(2018),
// lastDate: DateTime(2025),
// builder: (context, child) {
// return Theme(
// data: ThemeData.light().copyWith(
// colorScheme: ColorScheme.light(primary: colorPrimary),
// buttonTheme:
// ButtonThemeData(textTheme: ButtonTextTheme.accent),
// ), // This will change to light theme.
// child: child!,
// );
// },
// ).then((date) {
// if (date != null) {
// setState(() {
// toDateController.text = ourFormat.format(date);
// });
// }
// });
// },
// child: AbsorbPointer(
// child: LabelWidget(
// labelText: "End Date",
// controller: toDateController,
// ),
// ),
// ),
// custom_btn(
// onPressed: () {
// _btnActionprint(context);
// },
// text: "Print",
// textColor: colorWhite,
// backcolor: colorPrimary,
// )
// ],
// ),
