import 'package:flutter/material.dart';

import '../Color.dart';

class CustomBottomSheetCamera {
  static bottomSheet(BuildContext context, VoidCallback onpressCamera,
      VoidCallback onPressGallery) {
    double size = MediaQuery.of(context).size.width;
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            color: Colors.grey[200],
            height: size * 0.22,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: size * 0.49,
                    child: GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.camera_alt_outlined,
                            size: size * 0.065,
                            color: colorPrimary,
                          ),
                          SizedBox(
                            height: size * 0.03,
                          ),
                          Text(
                            "Camera",
                            style: TextStyle(
                              fontSize: size * 0.034,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    onpressCamera();
                  },
                ),
                Expanded(
                  child: VerticalDivider(),
                ),
                Container(
                  width: size * 0.49,
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.photo_album_outlined,
                          size: size * 0.065,
                          color: colorPrimary,
                        ),
                        SizedBox(
                          height: size * 0.03,
                        ),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            fontSize: size * 0.034,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      onPressGallery();
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
