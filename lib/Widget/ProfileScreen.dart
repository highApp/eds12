import 'dart:convert';
import 'dart:developer';

import 'package:eds/Color.dart';
import 'package:eds/LoginToEmployeer/Screeen/Login.dart';
import 'package:eds/LoginToEmployeer/Screeen/updateEmplyer.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/loginResponse.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  String employerId;
  ProfileScreen({required this.employerId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  EmplyerLogin? emplyer;
  LogedInUser? userLogedin;
  DateFormat ourFormat = DateFormat('dd-MM-yyyy');
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _callAPIGetEmployer(context);
    });
  }

  _callAPIGetEmployer(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['empid'] = widget.employerId;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    log(jsonEncode(body));

    ApiManager networkCal =
        ApiManager(APIConstants.getEmployer, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      log(jsonEncode(response));
      if (status == true) {
        userLogedin = LogedInUser.fromMap(response["response"]);

        // userLogedin = emplyerLogin?.response;
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
          backgroundColor: colorPrimary,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdateEmployer(userLogedin!)));
                },
                icon: Icon(Icons.edit))
          ],
        ),
        body: Column(
          children: [
            Container(
              height: size.height * 0.13,
              child: Stack(
                children: [
                  Container(
                    height: size.height * 0.05,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: colorPrimary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          size.width * 0.065,
                        ),
                        bottomRight: Radius.circular(
                          size.width * 0.065,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.001,
                    right: size.width * 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: colorPrimary, width: size.width * 0.009),
                          borderRadius:
                              BorderRadius.circular(size.width * 0.9)),
                      child: CircleAvatar(
                        maxRadius: size.width * 0.095,
                        backgroundColor: Colors.black,
                        foregroundImage: NetworkImage(
                          userLogedin?.employer.image == "" ||
                                  userLogedin?.employer.image == null
                              ? "https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659652_1280.png"
                              : userLogedin!.employer.image,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              userLogedin?.employer.name == null
                  ? ""
                  : userLogedin!.employer.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: size.width * 0.047,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: size.height * 0.005,
            ),
            Text(
              userLogedin?.employer.email == null
                  ? " "
                  : userLogedin!.employer.email,
              style: TextStyle(
                color: colorgre,
                fontSize: size.width * 0.037,
              ),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Column(
              children: [
                ProfileRows(
                  prefixImage: "assets/images/calender.png",
                  suffixtext: userLogedin?.employer.createdAt == null
                      ? ""
                      : ourFormat.format(userLogedin!.employer.createdAt),
                  title: "Founded/Established:",
                ),
                Divider(
                  color: colorgre,
                  height: size.width * 0.001,
                ),
                ProfileRows(
                  prefixImage: "assets/images/Gender.png",
                  suffixtext: userLogedin?.employer.address == null
                      ? ""
                      : userLogedin!.employer.address,
                  title: "Address:",
                ),
                Divider(
                  color: colorgre,
                  height: size.width * 0.001,
                ),
                ProfileRows(
                  prefixImage: "assets/images/owner.png",
                  suffixtext: "",
                  title: "Owners/Directors:",
                ),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: userLogedin?.owners == null
                        ? 0
                        : userLogedin!.owners.length,
                    itemBuilder: (context, index) => ProfileListViewCell(
                          titleTextList: userLogedin!.owners[index].name,
                        )),
                Divider(
                  color: colorgre,
                  height: size.width * 0.001,
                ),
                ProfileRows(
                  prefixImage: "assets/images/contacts.png",
                  suffixtext: "",
                  title: "Contact No:",
                ),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: userLogedin?.contacts == null
                        ? 0
                        : userLogedin!.contacts.length,
                    itemBuilder: (context, index) => ProfileListViewCell(
                          titleTextList: userLogedin!.contacts[index].number,
                        )),
                Divider(
                  color: colorgre,
                  height: size.width * 0.001,
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 0.6,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        //HelperFunctions.saveInPreference("userId", "");
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Login()),
                            (Route<dynamic> route) => false);
                      },
                      icon: Icon(
                        Icons.login_outlined,
                        color: colorPrimary,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileListViewCell extends StatelessWidget {
  String titleTextList;
  ProfileListViewCell({required this.titleTextList});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        left: size.width * 0.17,
        bottom: size.height * 0.01,
      ),
      child: Row(
        children: [
          Icon(
            Icons.fiber_manual_record,
            size: size.width * 0.025,
            color: colorBlack,
          ),
          SizedBox(
            width: size.width * 0.025,
          ),
          Text(
            titleTextList,
            style: TextStyle(
              color: colorgre,
              fontSize: size.width * 0.037,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileRows extends StatelessWidget {
  String prefixImage;
  String title;
  String suffixtext;
  ProfileRows(
      {required this.prefixImage,
      required this.title,
      required this.suffixtext});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.025,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
          child: Row(
            children: [
              Image.asset(
                prefixImage,
                width: size.width * 0.065,
                height: size.width * 0.065,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: size.width * 0.06,
              ),
              Text(
                title == null ? "" : title,
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 0.6,
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: size.width * 0.08,
              ),
              Expanded(
                child: Text(
                  suffixtext == null ? "" : suffixtext,
                  style: TextStyle(
                    color: colorgre,
                    fontSize: size.width * 0.039,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.025,
        ),
      ],
    );
  }
}
