import 'package:dal/network/end_points.dart';
import 'package:dio/dio.dart';

class CategoriesAPIs {
  Dio _dio = Dio();

  Future<dynamic> getRowCategories(int pageNumber, int pageSize) async {
    final response =
        await _dio.get(EndPoints.getAllCategories(pageNumber, pageSize));
    if (response.statusCode == 200) {
      print('\n1-${response.data}');
      return response.data;
    } else {
      print('EEEEERRROR :${response.statusCode}');
      throw Exception('Can not Load Raw PostsWithSellers');
    }
  }

  Future<dynamic> getCities() async {
    final response = await _dio.get(EndPoints.getAllCities);

    if (response.statusCode == 200) {
      print('\n1-${response.data}');
      return response.data;
    } else {
      print('EEEEERRROR :${response.statusCode}');
      throw Exception('Can not Load Raw PostsWithSellers');
    }
  }
}
