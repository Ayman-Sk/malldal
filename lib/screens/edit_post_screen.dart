import 'dart:io';
import 'package:path/path.dart' as pathLib;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:card_swiper/card_swiper.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../business_logic_layer/user_provider.dart';
import '../data_layer/data_providers/categories_apis.dart';
import '../theme/app_colors.dart';
import '../utils/utils.dart';
import '../widgets/dropdown_model.dart';
import '../widgets/multi_selected_drop_down.dart';

class EditPostScreen extends StatefulWidget {
  static const routeName = 'EditPostScreen';
  final String postId;
  final String productName;
  final String productDetails;
  final String productPrice;
  final List<String> imagesPaths;

  const EditPostScreen({
    this.productName,
    this.productDetails,
    this.productPrice,
    this.postId,
    this.imagesPaths,
    Key key,
  }) : super(key: key);

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  final ImagePicker imgpicker = ImagePicker();
  FocusNode _numberFocusNode;
  TextEditingController titleController;
  TextEditingController bodyController;
  TextEditingController priceController;
  List<Asset> images = <Asset>[];
  File file;
  bool imageselected = false;
  bool loading = false;
  List<String> categoryList = [];
  List<String> citiesList = [];
  List<String> listOfCities = [];
  List<String> listOfCategories = [];
  // List<DropdownMenuItem<DropDownListModel>> _citiesdropDownMenueItems;
  // List<DropdownMenuItem<DropDownListModel>> _categorydropDownMenueItems;
  CategoriesAPIs catAPI = CategoriesAPIs();
  List<File> files = [];
  List<String> paths = [];
  // Dio _dio = Dio();

  @override
  void initState() {
    titleController = TextEditingController(text: widget.productName);
    bodyController = TextEditingController(text: widget.productDetails);
    priceController = TextEditingController(text: widget.productPrice);
    paths = widget.imagesPaths;
    // paths = editAllNetworkImagePaths(widget.imagesPaths);
    paths.length == 0 ? imageselected = false : imageselected = true;

    setState(() {});
    // getCategories();
    // getCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('legth');
    print(paths.length);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).editProduct,
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              buildEditText(
                  title: AppLocalizations.of(context)
                      .enterProductName, //'أدخل اسم المنتج',
                  subTitle: AppLocalizations.of(context).name, //'الاسم',
                  erorrText: AppLocalizations.of(context)
                      .shortName, //'الاسم قصير جدا',
                  editTextController: titleController,
                  isNumber: false),
              buildEditText(
                  title: AppLocalizations.of(context)
                      .enterProductDetails, //,'أدخل تفاصيل المنتج',
                  subTitle: AppLocalizations.of(context).details, //'التفاصيل',
                  erorrText: AppLocalizations.of(context)
                      .shortText, //'النص  قصير جدا',
                  editTextController: bodyController,
                  isNumber: false),
              buildEditText(
                  title: AppLocalizations.of(context)
                      .enterProductPrice, //'أدخل سعر المنتج',
                  subTitle: AppLocalizations.of(context).price, //'السعر',
                  erorrText: AppLocalizations.of(context)
                      .wrongNumber, //'الرقم غير صحيح',
                  editTextController: priceController,
                  isNumber: true),
              // buildDropDownList(
              //     title: AppLocalizations.of(context)
              //         .chooseProductCategory, //'فئة المنتج',
              //     listOfItems: categoryList,
              //     func: getCategories,
              //     items: _categorydropDownMenueItems,
              //     isCities: false),
              // buildDropDownList(
              //     title: AppLocalizations.of(context)
              //         .chooseProductCities, //'المدينة:',
              //     listOfItems: citiesList,
              //     func: getCities,
              //     items: _citiesdropDownMenueItems,
              //     isCities: true),
              //gender

