import 'dart:convert';
import 'dart:developer';

import 'package:eds/Widget/LabelWidget.dart';
import 'package:eds/Widget/btn_widget.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/models/stock_oobject.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import '../../Color.dart';

class ExpenseScreen extends StatefulWidget {
  Stock singleStock;
  ExpenseScreen({required this.singleStock});
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final quantityController = TextEditingController();
  final saleamontController = TextEditingController();
  final pnameController = TextEditingController();
  bool isLoading = false;

  _btnActionaddQuantity(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (quantityController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("stock quantity is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (saleamontController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("sales amount is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else if (pnameController.text == '') {
      HelperFunctions.showAlert(
          context: context,
          header: "EDS",
          widget: Text("payee name is required"),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {});
    } else {
      callAPIgetAllStocks(context);
    }
  }

  callAPIgetAllStocks(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> body = Map<String, dynamic>();

    body['sid'] = widget.singleStock.id;
    body['quantity'] = quantityController.text;
    body['saleAmount'] = saleamontController.text;
    body['pname'] = pnameController.text;

    Map<String, String> header = Map<String, String>();
    log(jsonEncode(body));

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.addExpense, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      print('Back from api');
      setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      print(status);
      if (status == true) {
        HelperFunctions.showAlert(
          context: context,
          header: "Eltuv",
          widget: Text(response["message"]),
          btnDoneText: "ok",
          onDone: () {
            quantityController.clear();
            Navigator.pop(context);
          },
          onCancel: () {
            quantityController.clear();
          },
        );

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CustomLoader(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorPrimary,
          centerTitle: true,
          title: Text(
            "Sale Screen",
            style: TextStyle(
                color: colorWhite,
                fontWeight: FontWeight.w900,
                fontSize: size.height * 0.024),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: size.width,
                        height: size.height * 0.28,
                        decoration: BoxDecoration(
                          color: colorPrimary,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                widget.singleStock.image.toString(),
                                height: size.height * 0.12,
                                width: size.height * 0.12,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.07),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: size.height * 0.2,
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(10),
                              color: colorWhite,
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.02,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Text(
                                      widget.singleStock.productName.toString(),
                                      style: TextStyle(
                                          color: colorBlack,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.2,
                                          fontSize: size.height * 0.023),
                                    ),
                                    Divider(
                                      color: colorgrey.withOpacity(0.3),
                                    ),
                                    Text(
                                      widget.singleStock.description.toString(),
                                      style: TextStyle(
                                          color: colorgrey,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.2,
                                          fontSize: size.height * 0.018),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Amount",
                                          style: TextStyle(
                                              color: colorgrey,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.16,
                                              fontSize: size.height * 0.02),
                                        ),
                                        Text(
                                          "\$" +
                                              widget.singleStock.amount
                                                  .toString(),
                                          style: TextStyle(
                                              color: colorgrey,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.16,
                                              fontSize: size.height * 0.022),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Quantity",
                                          style: TextStyle(
                                              color: colorgrey,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.16,
                                              fontSize: size.height * 0.02),
                                        ),
                                        Text(
                                          widget.singleStock.quantity
                                              .toString(),
                                          style: TextStyle(
                                              color: colorgrey,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.16,
                                              fontSize: size.height * 0.022),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Labour",
                                          style: TextStyle(
                                              color: colorgrey,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.16,
                                              fontSize: size.height * 0.02),
                                        ),
                                        Text("\$" +
                                          widget.singleStock.labour.toString(),
                                          style: TextStyle(
                                              color: colorgrey,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.16,
                                              fontSize: size.height * 0.022),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Optional amount",
                                          style: TextStyle(
                                              color: colorgrey,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.16,
                                              fontSize: size.height * 0.02),
                                        ),
                                        Text("\$" +
                                          widget.singleStock.optionalAmount
                                              .toString(),
                                          style: TextStyle(
                                              color: colorgrey,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.16,
                                              fontSize: size.height * 0.022),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            LabelWidget(
                              labelText: "Add quantiy",
                              controller: quantityController,
                              inputType: TextInputType.number,
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            LabelWidget(
                              labelText: "sale unit price",
                              controller: saleamontController,
                              inputType: TextInputType.number,
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            LabelWidget(
                              labelText: "payee name",
                              controller: pnameController,
                            ),
                            custom_btn(
                              onPressed: () {
                                _btnActionaddQuantity(context);
                              },
                              text: "Add Sale",
                              textColor: colorWhite,
                              backcolor: colorPrimary,
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
