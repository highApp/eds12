import 'package:eds/LoginToEmployeer/Screeen/SelectFlag.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/flagsObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Color.dart';

class FlagView extends StatefulWidget {
  String id;
  FlagView({required this.id});

  @override
  _FlagViewState createState() => _FlagViewState();
}

class _FlagViewState extends State<FlagView> {
  bool isLoading = false;
  late FlagsObject? flagsObject;
  late List<Flags> flags = [];
  DateFormat ourFormat = DateFormat('dd-MMMM-yyyy');

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _callAPIFalgView(context);
    });
  }

  _callAPIFalgView(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['gid'] = widget.id;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.getFlag, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        flagsObject = FlagsObject.fromMap(response);
        flags = flagsObject!.response;
        showHide();

        print("print length" + flagsObject!.response.length.toString());
      } else {
        setState(() {
          isEmpty = true;
        });

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

  _callAPDeleteFlag({
    required BuildContext contex,
    required String flagid,
    required String gid,
  }) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['fid'] = flagid;
    body['gid'] = gid;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.deleteFlag, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        _callAPIFalgView(context);
        showHide();
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

  bool isEmpty = false;
  void showHide() {
    if (flagsObject == null || flags.isEmpty) {
      setState(() {
        isEmpty = true;
      });
    } else {
      setState(() {
        isEmpty = false;
      });
    }
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
        backgroundColor: colorWhite,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: colorWhite,
          elevation: 0,
          title: Text(
            "Flag",
            style: TextStyle(
                color: colorText,
                fontSize: size.width * 0.047,
                fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.add_circle_outline_outlined,
                color: colorgre,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectFlag(
                            gid: widget.id,
                          )),
                ).then((value) => _callAPIFalgView(context));
              },
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isEmpty == true
                ? Expanded(
                    child: Center(
                        child: Text(
                      "No data found",
                      style: TextStyle(color: Colors.black),
                    )),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: flags.length == null ? 0 : flags.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.01),
                      decoration: BoxDecoration(
                          color: colorPay,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.03),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.flag,
                                        color: flags[index].flag == "#FF0000"
                                            ? Colors.red
                                            : Colors.orange,
                                        size: size.width * 0.06,
                                      ),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      Text(
                                        flags[index].flag == "#FF0000"
                                            ? 'Red Flag'
                                            : "Orange Flag",
                                        style: TextStyle(
                                            color: colorText,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                        textAlign: TextAlign.justify,
                                      ),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      Icon(
                                        Icons.info_outline_rounded,
                                        color: colorTex,
                                        size: size.width * 0.065,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        ourFormat
                                            .format(flags[index].updatedAt),
                                        style: TextStyle(
                                            color: colorText,
                                            fontWeight: FontWeight.w500,
                                            fontSize: size.width * 0.041),
                                        textAlign: TextAlign.justify,
                                      ),
                                      SizedBox(
                                        width: size.width * 0.01,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          HelperFunctions.showAlert(
                                              context: context,
                                              header: "Attention",
                                              widget: Text(
                                                  "Are you sure to delete flag?"),
                                              btnDoneText: "yes",
                                              onDone: () {
                                                _callAPDeleteFlag(
                                                    contex: context,
                                                    flagid: flags[index]
                                                        .id
                                                        .toString(),
                                                    gid: flags[index].gid);
                                              },
                                              btnCancelText: "no",
                                              onCancel: () {});
                                        },
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.red,
                                          size: size.width * 0.065,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.015,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Police Report',
                                    style: TextStyle(
                                        color: colorText,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                    textAlign: TextAlign.justify,
                                  ),
                                  MaterialButton(
                                    color: Color(0xFFF3F3F3),
                                    onPressed: () {
                                      _openPDF(flags[index].policeReport);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'Download',
                                            style: TextStyle(
                                                color: colorText,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.download_outlined)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ]),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
