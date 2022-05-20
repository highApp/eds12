import 'package:eds/Color.dart';
import 'package:eds/LoginToEmployeer/category/new_category.dart';
import 'package:eds/LoginToEmployeer/category/subcategory.dart';
import 'package:eds/managers/api_manager.dart';
import 'package:eds/utilities/api_constants.dart';
import 'package:eds/utilities/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'categoryResponse.dart';

class category extends StatefulWidget {
  String employerId = "";
  category({required this.employerId});
  @override
  _categoryState createState() => _categoryState();
}

class _categoryState extends State<category> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((_) {
      callAPICategory(context);
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
          'Select Categories',
          style: TextStyle(color: Colors.white),
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
                          child: NewCategoryScreen(
                            employerId: widget.employerId,
                            catAdded: () {
                              callAPICategory(context);
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
                  size: size.height * 0.035,
                ),
              ))
        ],
      ),
      body: isLoading
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      itemCount: categoryModel?.length ?? 0,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (BuildContext context, int index) {
                        CategoryModel category = categoryModel![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Subcategory(
                                        Model: category,
                                      )),
                            );
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
                                              category.image == null
                                                  ? ''
                                                  : category.image,
                                              height: size.height * 0.08,
                                              width: size.height * 0.08,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          500),
                                                  child: Image(
                                                      height:
                                                          size.height * 0.08,
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
                                          category.name,
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

   CategoryObject? categoryObject;
   List<CategoryModel>? categoryModel;

  callAPICategory(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> body = Map<String, dynamic>();

    body['empid'] = widget.employerId;

    Map<String, String> header = Map<String, String>();

    FocusScope.of(context).requestFocus(FocusNode());

    ApiManager networkCal =
        ApiManager(APIConstants.getCategory, body, false, header);

    networkCal.callPostAPI(context).then((response) {
      print('Back from api');
      setState(() {
        isLoading = false;
      });

      bool status = response['status'];
      print(status);
      if (status == true) {
        categoryObject = CategoryObject.fromMap(response);
        print("status  " + categoryObject!.status.toString());
        if (categoryObject != null) {
          categoryModel = categoryObject!.response!;
        }
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
}
