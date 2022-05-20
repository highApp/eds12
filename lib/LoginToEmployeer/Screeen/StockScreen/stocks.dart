import 'package:eds/Color.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/stock_oobject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class AllStocks extends StatefulWidget {
  String employerId = "";
  AllStocks({required this.employerId});

  @override
  _AllStocksState createState() => _AllStocksState();
}

class _AllStocksState extends State<AllStocks> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      callAPIgetAllStocks(context);
    });
  }

  bool isLoading = false;
  StockObject stockObject = new StockObject();
  List<StockObj> newArray = [];
  DateFormat ourFormat = DateFormat('dd-MM-yyyy');

  callAPIgetAllStocks(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> body = Map<String, dynamic>();

    body['empid'] = widget.employerId;
    body['status'] = "all";

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.getStock, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      print('Back from api');
      setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      print(status);
      if (status == true) {
        stockObject = StockObject.fromMap(response);
        if (stockObject.response != null) {
          newArray = stockObject.response!;
        }

        // print(stockObject.message);
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

  onItemChanged(String value) {
    setState(() {
      print("change called");
      if (stockObject.response != null) {
        stockObject.response = stockObject.response!
            .where((select) =>
                select.date!.toLowerCase().startsWith(value.toLowerCase()))
            .toList();
      }
    });
  }

  bool isEmpty = false;
  void showHide() {
    if (stockObject.response != null) {
      if (stockObject.response!.isEmpty) {
        setState(() {
          isEmpty = true;
        });
      } else {
        setState(() {
          isEmpty = false;
        });
      }
    } else {
      setState(() {
        setState(() {
          isEmpty = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return stockObject.response == null
        ? CustomLoader(
            isLoading: isLoading,
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.03,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: Material(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    elevation: 5,
                    child: TextField(
                      cursorColor: colorPrimary,
                      onChanged: (value) {
                        if (value == null || value == "") {
                          print(value);
                          print(newArray.length);
                          setState(() {
                            stockObject.response = newArray;
                          });
                          showHide();
                        } else {
                          stockObject.response = newArray;
                          onItemChanged(value);
                          showHide();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Search by date",
                        hintStyle: TextStyle(
                            color: colorgre,
                            fontWeight: FontWeight.w500,
                            fontSize: size.width * 0.037),
                        prefixIcon: Icon(
                          Icons.search,
                          color: colorgre,
                          size: size.width * 0.055,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: size.width * 0.04,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                  color: Colors.black12,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: size.height * 0.02),
                  child: ListView.builder(
                      itemCount:
                          stockObject == null && stockObject.response == null
                              ? 0
                              : stockObject.response!.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (BuildContext context, int index) {
                        var datesList = stockObject.response![index];
                        return Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.01),
                            child: Container(
                              child: Column(children: [
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      datesList.date.toString(),
                                      style: TextStyle(
                                          fontSize: size.height * 0.02,
                                          fontWeight: FontWeight.w400),
                                    )),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: stockObject.response == null
                                        ? 0
                                        : datesList.stock!.length,
                                    // primary: false,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int ind) {
                                      var stockItem = stockObject
                                          .response![index].stock![ind];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: size.height * 0.01),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                stockItem.image.toString(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.02,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(stockItem.productName
                                                      .toString()),
                                                  Container(
                                                    width: size.width * 0.4,
                                                    child: Text(
                                                        stockItem.description
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  stockItem.amount.toString(),
                                                  style: TextStyle(
                                                      color: colorPrimary,
                                                      fontSize:
                                                          size.height * 0.02),
                                                ),
                                                Text(
                                                  stockItem.quantity.toString(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.03,
                                                      color: Colors.grey),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              ]),
                            ));
                      }),
                ),
              ],
            ),
          );
  }
}
