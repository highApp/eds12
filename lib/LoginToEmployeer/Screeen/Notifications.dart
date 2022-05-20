
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Color.dart';
class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    /* var size = MediaQuery.of(context).size;*/
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        backgroundColor: colorWhite,
        centerTitle: false,
        title: Text(
          "Notifications", style: TextStyle(color: colorText, fontSize: 17,
            fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace_outlined, size: 25,
            color: colorText,),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  /*  onTap: (){
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) => Notifications()));
                          },*/
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15,
                        vertical: 15),
                    decoration: BoxDecoration(
                        color: colorPay,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Account Activation',
                                  style: TextStyle(color: colorText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                  textAlign: TextAlign.justify,
                                ),
                                Text(
                                  '29 may 2021',
                                  style: TextStyle(color: colorTex,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),

                            Text(
                            "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface .",
                              style: TextStyle(color: colorTex,fontWeight: FontWeight.w500,
                                  fontSize: 15
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(height: 10,),
                          ]
                      ),
                    ),
                  ),
                );


              },),
          ],
        ),
      ),

    );
  }
}
