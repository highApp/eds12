import 'dart:convert';
import 'dart:developer';

import 'package:eds/LoginToEmployeer/Screeen/NewEmployee.dart';
import 'package:eds/LoginToEmployeer/Screeen/StockScreen/StockScreen.dart';
import 'package:eds/Widget/AddEmployeeList.dart';
import 'package:eds/Widget/ProfileScreen.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/homeDashboardObject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../Color.dart';

class Dashboard extends StatefulWidget {
  String employerId;

  Dashboard({
    required this.employerId,
  });

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? employerid;
  String employerimage = "";
  String? employerName = "";

  @override
  void initState() {
    super.initState();
    HelperFunctions.getFromPreference("userId").then(
      (value) => employerid = value,
    );
    HelperFunctions.getFromPreference("userImage").then(
      (value) => employerimage = value,
    );
    HelperFunctions.getFromPreference("userName").then(
      (value) => employerName = value,
    );
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _callAPIHome(context);
    });
  }

  bool keyboardIsOpened = false;
  bool isLoading = false;
  late EmplyerDashboardObject emplyerDashboardObject;
  List<Users> users = [];
  List<Users> newArray = [];

  _callAPIHome(BuildContext context) {
    this.setState(() {
      isLoading = true;
    });

    Map<String, dynamic> body = Map<String, dynamic>();

    body['empid'] = widget.employerId;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());
    log(jsonEncode(body));

    ApiManager networkCal = ApiManager(APIConstants.home, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      // log(jsonEncode(response));
      print('Back from api');

      this.setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      if (status == true) {
        emplyerDashboardObject = EmplyerDashboardObject.fromMap(response);

        users = emplyerDashboardObject.response;
        newArray = users;
        print(
            "print length" + emplyerDashboardObject.response.length.toString());

        // logedInUser = emplyerLogin.response;
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

  onItemChanged(String value) {
    setState(() {
      print("change called");

      users = users
          .where((select) =>
              select.name!.toLowerCase().startsWith(value.toLowerCase()))
          .toList();
    });
  }

  bool isEmpty = false;
  void showHide() {
    if (users.isEmpty) {
      setState(() {
        isEmpty = true;
      });
    } else {
      setState(() {
        isEmpty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/home.png",
                  width: size.width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: size.height * 0.07,
                  child: InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => EmployeeView(singleUser: users[],)),
                      // );
                    },
                    child: Container(
                      width: size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: size.width * 0.04,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                        employerId:
                                            widget.employerId.toString(),
                                      )));
                            },
                            child: Container(
                              padding: EdgeInsets.all(size.width * 0.005),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(size.width * 0.06)),
                              child: CircleAvatar(
                                maxRadius: size.width * 0.055,
                                backgroundColor: Colors.black,
                                foregroundImage: NetworkImage(employerimage ==
                                        ""
                                    ? "https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659652_1280.png"
                                    : employerimage),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.045,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.043,
                                ),
                              ),
                              SizedBox(
                                height: size.width * 0.01,
                              ),
                              Text(
                                "Hi, " + employerName!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width * 0.049,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SizedBox(
                              width: size.width * 0.05,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => StockScreen(
                                    employerId: widget.employerId,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.home_work,
                              size: size.width * 0.065,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.05,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.175,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.03),
                      child: Material(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        elevation: 5,
                        child: TextField(
                          cursorColor: colorPrimary,
                          decoration: InputDecoration(
                            hintText: "Search...",
                            hintStyle: TextStyle(
                                color: colorgre,
                                fontWeight: FontWeight.w500,
                                fontSize: size.width * 0.035),
                            prefixIcon: Icon(
                              Icons.search,
                              color: colorBlack.withOpacity(0.5),
                              size: size.width * 0.06,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: size.height * 0.023,
                            ),
                          ),
                          onChanged: (value) {
                            if (value == null || value == "") {
                              print(value);
                              print(newArray.length);
                              setState(() {
                                users = newArray;
                              });
                              showHide();
                            } else {
                              users = newArray;
                              onItemChanged(value);
                              showHide();
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    isEmpty
                        ? Center(
                            child: Text("Nothing Matches the Search"),
                          )
                        : AddEmployee(
                            user: users,
                            editDone: () {
                              _callAPIHome(context);
                            },
                          ),
                  ],
                )
              ],
            ),
          ),
          floatingActionButton: keyboardIsOpened
              ? null
              : FloatingActionButton.extended(
                  backgroundColor: Color(0xFF223263),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewEmployee(
                                employerid: int.parse(employerid.toString()),
                              )),
                    ).then((value) => _callAPIHome(context));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  icon: Icon(
                    Icons.person_add_alt_1_outlined,
                    color: colorWhite,
                    size: size.width * 0.055,
                  ),
                  label: Text(
                    "Add Employee",
                    style: TextStyle(
                      color: colorWhite,
                      fontSize: size.width * 0.029,
                    ),
                  ),
                )),
    );
  }
}
