import 'package:dal/data_layer/data_providers/categories_apis.dart';
import 'package:dal/data_layer/models/category_model.dart';
import 'package:dal/data_layer/models/city_model.dart';

class CategoriesRepositoryImp {
  CategoriesAPIs catAPI = CategoriesAPIs();

  Future<CategoryModelRes> getAllCategories({
    bool refreshed = false,
    int pageNumber,
    int pageSize,
  }) async {
    CategoryModelRes allCategories = CategoryModelRes();
    // List<CategoryModel> catLists = [];
    final rowCategories = await catAPI.getRowCategories(pageNumber, pageSize);
    allCategories = CategoryModelRes.fromJson(rowCategories);
    // catLists = allCategories.data.categories;
    return allCategories;
  }

  Future<List<CityModel>> getAllCities() async {
    CityModelRes allCities = CityModelRes();
    List<CityModel> citiesLists = [];
    final rowCategories = await catAPI.getCities();
    allCities = CityModelRes.fromJson(rowCategories);
    citiesLists = allCities.data.cities;
    return citiesLists;
  }
}
