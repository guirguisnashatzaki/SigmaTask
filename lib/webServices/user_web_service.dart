import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sigma_task/constants/strings.dart';

class UserWebService{
  late Dio dio;

  //for testing only
  UserWebService.test(this.dio);

  UserWebService() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60)
    );

    dio = Dio(options);
  }


  Future<List<dynamic>> getAllUsers(int limit) async {
    try{
      Response response = await dio.get("users?limit=$limit");
      if (kDebugMode) {
        print(response.data.toString());
      }
      return response.data['users'];
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }
}