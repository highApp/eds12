import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:eds/models/bNameListModel.dart';
import 'package:eds/models/bNameModel.dart';
import 'package:flutter/material.dart';


class ApiController {
  Dio? dio;

  ApiController() {
    BaseOptions options = BaseOptions(
      // baseUrl: "https://azeruser.greenspoints.com/public/api",
        receiveDataWhenStatusError: true,
        connectTimeout: 60 * 1000,
        receiveTimeout: 60 * 1000);
    dio = Dio(options);
  }

// reg



  //category list id
  // Future<BNameModel?> getBName() async {
  //   log('Started');
  //   final Map<String, dynamic> data = {
  //     'empid': '157',
  //   };
  //
  //   final formData = FormData.fromMap(data);
  //   const url = "https://eds.greenspoints.com/public/api/getPNames";
  //   try {
  //     debugPrint('API Call 1');
  //     Response response = await dio!.post(url,);
  //     // Response response = await dio!.post(
  //     //   url,
  //     // );
  //     debugPrint('API Call 2 Category');
  //     if (response.statusCode == 200) {
  //       print('Success - getCategoryList - ${response.data}');
  //       //  debugPrint(
  //       //   'statusCode - ${response.statusCode} - Response - ${response.data}');
  //       return BNameModel.fromJson(response.data);
  //     }
  //     throw response.data;
  //   } on DioError catch (e) {
  //     // print(e.response!.data["message"]);
  //
  //     rethrow;
  //   }
  // }
  Future<BNameModel?> getBName({
  String? bid
}) async {
    final data = {
      'empid': bid,
    };
    final formData = FormData.fromMap(data);
    const url = "https://eds.greenspoints.com/public/api/getPNames";
    try {
      debugPrint('API bnameCall 1');
      Response response = await dio!.post(url,
          data: formData,

      );
      debugPrint('API pasteventappliedjobs Call 2');
      if (response.statusCode == 200) {
        print(response);
        //  debugPrint(
        //   'statusCode - ${response.statusCode} - Response - ${response.data}');
        return BNameModel.fromJson(response.data);
      }
      throw response.data;
    } on DioError catch (e) {
      // print(e.response!.data["message"]);

      rethrow;
    }
  }





//


  Future<BListModel?> getlist({
    String? bid,
    String? pid,
    String? startDate,
    String? endDate,


  }) async {
    final data = {
      'empid': bid,
      'pname': pid,
      'start_date': startDate,
      'end_date': endDate,
    };
    final formData = FormData.fromMap(data);
    const url = "https://eds.greenspoints.com/public/api/getPNameExpenses";
    try {
      debugPrint('API bnameCall 1');
      Response response = await dio!.post(url,
        data: formData,

      );
      debugPrint('API  Call 2');
      if (response.statusCode == 200) {
        print(response);
        //  debugPrint(
        //   'statusCode - ${response.statusCode} - Response - ${response.data}');
        return BListModel.fromJson(response.data);
      }
      throw response.data;
    } on DioError catch (e) {
      // print(e.response!.data["message"]);

      rethrow;
    }
  }










}
