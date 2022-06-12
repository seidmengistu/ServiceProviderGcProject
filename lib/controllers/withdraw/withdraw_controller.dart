import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:service_provider/models/Payment/payment_method_model.dart';
import 'package:service_provider/models/withdraw/withdraw_model.dart';

import 'package:service_provider/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WithdrawController extends GetxController {
  var dashboardInformation = <WithdrawModel>[].obs;
  bool _isLoad = false;

  bool get isLoad => _isLoad;
  var selectedType = 1.obs;

  var amountController = TextEditingController();

  Future<void> requestwithdraw() async {
    String token = '';
    SharedPreferences pre = await SharedPreferences.getInstance();
    token = pre.getString(AppConstants.TOKEN) ?? "None token";
    print(token);

    String amount = amountController.text.trim();
    print(amount);
    final String endPoint =
        "https://gcproject.awraticket.com/service_provider/withdraw_request";

    Dio.FormData formData = new Dio.FormData.fromMap({
      "amount": amount,
    });
    Dio.Dio dio = new Dio.Dio();
    dio.options.headers["Authorization"] = "Bearer $token";
    dio.post(endPoint, data: formData).then((response) {
      if (response.statusCode == 201) {
        EasyLoading.dismiss();
        Get.snackbar(
          "Success",
          "Withdraw Request Send Successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
          margin: EdgeInsets.all(15),
          forwardAnimationCurve: Curves.bounceOut,
        );
      } else if (response.statusCode == 202) {
        EasyLoading.dismiss();
        Get.snackbar(
          "Information!",
          "You have a pending request",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.amber,
          duration: const Duration(seconds: 3),
          margin: EdgeInsets.all(15),
          forwardAnimationCurve: Curves.bounceIn,
        );
      }
      // ignore: invalid_return_type_for_catch_error
    }).catchError((error) => print(error));
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchInformation();
  // }

  // Future<void> fetchInformation() async {
  //   String token = '';

  //   late Map<String, String> _mainHeaders;
  //   SharedPreferences pre = await SharedPreferences.getInstance();
  //   token = pre.getString(AppConstants.TOKEN) ?? "None token";

  //   _mainHeaders = {
  //     'Content-type': 'application/json; charset=UTF-8',
  //     'Authorization': 'Bearer $token',
  //   };
  //   final response = await http.get(
  //       Uri.parse(
  //           "http://www.gcproject.awraticket.com/service_provider/withdraw_data"),
  //       headers: _mainHeaders);

  //   if (response.statusCode == 200) {
  //     PaymentModel _dashboardModel =
  //         PaymentModel.fromJson(jsonDecode(response.body));

  //     dashboardInformation.add(
  //       PaymentModel(
  //         id: _dashboardModel.id,
  //         accountnumber: _dashboardModel.accountnumber,
  //         acountHolder: _dashboardModel.acountHolder,
  //         paymenttype: _dashboardModel.paymenttype,
  //       ),
  //     );

  //     update();
  //   } else {
  //     print("iNdashboard");
  //   }
  // }

}
