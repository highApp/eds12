import 'package:eds/Color.dart';
import 'package:eds/LoginToEmployeer/ExpanseScreen/printExpenseScreen.dart';
import 'package:eds/LoginToEmployeer/Screeen/StockScreen/profitObject.dart';
import 'package:eds/LoginToEmployeer/Screeen/StockScreen/remaining_stock.dart';
import 'package:eds/LoginToEmployeer/Screeen/StockScreen/stocks.dart';
import 'package:eds/LoginToEmployeer/category/category.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StockScreen extends StatefulWidget {
  String employerId = "";

  StockScreen({required this.employerId});
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;
  ProfitObject? profitObject;

  callAPIgetProfit(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> body = Map<String, dynamic>();

    body['empid'] = widget.employerId;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.getProfit, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      print('Back from api');
      setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      print(status);
      if (status == true) {
        profitObject = ProfitObject.fromMap(response);
      } else {
        HelperFunctions.showAlert(
          context: context,
          header: "Eltuv",
          widget: Text(response["message"]),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {},
        );
      }
    });
  }

  Tab _bottomBarNavigation(String tabName, bool isSelected) {
    return Tab(
      icon: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.003,
          ),
          Text(
            tabName,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.03,
              color: isSelected ? colorPrimary : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      callAPIgetProfit(context);
    });
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    if (_tabController != null) {
      _tabController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorPrimary,
        centerTitle: true,
        title: Text(
          "Stock",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: size.height * 0.024),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PrintexpenseScreen(
                          empId: widget.employerId,
                        )));
              },
              icon: Icon(
                Icons.local_print_shop,
                size: size.width * 0.065,
              ))
        ],
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      bottomNavigationBar: SafeArea(
        child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.transparent,
            tabs: [
              _tabController!.index == 0
                  ? _bottomBarNavigation('All Stock', true)
                  : _bottomBarNavigation('All Stock', false),
              _tabController!.index == 1
                  ? _bottomBarNavigation('Sale Stock', true)
                  : _bottomBarNavigation('Sale Stock', false),
            ]),
      ),
      body: Column(
        children: [
          Container(
            color: colorPrimary,
            height: size.height * 0.25,
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: size.width * 0.52,
                  height: size.width * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  profitLoassRow(
                                      prefixText: "Total amount",
                                      postFixText: profitObject
                                          ?.response?.totalAmount
                                          .toString()),
                                  profitLoassRow(
                                      prefixText: "Total Expense",
                                      postFixText: profitObject
                                          ?.response?.totalExpense
                                          .toString()),
                                  profitLoassRow(
                                      prefixText: "Remaining",
                                      postFixText: profitObject
                                          ?.response?.totalRemaining
                                          .toString()),
                                  profitLoassRow(
                                      prefixText: "Profit",
                                      postFixText: profitObject
                                          ?.response?.totalProfit
                                          .toString()),
                                  profitLoassRow(
                                      prefixText: "Loss",
                                      postFixText: profitObject?.response?.totalLose
                                          .toString()),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => category(
                                employerId: widget.employerId,
                              )),
                    );
                  },
                  child: Container(
                    width: size.width * 0.30,
                    height: size.width * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Icon(
                          Icons.add_circle,
                          size: size.height * 0.04,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(
                          "Add Stock",
                          style: TextStyle(
                              color: colorBlack,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.3,
                              fontSize: size.height * 0.016),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                AllStocks(
                  employerId: widget.employerId,
                ),
                RemainingStock(employerId: widget.employerId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget profitLoassRow({String? prefixText, String? postFixText}) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: size.width * 0.002,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              prefixText == null ? "" : prefixText,
              style: TextStyle(
                  color: colorgrey,
                  fontWeight: FontWeight.w400,
                  fontSize: size.height * 0.014),
            ),
            Text(
              postFixText != null ? postFixText + "\$" : "",
              style: TextStyle(
                  color: colorBlack,
                  fontWeight: FontWeight.w900,
                  fontSize: size.height * 0.015),
            ),
          ],
        ),
        SizedBox(
          height: size.width * 0.01,
        ),
      ],
    );
  }
}
