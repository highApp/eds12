import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:eds/Color.dart';
import 'package:eds/LoginToEmployeer/finalprint.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared pref/share_pref.dart';

class PrintDetailsScreen extends StatefulWidget {
  final BListModel data;
  final String empID;

  PrintDetailsScreen({required this.data, required this.empID});

  @override
  _PrintDetailsScreenState createState() => _PrintDetailsScreenState();
}

class _PrintDetailsScreenState extends State<PrintDetailsScreen>
    with SingleTickerProviderStateMixin {
  final fromDataController = TextEditingController();

  @override
  void initState() {
    print('EMPID - PrintDetailsScreen - ${widget.empID}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<CoreProvider>(builder: (context, appPro, _) {
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
                "Details of Expenses",
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Buyer Name:-',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: size.width * 0.02),
                        Text(
                          '${appPro.selectedbName}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                        //yha per null a rha
                        // umer bhai dekh rhy hain ap?????JIJIJIJIJIJIJIJIJIJIJIJIIJIOK
                      ],
                    ),

                    // Text('${UserPreferences.getBPrice()}',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.normal),),

                    SizedBox(
                      height: 20,
                    ),

                    Container(
                      // height: size.height*0.3,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.all(Radius.circular(
                                5.0) //                 <--- border radius here
                            ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.data.expenses?.length,
                                // earningModel.withdrawHistory!.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Product Name:-',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          Text(
                                            '${widget.data.expenses?[index].productName}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Unit Price:-',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          Text(
                                            '${widget.data.expenses?[index].unitPrice}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Quantity:-',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          Text(
                                            '${widget.data.expenses?[index].quantity}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'total:-',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.02,
                                          ),
                                          Text(
                                            '${widget.data.expenses?[index].totalPrice}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Divider(
                                        color: Colors.black,
                                        thickness: 2,
                                      ),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),

                                      // SizedBox(height: 100,)
                                    ],
                                  );
                                }),
                          ],
                        ),
                        //fahad
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.01,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: size.width * 0.35,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.all(Radius.circular(
                                    5.0) //                 <--- border radius here
                                ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Text(
                                  'Total:-',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Text(
                                  '${widget.data.totalExpenseAmount}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),

                    custom_btn(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FinalPrintDetailsScreen(
                            empID: widget.empID,
                          ),
                        ));
                      },
                      text: "Print Expenses",
                      textColor: colorWhite,
                      backcolor: colorPrimary,
                    )
                  ],
                ),
              ),
            )),
      );
    });
  }
}

// Center(
//   child: GestureDetector(
//     onTap: () {
//       CustomBottomSheetCamera.bottomSheet(
//           context, () {
//         chooseImage1(
//             context, ImageSource.camera);
//       }, () {
//         _getFile1();
//       });
//     },
//     child: CircleAvatar(
//       radius: 55,
//       backgroundColor: colorPrimary,
//       child: _image1 != null
//           ? ClipRRect(
//         borderRadius: BorderRadius.circular(
//             50),
//         child: Image.file(
//           _image1!,
//           width: 100,
//           height: 100,
//           fit: BoxFit.cover,
//         ),
//       )
//           : stockImage1 != null
//           ? ClipRRect(
//         borderRadius: BorderRadius.circular(
//             50),
//         child: Image.network(
//           stockImage1.toString(),
//           width: 100,
//           height: 100,
//           fit: BoxFit.cover,
//         ),
//       )
//           : Container(
//         decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius
//                 .circular(50)),
//         width: 100,
//         height: 100,
//         child: Icon(
//           Icons.camera_alt,
//           color: Colors.grey[800],
//         ),
//       ),
//     ),
//   ),
// ),
// SizedBox(
//   height: size.height * 0.01,
// ),
// Text(
//   "Select Logo",
//   style:
//   TextStyle(color: Colors.black,
//       fontSize: size.width * 0.034),
// ),
// SizedBox(
//   height: size.height * 0.01,
// ),
// Center(
//   child: DropdownButton(
//     underline: Divider(
//       color: colorPrimary,
//     ),
//     hint: Text(
//         'Please choose logo location'),
//     // Not necessary for Option 1
//     value: _selectedLocation1,
//     onChanged: (newValue) {
//       setState(() {
//         _selectedLocation1 =
//             newValue.toString();
//       });
//     },
//     items: _locations1.map((location1) {
//       return DropdownMenuItem(
//         child: new Text(location1),
//         value: location1,
//       );
//     }).toList(),
//   ),
// ),

//  button
//   custom_btn(
//     onPressed: () {
//       _btnActionprintPdf(context);
//     },
//     text: "Print",
//     textColor: colorWhite,
//     backcolor: colorPrimary,
//   )