              ///
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context).canAddProductImages,
                  // 'بإمكانك اختيار صور منتجك هنا:',
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),

              ///
              imageselected == true
                  ? Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Swiper(
                        loop: false,
                        itemCount: paths.length == 0 ? 1 : paths.length,
                        pagination: const SwiperPagination(),
                        control: const SwiperControl(),
                        indicatorLayout: PageIndicatorLayout.COLOR,
                        autoplay: false,
                        itemBuilder: (context, index) {
                          print(paths[0]);
                          if (paths.length != 0) {
                            final path = paths[index];
                            return Stack(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: Image.file(
                                    File(path),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 15,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        paths.remove(path);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: MediaQuery.of(context).size.width /
                                          10,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container(
                              color: AppColors.accent,
                              height: MediaQuery.of(context).size.height / 2,
                              child: Center(
                                child: CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width / 6,
                                    backgroundColor: Colors.white70,
                                    child: IconButton(
                                      onPressed: () async {
                                        FilePickerResult result =
                                            await FilePicker.platform.pickFiles(
                                          allowMultiple: true,
                                          type: FileType.custom,
                                          allowedExtensions: [
                                            'jpg',
                                            'png',
                                            'jpeg'
                                          ],
                                        );
                                        if (result != null) {
                                          setState(() {
                                            result.paths.forEach((element) {
                                              if (!paths.contains(element)) {
                                                paths.add(element);
                                              }
                                            });
                                            // paths.addAll(result.paths.toList());
                                            imageselected = true;
                                          });
                                          print(paths);
                                        }
                                      },
                                      icon: Icon(Icons.add),
                                      iconSize:
                                          MediaQuery.of(context).size.width /
                                              10,
                                      color: AppColors.primary,
                                    )),
                              ),
                            );
                          }
                        },
                      ),
                    )
                  // Center(
                  //     child: Container(
                  //       padding: EdgeInsets.all(16),
                  //       width: MediaQuery.of(context).size.width,
                  //       // height: 250,
                  //       margin: EdgeInsets.symmetric(
                  //         horizontal: 1.0,
                  //       ),
                  //       child: CircleAvatar(
                  //         maxRadius: 130,
                  //         backgroundColor: AppColors.primary,
                  //         child: CircleAvatar(
                  //           maxRadius: 125,
                  //           backgroundImage: FileImage(File(paths[0])),
                  //         ),
                  //       ),
                  //     ),
                  //   )
                  : Container(
                      color: AppColors.accent,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Center(
                        child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width / 6,
                            backgroundColor: Colors.white70,
                            child: IconButton(
                              onPressed: () async {
                                FilePickerResult result =
                                    await FilePicker.platform.pickFiles(
                                  allowMultiple: true,
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png', 'jpeg'],
                                );
                                if (result != null) {
                                  setState(() {
                                    result.paths.forEach((element) {
                                      if (!paths.contains(element)) {
                                        paths.add(element);
                                      }
                                    });
                                    // paths.addAll(result.paths.toList());
                                    imageselected = true;
                                  });
                                  print(paths);
                                }
                              },
                              icon: Icon(Icons.add),
                              iconSize: MediaQuery.of(context).size.width / 10,
                              color: AppColors.primary,
                            )),
                      ),
                    ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: AppColors.accent),
                  child: Center(
                    child: Text(
                      imageselected == true
                          ? AppLocalizations.of(context).addAnotherPhoto
                          : AppLocalizations.of(context).addPhoto,

                      // 'إضافة صورة',
                    ),
                  ),
                  onPressed: () async {
                    FilePickerResult result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'png', 'jpeg'],
                    );
                    if (result != null) {
                      setState(() {
                        result.paths.forEach((element) {
                          if (!paths.contains(element)) {
                            paths.add(element);
                          }
                        });
                        // paths.addAll(result.paths.toList());
                        imageselected = true;
                      });
                      print(paths);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: AppColors.accent),
                  child: Center(
                    child: loading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context).edit,
                            // 'إضافة',
                          ),
                  ),
                  onPressed: () async {
                    if (!_formkey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      return Future.value(false);
                    }
                    _formkey.currentState.save();
                    bool res;
                    res = await _submit(
                      title: titleController.text,
                      body: bodyController.text,
                      priceDetails: priceController.text,
                      sellerId:
                          Provider.of<UserProvider>(context, listen: false)
                              .userId,
                      postId: widget.postId,
                      imagesPath: paths,
                    );
                    if (res) {
                      Utils.showToast(
                        message: AppLocalizations.of(context).productAdded,
                        backgroundColor: AppColors.primary,
                        textColor: Theme.of(context).textTheme.bodyText1.color,
                      );
                      // Navigator.of(context).pushReplacementNamed(
                      //   SellerAccountScreen.routeName,
                      // );
                      Navigator.of(context).pop();
                    } else {
                      Utils.showToast(
                        message: AppLocalizations.of(context).error,
                        backgroundColor: AppColors.primary,
                        textColor: Theme.of(context).textTheme.bodyText1.color,
                      );
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _submit({
    String title,
    String body,
    String priceDetails,
    String sellerId,
    String postId,
    List<String> imagesPath,
  }
      //{String name, String email} في حال بدي
      ) async {
    // if (!imageselected) {
    //   Utils.showToast(
    //     message: 'لم تختر صورة بعد',
    //     backgroundColor: AppColors.primary,
    //     textColor: AppColors.background,
    //   );
    // }
    //  else
    {
      setState(() {
        loading = true;
      });

      Map<String, dynamic> data = {
        'title': title,
        'body': body,
        'priceDetails': priceDetails,
        'seller_id': sellerId,
        'images': imagesPath,
        // 'categories': categories,
        // "cities[0]": "1",
        // "cities[1]": "2",
        // 'cities': c
        // 'cities[0]': cities[1].toString()
      };
      // for (int i = 0; i < cities.length; i++) {
      //   data['cities[$i]'] = (int.parse(cities[i]) + 1).toString();
      // }
      // for (int i = 0; i < categories.length; i++) {
      //   data['categories[$i]'] = (int.parse(categories[i]) + 1).toString();
      // }
      print("Sent create Product Data");
      print(data);

      return await Provider.of<UserProvider>(context, listen: false)
          .editPostRequest(
        data,
        postId,
      );
    }
  }

  List<String> editAllNetworkImagePaths(List<String> paths) {
    List<String> truePaths = [];
    paths.forEach((element) async {
      print(element);
      String path = await getTruePaths(element);
      truePaths.add(path);
    });
    print('all');
    print(paths.length);
    print(truePaths);
    return truePaths;
  }

  Future<String> getTruePaths(String path) async {
    print('sub');
    print(widget.imagesPaths);
    print(path.substring(0, 4));
    if (path.substring(0, 4) == 'http') {
      String fileName = path.split('/').last;
      var s = await http.get(Uri.parse(path));
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      File file = new File(pathLib.join(documentDirectory.path, fileName));
      file.writeAsBytes(s.bodyBytes);
      print('true');
      print(documentDirectory.path + fileName);
      return documentDirectory.path + fileName;
    }
    return path;
  }

  void addCityFunction(List<String> listOfItems) {
    listOfCities = listOfItems;
    print('Cities' + listOfCities.toString());
  }

  void addCategoryFunction(List<String> listOfItems) {
    listOfCategories = listOfItems;
    print('Categories' + listOfCategories.toString());
  }

  Widget buildDropDownList(
      {String title,
      List<String> listOfItems,
      Function() func,
      List<DropdownMenuItem<DropDownListModel>> items,
      bool isCities}) {
    print('aaaaaaaaaaaaassssssddddddd');
    print(isCities);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
              // color: AppColors.primary,
              fontSize: 20,
            ),
          ),
        ),
        items == null
            ? TextButton(
                onPressed: () => func, //func()????
                child: Icon(Icons.refresh),
              )
            : CustomMultiselectDropDown(
                listOFStrings: listOfItems,
                selectedList: isCities ? addCityFunction : addCategoryFunction,
              ),
      ],
    );
  }

  Widget buildEditText(
      {String title,
      String subTitle,
      String erorrText,
      TextEditingController editTextController,
      bool isNumber}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            // 'أدخل اسم المنتج',
            style: TextStyle(
              // color: AppColors.primary,
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: editTextController,
            keyboardType: isNumber ? TextInputType.number : TextInputType.name,
            decoration: InputDecoration(
              labelText: subTitle,
              labelStyle: TextStyle(color: AppColors.primary),
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: AppColors.primary,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2.0,
                ),
              ),
            ),
            validator: (value) {
              if (isNumber) {
                if (value == null || value.isEmpty) {
                  return title;
                }
                if (value.length <= 0) return erorrText;
                return null;
              } else {
                if (value == null || value.isEmpty) {
                  return title;
                }
                if (value.length <= 2) return erorrText;
                return null;
              }
            },
            onSaved: (value) {
              // customerProvider.setName(titleController.text);
            },
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_numberFocusNode);
            },
          ),
        ),
      ],
    );
  }

  // Future<void> getCategories(
  //     //{String name, String email} في حال بدي
  //     ) async {
  //   final response = await _dio.get(EndPoints.getAllCategories(1, 30));
  //   // if (response == null) {
  //   //   setState(() {
  //   //     loading = true;
  //   //   });
  //   // }
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       List categories = response.data['data']['data'];
  //       categories.forEach((element) {
  //         categoryList.add(element['title']);
  //       });
  //       _categorydropDownMenueItems =
  //           DropDownListModel.buildDropDownMenuItemFromData(
  //               response.data, false);
  //       // _selectedcategory = _categorydropDownMenueItems[0].value;
  //     });
  //   } else {
  //     setState(() {
  //       _categorydropDownMenueItems = null;
  //     });
  //   }
  // }

  // Future<void> getCities(
  //     //{String name, String email} في حال بدي
  //     ) async {
  //   final response = await _dio.get(EndPoints.getAllCities);

  //   // if (response == null) {
  //   //   setState(() {
  //   //     loading = true;
  //   //   });
  //   // }
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       List cities = response.data['data']['data'];
  //       cities.forEach((element) {
  //         citiesList.add(element['cityName']);
  //       });
  //       _citiesdropDownMenueItems =
  //           DropDownListModel.buildDropDownMenuItemFromData(
  //               response.data, true);
  //       // _selectedcity = _citiesdropDownMenueItems[0].value;
  //     });
  //   } else {
  //     setState(() {
  //       _citiesdropDownMenueItems = null;
  //       print(_citiesdropDownMenueItems);
  //     });
  //   }
  // }
}
