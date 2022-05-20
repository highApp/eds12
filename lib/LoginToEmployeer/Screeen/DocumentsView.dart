import 'dart:convert';
import 'dart:io';

import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/documentsRespose.dart';
import 'package:eds/models/getDocumentObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Color.dart';

class DocumentsView extends StatefulWidget {
  String? gid;
  DocumentsView({required this.gid});
  // const DocumentsView({Key? key}) : super(key: key);

  @override
  _DocumentsViewState createState() => _DocumentsViewState();
}

class _DocumentsViewState extends State<DocumentsView> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      print("In Docs view");
      _callAPIGetDocumets(context);
    });
  }

  bool isLoading = false;
  File? _file1;
  File? _file2;
  File? _file3;
  File? _file4;
  File? _file5;

  String firstPath = "";
  String secondPath = "";
  String thirdPath = "";
  String fourthPath = "";
  String fifthPath = "";
  // late CustomMultipartObject fileObject1;
  // late CustomMultipartObject fileObject2;

  GetDocumentObject? documentObject;
  DocumentRespose? documentRespose;

  _callAPIGetDocumets(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.gid;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.getDocs, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        documentObject = GetDocumentObject.fromMap(response);
        documentRespose = documentObject!.response;
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

  _openPDF(String fileName) async {
    String url = fileName;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Konnte nicht gestartet werden $url';
    }
  }

  _getPDFDocument(
      {required int fileNumber, required ImageSource imageSource}) async {
    // File? result;
    File? result = await HelperFunctions.pickImage(imageSource);

    if (result != null) {
      print(fileNumber);
      if (fileNumber == 1) {
        _file1 = result;

        _splitText(imagePath: _file1.toString(), path: "firstPath");
      } else if (fileNumber == 2) {
        _file2 = result;
        print(_file2);
        _splitText(imagePath: _file2.toString(), path: "secondPath");
      } else if (fileNumber == 3) {
        _file3 = result;
        print(_file3);
        _splitText(imagePath: _file3.toString(), path: "thirdPath");
      } else if (fileNumber == 4) {
        _file4 = result;
        print(_file4);
        _splitText(imagePath: _file4.toString(), path: "fourthPath");
      } else if (fileNumber == 5) {
        _file5 = result;
        print(_file5);
        _splitText(imagePath: _file5.toString(), path: "fifthPath");
      }
    } else {
      // User canceled the picker
    }
  }

  _splitText({required String imagePath, required String path}) {
    print("Splinting text");
    if (path == "firstPath") {
      print("in first ");
      setState(() {
        firstPath = imagePath.split("/").last.toString();
        print("first path  = " + firstPath);
      });
    } else if (path == "secondPath") {
      setState(() {
        secondPath = imagePath.split("/").last.toString();
      });
    } else if (path == "thirdPath") {
      setState(() {
        thirdPath = imagePath.split("/").last.toString();
      });
    } else if (path == "fourthPath") {
      setState(() {
        fourthPath = imagePath.split("/").last.toString();
      });
    } else if (path == "fifthPath") {
      setState(() {
        fifthPath = imagePath.split("/").last.toString();
      });
    }
  }

  Future<DocumentsResponce?> _documentsView() async {
    this.setState(() {
      isLoading = true;
    });

    String apiUrl = APIConstants.baseURL + APIConstants.addDocs;

    print(apiUrl);
    var file1;
    if (_file1 != null) {
      print("1");
      file1 = await http.MultipartFile.fromPath(
          'idPassport', _file1!.path.toString());
    }
    var file2;
    if (_file2 != null) {
      print("2");
      file2 = await http.MultipartFile.fromPath(
          'contract', _file2!.path.toString());
    }
    var file3;
    if (_file3 != null) {
      print("3");
      file3 =
          await http.MultipartFile.fromPath('warning', _file3!.path.toString());
    }
    var file4;
    if (_file4 != null) {
      print("4");
      file4 =
          await http.MultipartFile.fromPath('ccma', _file4!.path.toString());
    }
    var file5;
    if (_file5 != null) {
      print("5");
      file5 =
          await http.MultipartFile.fromPath('other', _file5!.path.toString());
    }

    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(apiUrl));
    print(imageUploadRequest.fields);

    imageUploadRequest.fields['gid'] = widget.gid.toString();

    if (_file1 != null) {
      print("File 1 has data");
      imageUploadRequest.files.add(file1);
    }
    if (file2 != null) {
      print("File 2 has data");
      imageUploadRequest.files.add(file2);
    }
    if (file3 != null) {
      print("File 3 has data");
      imageUploadRequest.files.add(file3);
    }
    if (file4 != null) {
      print("File 4 has data");
      imageUploadRequest.files.add(file4);
    }
    if (file5 != null) {
      print("File 2 has data");
      imageUploadRequest.files.add(file5);
    }

    try {
      final streamedResponse = await imageUploadRequest
          .send()
          .timeout(const Duration(seconds: 15), onTimeout: () {
        // Time has run out, do what you wanted to do.
        return HelperFunctions.showAlert(
            context: context,
            header: "EDS",
            widget: Text("'The connection has timed out, Please try again!'"),
            onDone: () {
              setState(() {
                isLoading = false;
              });
            },
            btnDoneText: "ok",
            onCancel: () {}); // Replace 500 with your http code.
      });
      final response = await http.Response.fromStream(streamedResponse);
      _file1 = null;
      _file2 = null;
      _file3 = null;
      _file4 = null;
      _file5 = null;

      if (response.statusCode != 200) {
        this.setState(() {
          isLoading = false;
        });

        // Fluttertoast.showToast(msg: "Cannot Connect with server");

        return null;
      } else {
        this.setState(() {
          isLoading = false;
        });
        final String responseString = response.body;
        var message = jsonDecode(responseString);

        HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text(message["message"]),
          onDone: () {
            Navigator.pop(context);
          },
          btnDoneText: "ok",
          onCancel: () {},
        );
        return documentResponceFromJSON(responseString);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          title: Text(
            "Documents",
            style: TextStyle(color: Colors.black, fontSize: size.width * 0.047),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.09),
              Text(
                "Upload Documents",
                style: TextStyle(
                    color: Color(0xFF192933),
                    fontWeight: FontWeight.w700,
                    fontSize: 22),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.07,
                    vertical: size.height * 0.02),
                child: Text(
                  "Please upload all required documents\n for employee",
                  style: TextStyle(
                      color: Color(0xFF9098B1),
                      fontWeight: FontWeight.w400,
                      fontSize: size.width * 0.04),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              _data(
                  onPressed: () {
                    documentObject?.response.cnic != null &&
                            documentObject?.response.cnic != ""
                        ? _openPDF(documentRespose!.cnic)
                        : showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            )),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _getPDFDocument(
                                              fileNumber: 1,
                                              imageSource: ImageSource.camera);
                                        },
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: size.width * 0.065,
                                          color: Colors.black,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          _getPDFDocument(
                                            fileNumber: 1,
                                            imageSource: ImageSource.gallery,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.collections,
                                          size: size.width * 0.065,
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                              );
                            });
                  },
                  text: "ID/Passport:",
                  document: documentObject?.response.cnic == null ||
                          documentRespose!.cnic == ""
                      ? null
                      : documentRespose!.cnic,
                  image: "assets/images/upload.png",
                  isShowDelete: documentObject?.response.cnic == null ||
                          documentObject?.response.cnic == ""
                      ? false
                      : true,
                  onIconPress: () {
                    HelperFunctions.showAlert(
                        context: context,
                        header: "EDS",
                        widget: Text(
                            "Are you sure you want to delete this document?"),
                        onDone: () {
                          setState(() {
                            documentObject?.response.cnic = "";
                          });
                        },
                        onCancel: () {},
                        btnCancelText: "cancel",
                        btnDoneText: "delete");
                  }),
              Text(
                firstPath,
                style: TextStyle(
                    color: Color(0xFF192933),
                    fontWeight: FontWeight.w400,
                    fontSize: size.width * 0.033),
              ),
              _data(
                  onPressed: () {
                    documentObject?.response.contract != null &&
                            documentObject?.response.contract != ""
                        ? _openPDF(documentRespose!.contract)
                        : showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            )),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _getPDFDocument(
                                              fileNumber: 2,
                                              imageSource: ImageSource.camera);
                                        },
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: size.width * 0.065,
                                          color: Colors.black,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          _getPDFDocument(
                                            fileNumber: 2,
                                            imageSource: ImageSource.gallery,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.collections,
                                          size: size.width * 0.065,
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                              );
                            });
                  },
                  text: "Employment Contract:",
                  document: documentObject?.response.contract == null ||
                          documentObject?.response.contract == ""
                      ? null
                      : documentRespose!.contract,
                  image: "assets/images/upload.png",
                  isShowDelete: documentObject?.response.contract == null ||
                          documentObject?.response.contract == ""
                      ? false
                      : true,
                  onIconPress: () {
                    HelperFunctions.showAlert(
                        context: context,
                        header: "EDS",
                        widget: Text(
                            "Are you sure you want to delete this document?"),
                        onDone: () {
                          setState(() {
                            documentObject?.response.contract = "";
                          });
                        },
                        onCancel: () {},
                        btnCancelText: "cancel",
                        btnDoneText: "delete");
                  }),
              Text(
                secondPath,
                style: TextStyle(
                    color: Color(0xFF192933),
                    fontWeight: FontWeight.w400,
                    fontSize: size.width * 0.033),
              ),
              _data(
                  onPressed: () {
                    documentObject?.response.warning != null &&
                            documentObject?.response.warning != ""
                        ? _openPDF(documentRespose!.warning)
                        : showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            )),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _getPDFDocument(
                                              fileNumber: 3,
                                              imageSource: ImageSource.camera);
                                        },
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: size.width * 0.065,
                                          color: Colors.black,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          _getPDFDocument(
                                            fileNumber: 3,
                                            imageSource: ImageSource.gallery,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.collections,
                                          size: size.width * 0.065,
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                              );
                            });
                  },
                  text: "Written Warnings:",
                  isShowDelete: documentObject?.response.warning == null ||
                          documentObject?.response.warning == ""
                      ? false
                      : true,
                  document: documentObject?.response.warning == null ||
                          documentObject?.response.warning == ""
                      ? null
                      : documentRespose!.warning,
                  image: "assets/images/upload.png",
                  onIconPress: () {
                    HelperFunctions.showAlert(
                        context: context,
                        header: "EDS",
                        widget: Text(
                            "Are you sure you want to delete this document?"),
                        onDone: () {
                          setState(() {
                            documentObject?.response.warning = "";
                          });
                        },
                        onCancel: () {},
                        btnCancelText: "cancel",
                        btnDoneText: "delete");
                  }),
              Text(
                thirdPath,
                style: TextStyle(
                    color: Color(0xFF192933),
                    fontWeight: FontWeight.w400,
                    fontSize: size.width * 0.033),
              ),
              _data(
                  onPressed: () {
                    documentObject?.response.ccma != null &&
                            documentObject?.response.ccma != ""
                        ? _openPDF(documentRespose!.ccma)
                        : showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            )),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _getPDFDocument(
                                              fileNumber: 4,
                                              imageSource: ImageSource.camera);
                                        },
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: size.width * 0.065,
                                          color: Colors.black,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          _getPDFDocument(
                                            fileNumber: 4,
                                            imageSource: ImageSource.gallery,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.collections,
                                          size: size.width * 0.065,
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                              );
                            });
                  },
                  text: "CCMA Documents:",
                  isShowDelete: documentObject?.response.ccma == null ||
                          documentObject?.response.ccma == ""
                      ? false
                      : true,
                  document: documentObject?.response.ccma == null ||
                          documentObject?.response.ccma == ""
                      ? null
                      : documentRespose!.ccma,
                  image: "assets/images/upload.png",
                  onIconPress: () {
                    HelperFunctions.showAlert(
                        context: context,
                        header: "EDS",
                        widget: Text(
                            "Are you sure you want to delete this document?"),
                        onDone: () {
                          setState(() {
                            documentObject?.response.ccma = "";
                          });
                        },
                        onCancel: () {},
                        btnCancelText: "cancel",
                        btnDoneText: "delete");
                  }),
              Text(
                fourthPath,
                style: TextStyle(
                    color: Color(0xFF192933),
                    fontWeight: FontWeight.w400,
                    fontSize: size.width * 0.033),
              ),
              _data(
                  onPressed: () {
                    documentObject?.response.other != null &&
                            documentObject?.response.other != ""
                        ? _openPDF(documentRespose!.other.toString())
                        : showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            )),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _getPDFDocument(
                                              fileNumber: 5,
                                              imageSource: ImageSource.camera);
                                        },
                                        icon: Icon(
                                          Icons.camera_alt,
                                          size: size.width * 0.065,
                                          color: Colors.black,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          _getPDFDocument(
                                            fileNumber: 5,
                                            imageSource: ImageSource.gallery,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.collections,
                                          size: size.width * 0.065,
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                              );
                            });
                  },
                  text: "Other:",
                  document: documentObject?.response.other == null ||
                          documentObject?.response.other == ""
                      ? null
                      : documentRespose!.other,
                  image: "assets/images/upload.png",
                  isShowDelete: documentObject?.response.other == null ||
                          documentObject?.response.other == ""
                      ? false
                      : true,
                  onIconPress: () {
                    HelperFunctions.showAlert(
                        context: context,
                        header: "EDS",
                        widget: Text(
                            "Are you sure you want to delete this document?"),
                        onDone: () {
                          setState(() {
                            documentObject?.response.other = "";
                          });
                        },
                        onCancel: () {},
                        btnCancelText: "cancel",
                        btnDoneText: "delete");
                  }),
              Text(
                fifthPath,
                style: TextStyle(
                    color: Color(0xFF192933),
                    fontWeight: FontWeight.w400,
                    fontSize: size.width * 0.033),
              ),
              custom_btn(
                onPressed: () {
                  _documentsView();
                },
                text: "Send",
                textColor: colorWhite,
                backcolor: colorPrimary,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _data({text, image, onPressed, document, onIconPress, isShowDelete}) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.04, vertical: size.height * 0.01),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                  color: Color(0xFF192933),
                  fontWeight: FontWeight.w600,
                  fontSize: size.width * 0.04),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onPressed,
                    child: document == null
                        ? Image.asset(
                            image,
                            height: size.height * 0.06,
                          )
                        : Text(
                            document,
                            maxLines: 2,
                            style: TextStyle(
                              color: colorgre,
                              fontSize: size.width * 0.036,
                            ),
                          ),
                  ),
                ),
                isShowDelete
                    ? IconButton(
                        onPressed: onIconPress,
                        icon: Icon(
                          Icons.delete,
                          size: size.width * 0.065,
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
