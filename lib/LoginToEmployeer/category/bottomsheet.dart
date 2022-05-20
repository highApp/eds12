import 'package:flutter/material.dart';

import '../../Color.dart';
class BottomComment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all( 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      /*  onTap: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) => Notifications()));
                                },*/
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,
                            vertical: 10),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                maxRadius: 30,
                                backgroundColor: colorBlack,
                              ),


                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.05),
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Jacob Howard ',
                                      style: TextStyle(fontWeight: FontWeight.bold,
                                          color: colorText),
                                      children: const <TextSpan>[
                                        TextSpan(
                                            text: 'Mentioned you in a comment “Hahaha, I forgot that lol”.',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.5
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ]
                        ),
                      ),
                    );
                  } ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),

                decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey,width: 0.5)
                ),
                width: MediaQuery.of(context).size.width*0.70,
                height: MediaQuery.of(context).size.height*0.05,
                child: TextField(
                  cursorColor: colorBlack,

                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.send,color:  Colors.grey,),
                      contentPadding:EdgeInsets.symmetric(vertical: 15,horizontal: 16),
                      border: InputBorder.none,
                      hintText: "Write Message"
                  ),
                ),

              )




            ],
          ),
        ),
      ),
    );
  }
}