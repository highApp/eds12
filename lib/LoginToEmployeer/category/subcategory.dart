import 'package:eds/Color.dart';
import 'package:eds/LoginToEmployeer/Screeen/StockScreen/add_stock.dart';
import 'package:eds/LoginToEmployeer/category/SubcategoryResponse.dart';
import 'package:eds/LoginToEmployeer/category/categoryResponse.dart';
import 'package:eds/LoginToEmployeer/category/new_subcategory.dart';

import 'package:eds/managers/api_manager.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/customloader.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Subcategory extends StatefulWidget {
  final CategoryModel? Model;

  Subcategory({Key? key, required this.Model}) : super(key: key);

  @override
  _SubcategoryState createState() => _SubcategoryState();
}

class _SubcategoryState extends State<Subcategory> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      callAPISubCategory(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            size: size.height * 0.03,
          ),
        ),
        backgroundColor: colorPrimary,
        title: Text(
          'Select Subcategory',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          color: Colors.white,
                          child: AddSubCategory(
                            catId: widget.Model!.id.toString(),
                            subcatAdded: () {
                              callAPISubCategory(context);
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: size.height * 0.033,
                ),
              ))
        ],
      ),
      body: CustomLoader(
        isLoading: isLoading,
        child: Column(
          mainAxisAlignment: subCategoryObject == ''
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.01,
            ),
            subCategoryObject == ''
                ? Center(
                    child: Text("No Subcategory Found"),
                  )
                : ListView.builder(
                    itemCount: subCategoryObject == null &&
                            subCategoryObject?.response == null
                        ? 0
                        : subcategory.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (BuildContext context, int index) {
                      SubcategModel subcategorymodel = subcategory[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddStockScreen(
                                  categoryModel: widget.Model,
                                  subcategModel: subcategorymodel)));

                          // counterBlok.catSink.add(
                          //   widget.Model
                          // );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                          ),
                          child: Column(
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
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            subcategorymodel.image == null
                                                ? ''
                                                : subcategorymodel.image,
                                            height: size.height * 0.08,
                                            width: size.height * 0.08,
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(500),
                                                child: Image(
                                                    height: size.height * 0.08,
                                                    width: size.height * 0.08,
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        "https://i2.wp.com/asvs.in/wp-content/uploads/2017/08/dummy.png")),
                                              );
                                            },
                                          )),
                                      SizedBox(
                                        width: size.width * 0.03,
                                      ),
                                      Text(
                                        subcategorymodel.name,
                                        style: TextStyle(
                                            color: colorBlack,
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: colorPrimary,
                                    size: size.height * 0.04,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.001,
                              ),
                              Divider(
                                color: colorBlack.withOpacity(0.5),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
          ],
        ),
      ),
    );
  }

  SubCategoryObject? subCategoryObject;
  late List<SubcategModel> subcategory = [];

  callAPISubCategory(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> body = Map<String, dynamic>();

    body['cid'] = widget.Model!.id;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.getSubCategory, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      print('Back from api');
      setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      print(status);
      if (status == true) {
        subCategoryObject = SubCategoryObject.fromMap(response);
        print("status  " + subCategoryObject!.status.toString());
        if (subCategoryObject!.response != null) {
          subcategory = subCategoryObject!.response!;
        }
      } else {
        HelperFunctions.showAlert(
          context: context,
          header: "Eds",
          widget: Text(response["message"]),
          btnDoneText: "ok",
          onDone: () {},
          onCancel: () {},
        );
      }
    });
  }
}
