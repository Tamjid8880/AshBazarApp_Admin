import 'dart:developer';

import 'package:admin/models/api_response.dart';
import 'package:admin/utility/snack_bar_helper.dart';
import 'package:get/get.dart';

import '../../../models/order.dart';
import '../../../services/http_services.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/data/data_provider.dart';

class OrderProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final orderFormKey = GlobalKey<FormState>();
  TextEditingController trackingUrlCtrl = TextEditingController();
  String selectedOrderStatus = 'pending';
  Order? orderForUpdate;

  OrderProvider(this._dataProvider);

  //TODO: should complete updateOrder
  updateOrder() async {
    try {
      if (orderForUpdate != null) {
        Map<String, dynamic> order = {
          'trackingUrl': trackingUrlCtrl.text.trim(),
          'orderStatus': selectedOrderStatus
        };
        final response = await service.updateItem(
            endpointUrl: 'orders',
            itemData: order,
            itemId: orderForUpdate?.sId ?? '');
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            log('order updated successfully');
            _dataProvider.getAllOrders();
          } else {
            SnackBarHelper.showErrorSnackBar('${apiResponse.message}');
            log('order updated failed');
          }
        } else {
          SnackBarHelper.showErrorSnackBar(
              'Error ${response.body?['message'] ?? response.statusText}');
        }
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
  }

  //TODO: should complete deleteOrder
  deleteOrder(Order order) async {
    try {
      Response response = await service.deleteItem(
          endpointUrl: 'orders', itemId: order.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('order deleted successfully');
          _dataProvider.getAllOrders();
        } else {
          SnackBarHelper.showErrorSnackBar('${apiResponse.message}');
          log('order deleted failed');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'Error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
  }

  updateUI() {
    notifyListeners();
  }
}
