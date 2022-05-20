import 'dart:io';
import 'package:eds/LoginToEmployeer/Screeen/ContactAdmin.dart';
import 'package:eds/Login_As_Employee/Screen/contactEmployeer.dart';
import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/getDocumentObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Color.dart';

class EmployeeDocumentsView extends StatefulWidget {
  String? gid;
  EmployeeDocumentsView({this.gid});

  @override
  _EmployeeDocumentsViewState createState() => _EmployeeDocumentsViewState();
}

class _EmployeeDocumentsViewState extends State<EmployeeDocumentsView> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      print("In Docs view");
      _callAPIGetDocumets(context);
    });
  }

  bool isLoading = false;

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
                "Uploaded Documents",
                style: TextStyle(
                    color: Color(0xFF192933),
                    fontWeight: FontWeight.w700,
                    fontSize: 22),
              ),
              SizedBox(height: size.height * 0.03),
              _Data(
                  onPressed: () {
                    documentObject?.response.cnic != null &&
                            documentObject?.response.cnic != ""
                        ? _openPDF(documentRespose!.cnic)
                        : () {};
                  },
                  text: "ID/Passport:",
                  document: documentObject?.response.cnic == null ||
                          documentRespose!.cnic == ""
                      ? null
                      : documentRespose!.cnic,
                  onIconPress: () {
                    setState(() {
                      documentObject?.response.cnic = "";
                    });
                  }),
              _Data(
                  onPressed: () {
                    documentObject?.response.contract != null &&
                            documentObject?.response.contract != ""
                        ? _openPDF(documentRespose!.contract)
                        : () {};
                  },
                  text: "Employment Contract:",
                  document: documentObject?.response.contract == null ||
                          documentObject?.response.contract == ""
                      ? null
                      : documentRespose!.contract,
                  onIconPress: () {
                    setState(() {
                      documentObject?.response.contract = "";
                    });
                  }),
              _Data(
                  onPressed: () {
                    documentObject?.response.warning != null &&
                            documentObject?.response.warning != ""
                        ? _openPDF(documentRespose!.warning)
                        : () {};
                  },
                  text: "Written Warnings:",
                  document: documentObject?.response.warning == null ||
                          documentObject?.response.warning == ""
                      ? null
                      : documentRespose!.warning,
                  onIconPress: () {
                    setState(() {
                      documentObject?.response.warning = "";
                    });
                  }),
              _Data(
                  onPressed: () {
                    documentObject?.response.ccma != null &&
                            documentObject?.response.ccma != ""
                        ? _openPDF(documentRespose!.ccma)
                        : () {};
                  },
                  text: "CCMA Documents:",
                  document: documentObject?.response.ccma == null ||
                          documentObject?.response.ccma == ""
                      ? null
                      : documentRespose!.ccma,
                  onIconPress: () {
                    setState(() {
                      documentObject?.response.ccma = "";
                    });
                  }),
              _Data(
                  onPressed: () {
                    documentObject?.response.other != null &&
                            documentObject?.response.other != ""
                        ? _openPDF(documentRespose!.other.toString())
                        : () {};
                  },
                  text: "Other:",
                  document: documentObject?.response.other == null ||
                          documentObject?.response.other == ""
                      ? null
                      : documentRespose!.other,
                  onIconPress: () {
                    setState(() {
                      documentObject?.response.other = "";
                    });
                  }),
              SizedBox(
                height: size.height * 0.17,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      " If you have any questions, please contact admin",
                      style: TextStyle(
                          color: colorBlack,
                          fontSize: size.width * 0.036,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    MaterialButton(
                      color: colorPay,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ContactEmployer(
                                  gid: widget.gid.toString(),
                                )));
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.width * 0.023),
                        child: Text(
                          "Contact Us",
                          style: TextStyle(
                              color: colorBlack,
                              fontSize: size.width * 0.037,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _Data({text, image, onPressed, document, onIconPress}) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.04, vertical: size.height * 0.02),
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
                        ? Container()
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
